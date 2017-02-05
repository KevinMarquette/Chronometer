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
        if($this.Breakpoint -ne $null -and $this.Breakpoint.count -gt 0)
        {
            Remove-PSBreakpoint -Breakpoint $this.Breakpoint
        }
        
    }

    [void] AddExecution([hashtable]$Execution)
    {
        $script = $Execution.Breakpoint.Script
        if($this.FileMap.ContainsKey($script))
        {
            # Each script tracks it's own execution times
            $this.FileMap[$script].AddExecution($Execution)
        }
    }

    [MonitoredScript[]] GetResults()
    {
        return $this.FileMap.Values
    }
}

