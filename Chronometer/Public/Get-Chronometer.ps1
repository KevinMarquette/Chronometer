function Get-Chronometer
{
    <#
        .Description
        Loads a script and then tracks the line by line execution times

        .Example
        Get-Chronometer -Path .\example.ps1 -Script {
            .\example.ps1
        }
    #>
    [CmdletBinding()]
    param(
        # Script file to measure execution times on
        [string[]]
        $Path,

        # The script to start the scrupt or execute other commands
        [alias('Script','CommandScript')]
        [scriptblock]
        $ScriptBlock
    )

    $breakPoint = @()
    $fileMap = @{}

    foreach($file in (Resolve-Path $Path -ea 0))
    {
        $fileMap[$file.Path] = @( Get-Content -Path $file | %{[ScriptLine]@{text=$_;path=$file.path}})

        $lines = $fileMap[$file.Path].count
        $breakPoint += Set-PSBreakpoint -Script $file -Line (1..$lines) -Action {[ScriptProfiler]::RecordExecution( $_) }
    }

    [ScriptProfiler]::Start()
    [void] $ScriptBlock.Invoke()

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
