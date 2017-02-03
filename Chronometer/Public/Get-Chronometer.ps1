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
