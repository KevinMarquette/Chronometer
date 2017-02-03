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

    $Chronometer = [Chronometer]::New()
    $breakPoint = $Chronometer.AddBreakpoint($Path)

    [ScriptProfiler]::Start()
    [void] $ScriptBlock.Invoke()

    $Chronometer.ClearBreakpoint()

    foreach($node in [ScriptProfiler]::Queue.GetEnumerator())
    {
        $Chronometer.AddExecution($node)
    }

    foreach($script in $fileMap.Keys)
    {
        foreach($line in $fileMap[$script])
        {
            Write-Output $line
        }
    }
}
