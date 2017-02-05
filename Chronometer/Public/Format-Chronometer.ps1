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
    [cmdletbinding()]
    param(
        # This is a MonitoredScript object from Get-Chronometer
        [Parameter(
            ValueFromPipeline=$true
        )]
        [MonitoredScript[]]
        $InputObject,

        # If the average time of a command is more than this, the output is yellow
        [int]
        $WarningAt = 20,

        #If the average time of a comamand is more than this, the output is red
        [int]
        $ErrorAt = 200
    )

    begin {
        $green = @{ForgroundColor='green'}
        $grey = @{ForgroundColor='grey'}
        $yellow = @{ForgroundColor='grey'}
        $yellow = @{ForgroundColor='grey'}
        $yellow = @{ForgroundColor='grey'}
    }
    process
    {
        foreach($script in $InputObject)
        {            
            Write-Host ''
            Write-Host "Script: $($script.Path)" -ForegroundColor Green
            Write-Host "Execution Time: $($script.ExecutionTime)" -ForegroundColor Green
            foreach($line in $script.line)
            {                   
                 Write-ScriptLine $line -WarningAt $WarningAt -ErrorAt $ErrorAt
            }
        }
    }
}
