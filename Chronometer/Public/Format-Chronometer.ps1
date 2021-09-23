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
        $ShowAll,

        # Define the output method
        [Parameter(Mandatory=$false)][ValidateSet('FormattedText','HTML','GridView')]
        [string]$OutputMethod='FormattedText'

    )
    begin {
        switch ($OutputMethod) {
            'GridView' {
                $GridViewOutput = New-Object System.Collections.Arraylist
                break
            }
            'HTML' {
                # Only write the HTML file header the first time this function is called
                if ($PsCmdlet.ParameterSetName -eq 'Script') {
                    $HeaderWritten=$False
                    # Write HTML file header
                    $HTMLHeader=@'
<html>
<head>
<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/v/dt/jq-3.3.1/dt-1.10.21/fh-3.1.7/datatables.min.css"/>
<script type="text/javascript" src="https://cdn.datatables.net/v/dt/jq-3.3.1/dt-1.10.21/fh-3.1.7/datatables.min.js"></script>
<script type="text/javascript" class="init">
$(document).ready(function() {
$('table.chronometer').DataTable({
    "order": [[ 3, "asc" ]],
    "dom": '<"top"fi>rt<"bottom"lp>',
    "paging": false, // false to disable pagination (or any other option)
    "fixedHeader": true,
    "aoColumns": [
        { "orderSequence": [ "desc", "asc" ] },
        { "orderSequence": [ "desc", "asc" ] },
        { "orderSequence": [ "desc", "asc" ] },
        null,
        null
    ],
    "columns": [
        { "width": "60px" },
        { "width": "60px" },
        { "width": "60px" },
        { "width": "60px" },
        null
    ],
    "language": {
        "search": "_INPUT_",            // Removes the 'Search' field label
        "searchPlaceholder": "Search"   // Placeholder for the search box
    }
});
} );
</script>
<style>
caption {
caption-side: top
}
.dataTables_filter {
float: left !important;
text-align: left;
margin-top: 10px;
left: 0px;
top: 0px;
}
.dataTables_info {
float: right !important;
position: relative;
right: 0px;
top: -30px;
}
table, th, td {
#  border: 1px solid white;
#  background-color: #000000;
border-collapse: collapse;
}
th, td {
padding: 0px;
text-align: left;
}
.OK {
color: green;
}
.warning {
color: orange;
}
.error {
color: red;
}
.unused {
color: gray;
}

</style>
</head>
<body>
'@
                    break
                }
            }
        }
    }

    process
    {
        try
        {
            foreach ( $script in $InputObject )
            {
                if ( $script.ExecutionTime -ne [TimeSpan]::Zero -or $ShowAll )
                {
                    switch ($OutputMethod) {
                        'HTML'  {
                            if (-not $HeaderWritten) {
                                Write-Output $HTMLHeader
                                $HeaderWritten=$True
                            }
                            # Table element for each script
                            Write-Output @'
    <table id="" class="chronometer table row-border compact order-column hover">
    <caption>
'@
                            # Caption text
                            Write-Output @"
    Script: $($script.Path)<br>
    Execution Time: $($script.ExecutionTime)<br>
"@
                            # Table header
                            Write-Output @'
    </caption>
    <thead>
        <tr><th>Total ms</th><th>Hit cnt</th><th>Avg ms</th><th>Line#</th><th>Line</th></tr>
    </thead>
    <tbody>
'@
                            break
                        }
                        'FormattedText' {
                            Write-Host ''
                            Write-Host "Script: $($script.Path)" -ForegroundColor Cyan
                            Write-Host "Execution Time: $($script.ExecutionTime)" -ForegroundColor Cyan
                            break
                        }
                        'GridView' {
                            $GridViewTitle = "Chronometer Results: $($script.Path)"
                            break
                        }
                    }
                    $script.line | Format-Chronometer -WarningAt $WarningAt -ErrorAt $ErrorAt -OutputMethod $OutputMethod
                    switch ($OutputMethod) {
                        'HTML' {
                            Write-Output @'
    </tbody>
    </table>
'@
                            break
                        }
                    }
                }
            }

            foreach ( $command in $Line ) {
                if ($OutputMethod -eq 'GridView') {
                    $null=$GridViewOutput.Add((Write-ScriptLine $command -WarningAt $WarningAt -ErrorAt $ErrorAt -OutputMethod $OutputMethod))
                } Else {
                    Write-ScriptLine $command -WarningAt $WarningAt -ErrorAt $ErrorAt -OutputMethod $OutputMethod
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($PSItem)
        }
    }
    end {
        switch ($OutputMethod) {
            'HTML' {
                # Make sure to also write the HTML closing tags if the HTML header was written
                if ($PsCmdlet.ParameterSetName -eq 'Script' -and $HeaderWritten) {
                    # Write HTML closing tag
                    Write-Output @'
</body>
</html>
'@
                }
            }
            'GridView' {
                if ($GridViewOutput.Count -gt 0) {
                    $GridViewOutput | Out-GridView -Title $GridViewTitle
                }
            }
        }
    }
}
