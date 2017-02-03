class Chronometer
{
    [hashtable]$FileMap = @{}
    $Breakpoint = @()

    [void]AddBreakpoint([string[]]$Path)
    {
        foreach($file in (Resolve-Path $Path -ea 0))
        {
            $script = [MonitoredScript]@{Path=$file.Path}
            $lines = $script.SetScript($file)

            $this.fileMap[$file.Path] = $script

            $breakpointParam = @{
                Script = $file
                Line = (1..$lines)
                Action = {[ScriptProfiler]::RecordExecution( $_) }
            }
            $this.breakPoint += Set-PSBreakpoint @breakpointParam
        }
    }

    [void]ClearBreakpoint()
    {
        Remove-PSBreakpoint $this.Breakpointbreakpoint
    }

    [void] AddExecution([hashtable]$Execution)
    {
        $this.FileMap[$Execution.Breakpoint.Script].AddExecution($Execution)
    }
}

class MonitoredScript
{
    [string]$Path
    [System.Collections.ArrayList]$Line

    $lastNode = $null
    $lastRecord = $null

    MonitoredScript()
    {
        $this.Line = [System.Collections.ArrayList]::New()
    }

    [int] SetScript([string]$Path)
    {
        Get-Content -Path $Path | %{ $this.Line.Add( [ScriptLine]@{text=$_})}
        return $this.Line.Count()
    }

    [void] AddExecution([hashtable]$node)
    {
        $record = $this.Line[$node.Breakpoint.Line-1]
        $record.LineNumber = $node.Breakpoint.Line - 1

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
        }

        $this.lastRecord = $record
        $this.lastNode = $node
    }
}