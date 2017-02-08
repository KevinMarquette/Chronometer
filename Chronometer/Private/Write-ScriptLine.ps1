
function Write-ScriptLine
{
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingWriteHost","")]
    [cmdletbinding()]
    param(
        [scriptline]
        $line,
        $WarningAt = [int]::MaxValue,
        $ErrorAt = [int]::MaxValue
    )

    if($line)
    {         
        $Color = 'Green'
        if($line.HitCount -eq 0)
        {
            $Color = 'Gray'
        }
        elseif($line.Average -ge $ErrorAt)
        {
            $Color = 'Red'
        }
        elseif($line.Average -ge $WarningAt)
        {
            $Color = 'Yellow'
        }
        
        Write-Host $line.toString() -ForegroundColor $Color
    }
}