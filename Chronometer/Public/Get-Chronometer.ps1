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
        [Parameter(
            ValueFromPipeline = $true
        )]
        [Object[]]
        $Path,

        # Line numbers within the script file to measure
        [int[]]
        $LineNumber = $null,

        # The script to start the scrupt or execute other commands
        [Parameter(Position = 0)]
        [alias('Script', 'CommandScript')]
        [scriptblock]
        $ScriptBlock             
    )

    process 
    {
        try
        {
            if ( $null -eq $Path )
            {
                $Path = Get-ChildItem -Recurse -Include *.psm1, *.ps1 -File
            }

            if ( $Path.FullName )
            {
                $Path = $Path.FullName
            }

            $Chronometer = [Chronometer]::New()

            Write-Verbose "Setting breakpoints"
            $Chronometer.AddBreakpoint($Path, $LineNumber)

            if ( $null -ne $Chronometer.breakPoint -and $null -ne $ScriptBlock )
            {
                Write-Verbose "Executing Script"
                [ScriptProfiler]::Start()
                [void] $ScriptBlock.Invoke($Path)

                # Add a dummy stub to process last line
                [ScriptProfiler]::RecordExecution([ScriptProfiler]::LastNode)

                Write-Verbose "Clearing Breapoints"
                $Chronometer.ClearBreakpoint()

                Write-Verbose "Processing data"
                foreach ( $node in [ScriptProfiler]::Queue.GetEnumerator() )
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
        catch
        {
            $PSCmdlet.ThrowTerminatingError($PSItem)
        }
    }
}
