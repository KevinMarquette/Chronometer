class MonitoredScript
{
    [string]$Path
    [System.Collections.Generic.List[ScriptLine]]$Line

    hidden $lastNode = $null
    hidden $lastRecord = $null

    [timespan]$ExecutionTime = 0
    [int]$LinesOfCode = 0

    MonitoredScript()
    {
        $this.Line = New-Object 'System.Collections.Generic.List[ScriptLine]'
    }

    [int] SetScript([string]$Path)
    {
        $lineNumber = 0
        foreach($command in ( Get-Content -Path $Path ))
        {
            $this.Line.Add( [ScriptLine]::New($command, $path, $lineNumber) )            
            $lineNumber++
        }
        $this.LinesOfCode = $this.Line.Count
        return $this.LinesOfCode
    }

    [void] AddExecution( [hashtable]$node )
    {
        # Line numbers start at 1 but the array starts at 0
        $lineNumber = $node.Breakpoint.Line - 1
        $record = $this.Line[$lineNumber]

        $record.AddExecution($node)

        # Calclate the delta in time
        if($this.lastNode)
        {
            $duration = $node.Elapsed - $this.lastNode.Elapsed
        }
        else
        {
            $duration = $node.Elapsed
        }        
        
        # The delta is how long the last command ran
        if($this.lastRecord)
        {
            $this.lastRecord.AddExecutionTime($duration) 
            $this.ExecutionTime += $duration      
        }

        $this.lastRecord = $record
        $this.lastNode = $node
    }

    [void] PostProcessing()
    {
        $this.lastNode = $null
        $this.ExecutionTime = 0
        foreach($node in $this.line)
        {
            $command = $node.text -replace '\s',''
            
            switch -Regex ($command)
            {
                '^}$|^}#|^$' {
                    if($node.HitCount -eq 0)
                    {
                        $node.HitCount = $this.lastNode.HitCount
                    }
                    $node.Milliseconds = 0
                    $node.Average = 0
                    $this.lastNode = $node
                }
                '^{$|^{#}' {
                    $node.Milliseconds = 0
                    $node.Average = 0
                    $this.lastNode = $node
                }
                default {
                    $this.lastNode = $node
                }
            }
            $this.ExecutionTime += $node.Milliseconds
        }
    }
}