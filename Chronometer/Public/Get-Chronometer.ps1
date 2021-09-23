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

            if ($null -eq $ScriptBlock) {
                # check whether $Path was a single (.ps1) file
                $Item=Get-Childitem -LiteralPath $Path -File -ErrorAction SilentlyContinue
                if ($Item.Count -eq 1 -and $Item.Extension -in '.ps1') {
                    $ScriptBlock=[ScriptBlock]::Create("& $($Item.FullName)")
                }
            }

            if ( $null -ne $Chronometer.breakPoint -and $null -ne $ScriptBlock )
            {
                Write-Verbose "Executing Script"
                [ScriptProfiler]::Start()
                [void] $ScriptBlock.Invoke($Path)

                Write-Verbose "Clearing Breakpoints"
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
