class ScriptLine
{
    [TimeSpan] $Duration = 0
    [float] $HitCount = 0
    [TimeSpan] $Min = [TimeSpan]::MaxValue
    [TimeSpan] $Max = [TimeSpan]::MinValue
    [float] $Average = 0
    [int] $LineNumber
    [string] $Path
    [string] $Text
    [System.Collections.ArrayList]$Executions
    hidden [hashtable]$LastNode = @{}

    ScriptLine()
    {
        $this.Executions = New-Object 'System.Collections.ArrayList'
    }

    ScriptLine($Command, $Path, $LineNumber)
    {
        $this.Executions = New-Object 'System.Collections.ArrayList'
        $this.Text = $Command
        $this.Path = $Path
        $this.LineNumber = $LineNumber
    }


    [void]AddExecutionTime([timespan]$Duration)
    {
        $this.LastNode.Duration = $Duration
        $this.Duration += $Duration
        $this.HitCount += 1
        $this.Average = $this.Duration.TotalMilliseconds / $this.HitCount

        if ( $Duration -lt $this.Min )
        {
            $this.Min = $Duration
        }

        if ( $Duration -gt $this.Max )
        {
            $this.Max = $Duration
        }
    }

    [void] AddExecution([hashtable]$node)
    {
        $this.Executions.Add($node)
        $this.LastNode = $node
    }

    [void] Clear()
    {
        $this.Duration = [timespan]::Zero
        $this.HitCount = 0
        $this.Average = 0
        $this.LastNode = $null
        $this.Executions.Clear()
    }

    [string] ToString() {
        return $This.ToString($False)
    }

    [string] ToString([switch]$HTML)
    {
        $values = @(
            $this.Duration.TotalMilliseconds
            $this.HitCount
            $this.Average
            $this.LineNumber
            $this.Text
        )
        if ($HTML) {
            # HTML encode the script, replace tabs with 4 spaces and convert spaces to non-breaking spaces
            $values[4]=(([System.Net.WebUtility]::HtmlEncode($values[4]) -replace '\t','    ') -replace ' ','&nbsp;')
            return ('<td>{0:0}</td><td>{1:0}</td><td>{2:0.0}</td><td>{3}</td><td>{4}</td>' -f $values)
        } Else {
            return ('[{0:0000}ms,{1:000},{2:000}ms] {3,4}:{4}' -f $values)
        }
    }
}
