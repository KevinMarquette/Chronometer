function Format-Chronometer
{
    <#
        .Description
        Generates a report from a Chronometer

        .Example                
        $script = ls C:\workspace\PSGraph\PSGraph -Recurse -Filter *.ps1
        $resultes = Get-Chronometer -Path $script.fullname  -ScriptBlock {Invoke-Pester C:\workspace\PSGraph}
        $results | Format-Chronometer -WarnAt 20 -ErrorAt 200
    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingWriteHost", "")]
    [cmdletbinding(DefaultParameterSetName = 'Script')]
    param(
        # This is a MonitoredScript object from Get-Chronometer
        [Parameter(
            ValueFromPipeline = $true,
            ParameterSetName = 'Script'
        )]
        [MonitoredScript[]]
        $InputObject,

        # This is a ScriptLine object from a MonitoredScript object
        [Parameter(
            ValueFromPipeline = $true,
            ParameterSetName = 'Line'
        )]
        [ScriptLine[]]
        $Line,

        # If the average time of a command is more than this, the output is yellow
        [int]
        $WarningAt = 20,

        #If the average time of a comamand is more than this, the output is red
        [int]
        $ErrorAt = 200,

        # Forces the report to show scripts with no execution time
        [switch]
        $ShowAll
    )

    process
    {
        try
        {
            foreach ( $script in $InputObject )
            {            
                if ( $script.ExecutionTime -ne [TimeSpan]::Zero -or $ShowAll )
                {
                    Write-Host ''
                    Write-Host "Script: $($script.Path)" -ForegroundColor Green
                    Write-Host "Execution Time: $($script.ExecutionTime)" -ForegroundColor Green

                    $script.line | Format-Chronometer -WarningAt $WarningAt -ErrorAt $ErrorAt
                }
            }

            foreach ( $command in $Line )
            {
                Write-ScriptLine $command -WarningAt $WarningAt -ErrorAt $ErrorAt
            }            
        }
        catch
        {
            $PSCmdlet.ThrowTerminatingError($PSItem)
        }
    }
}
