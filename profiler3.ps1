
class ScriptProfiler {

    static [System.Collections.Queue] $Queue
    static [System.Diagnostics.Stopwatch] $Timer

    static [void] Start()
    {
        [ScriptProfiler]::Queue = New-Object System.Collections.Queue
        [ScriptProfiler]::Timer = [System.Diagnostics.Stopwatch]::StartNew()
    }
   
    static [void] RecordExecution ([System.Management.Automation.LineBreakpoint]$InputObject)
    {
        [ScriptProfiler]::Queue.Enqueue(@{
            Breakpoint = $InputObject
            ElapsedMilliseconds = [ScriptProfiler]::Timer.ElapsedMilliseconds
        })
    }
}

class ScriptLine
{
    [float] $Milliseconds = 0
    [float]   $HitCount = 0
    [float] $Min = [float]::MaxValue
    [float] $Max = [float]::MinValue
    [float] $Average = 0
    [int] $LineNumber
    [string] $Path
    [string] $Text

    [void]AddExecutionTime([float]$Milliseconds)
    {
        $this.Milliseconds += $Milliseconds
        $this.HitCount += 1
        $this.Average = $this.Milliseconds / $this.HitCount
        
        if($Milliseconds -lt $this.Min)
        {
            $this.Min = $Milliseconds
        }

        if($Milliseconds -gt $this.Max)
        {
            $this.Max = $Milliseconds
        }
    }

    [string] ToString()
    {
        $values = @(
            $this.Milliseconds
            $this.HitCount
            $this.Average
            $this.Text
        )
        return ("[{0:0000}ms,{1:0000},{2:0000}ms]  {3}" -f $values)
    }
}


function Get-Chronometer
{
    [CmdletBinding()]
    param(
        [string[]]
        $Path,

        [scriptblock]
        $CommandScript

    )

    $breakPoint = @()
    $fileMap = @{}

    foreach($file in (Resolve-Path $Path))
    {
        $fileMap[$file.Path] = @( Get-Content -Path $file | %{[ScriptLine]@{text=$_;path=$file.path}})

        $lines = $fileMap[$file.Path].count
        $breakPoint += Set-PSBreakpoint -Script $file -Line (1..$lines) -Action {[ScriptProfiler]::RecordExecution( $_) }
    }

    [ScriptProfiler]::Start()
    [void] $CommandScript.Invoke()

    Remove-PSBreakpoint $breakpoint

    #$fileMap | ConvertTo-Json
  

    foreach($node in [ScriptProfiler]::Queue.GetEnumerator())
    {
        $record = $fileMap[$node.Breakpoint.Script][$node.Breakpoint.Line-1]
        $record.LineNumber = $node.Breakpoint.Line - 1

        if($lastNode)
        {
            $duration = $node.ElapsedMilliseconds - $lastNode.ElapsedMilliseconds
        }
        else
        {
            $duration = $node.ElapsedMilliseconds
        }
        
        
        if($lastRecord)
        {
            $lastRecord.AddExecutionTime($duration)       
        }

        $lastRecord = $record
        $lastNode = $node
    }

    foreach($script in $fileMap.Keys)
    {
        foreach($line in $fileMap[$script])
        {
            Write-Output $line
        }
    }
}

Get-Chronometer -Path .\example.ps1 -CommandScript {.\example.ps1} -OutVariable results


$results | % ToString