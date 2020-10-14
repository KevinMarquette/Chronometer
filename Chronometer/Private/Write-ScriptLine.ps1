function Write-ScriptLine
{
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingWriteHost", "")]
    [cmdletbinding()]
    param(
        [scriptline]$line,
        $WarningAt = [int]::MaxValue,
        $ErrorAt = [int]::MaxValue,
        [Parameter(Mandatory=$True)][ValidateSet('FormattedText','HTML','GridView')]
        [string]$OutputMethod
    )

    if ( $line )
    {
        switch ($OutputMethod) {
            'FormattedText' {
                $Color = 'Green'
                if ( $line.HitCount -eq 0 )
                {
                    $Color = 'Gray'
                }
                elseif ( $line.Average -ge $ErrorAt )
                {
                    $Color = 'Red'
                }
                elseif ( $line.Average -ge $WarningAt )
                {
                    $Color = 'Yellow'
                }
                Write-Host $line.toString() -ForegroundColor $Color
                break
            }
            'HTML' {
                $Class = 'OK'
                if ( $line.HitCount -eq 0 )
                {
                    $Class = 'Unused'
                }
                elseif ( $line.Average -ge $ErrorAt )
                {
                    $Class = 'Error'
                }
                elseif ( $line.Average -ge $WarningAt )
                {
                    $Class = 'Warning'
                }
                Write-Output ('      <tr class="{0}">{1}</tr>' -f $Class,($line.toString($True)))
                break
            }
            'GridView' {
                $Line | Select-Object -Property @{
                    Name = 'Total ms'
                    Expression = { [Math]::Round($_.Duration.TotalMilliseconds, 0) }
                }, @{
                    Name = 'HitCount'
                    Expression = { [Math]::Round($_.HitCount, 0) }
                }, @{
                    Name = 'Average ms'
                    Expression = {[Math]::Round($_.Average, 1)}
                }, @{
                    Name = 'Line #'
                    Expression = { $_.LineNumber }
                }, @{
                    Name = 'Line'
                    Expression = { $_.Text }
                }
                break
            }
            default {
                Throw [System.NotImplementedException]
            }
        }
    }
}
