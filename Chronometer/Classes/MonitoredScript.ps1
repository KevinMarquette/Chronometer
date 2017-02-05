class MonitoredScript
{
    [string]$Path
    [System.Collections.Generic.List[ScriptLine]]$Line

    hidden $lastNode = $null
    hidden $lastRecord = $null

    [float]$ExecutionTime = 0
    [int]$LinesOfCode = 0

    MonitoredScript()
    {
        $this.Line =New-Object 'System.Collections.Generic.List[ScriptLine]'
    }

    [int] SetScript([string]$Path)
    {
        Get-Content -Path $Path | %{ $this.Line.Add( [ScriptLine]@{text=$_;path=$path})}
        $this.LinesOfCode = $this.Line.Count
        return $this.LinesOfCode
    }

    [void] AddExecution([hashtable]$node)
    {
        # Line numbers start at 1 but the array starts at 0
        $lineNumber = $node.Breakpoint.Line - 1
        $record = $this.Line[$lineNumber]
        $record.LineNumber = $lineNumber

        if($this.lastNode)
        {
            $duration = $node.ElapsedMilliseconds - $this.lastNode.ElapsedMilliseconds
        }
        else
        {
            $duration = $node.ElapsedMilliseconds
        }        
        
        if($this.lastRecord)
        {
            $this.lastRecord.AddExecutionTime($duration) 
            $this.ExecutionTime += $duration      
        }

        $this.lastRecord = $record
        $this.lastNode = $node
    }
}