function Format-ChronometerToGridView
{
    <#
        .Description
        Generates a report from a Chronometer sending the output to one or more grid views

        .Example                
        $script = ls C:\workspace\PSGraph\PSGraph -Recurse -Filter *.ps1
        $resultes = Get-Chronometer -Path $script.fullname  -ScriptBlock {Invoke-Pester C:\workspace\PSGraph}
        $results | Format-ChronometerToGridView
    #>
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

        # Default width for the code statements, can be overridden
        [int]
        $StatementWidth = 132,

        # Optional title to be used in grid view. If none is specified the file name is used
        [string]
        $Title,

        # Forces the report to show scripts with no execution time
        [switch]
        $ShowAll
    )

    begin
    {
        $output = @()
    }

    process
    {
        try
        {
            if ($InputObject -ne $null)
            {
                foreach ($script in $InputObject)
                {     
                    if ($script.ExecutionTime -ne [TimeSpan]::Zero -or $ShowAll)
                    {
                        if ([string]::IsNullOrEmpty($Title))
                        {
                            $strTitle = "Chronometer Results: $($script.Path)"
                        }
                        else
                        {
                            $strTitle = $Title
                        }  

                        $script.line | Format-ChronometerToGridView -Title $strTitle -StatementWidth $StatementWidthl
                    }
                }
            }
            else
            {
                $output += $Line |
                    Select-Object -Property @{ 
                            Name = 'Duration'
                            Expression = { [Math]::Round($_.Duration.TotalMilliseconds, 0) }
                        }, @{
                            Name = 'HitCount'
                            Expression = { [Math]::Round($_.HitCount, 0) }
                        }, @{
                            Name = 'Average'
                            Expression = {[Math]::Round($_.Average)}
                        }, @{
                            Name = 'LineNumber'
                            Expression = { $_.LineNumber + 1 }                      
                        }, @{
                            Name = 'Statement'
                            Expression = { $_.Text + (' ' * ([Math]::Max($StatementWidth - $_.Text.Length, 0))) }
                        }
            }
        }
        catch
        {
            $PSCmdlet.ThrowTerminatingError($PSItem)
        }
    }

    end
    {
        if ($InputObject -eq $null)
        {
            $output | Out-GridView -Title $Title
        }
    }
}
