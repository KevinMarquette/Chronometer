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

        # Line numbers within the script file to measure
        [int[]]
        $LineNumber = $null,

        # The script to start the scrupt or execute other commands
        [alias('Script','CommandScript')]
        [scriptblock]
        $ScriptBlock
    )

    $Chronometer = [Chronometer]::New()

    Write-Verbose "Setting breapoints"
    $Chronometer.AddBreakpoint($Path,$LineNumber)

    if($Chronometer.breakPoint -ne $null)
    {
        Write-Verbose "Executing Script"
        [ScriptProfiler]::Start()
        [void] $ScriptBlock.Invoke()

        Write-Verbose "Clearing Breapoints"
        $Chronometer.ClearBreakpoint()

        Write-Verbose "Processing data"
        foreach($node in [ScriptProfiler]::Queue.GetEnumerator())
        {
            $Chronometer.AddExecution($node)
        }

        Write-Output $Chronometer.GetResults()
    }
    else
    {
        Write-Warning "Parsing files did not result in any breakpoints"
    }
}
