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
