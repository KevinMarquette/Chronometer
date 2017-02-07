
class ScriptLine
{
    [float] $Milliseconds = 0
    [float] $HitCount = 0
    [float] $Min = [float]::MaxValue
    [float] $Max = [float]::MinValue
    [float] $Average = 0
    [int] $LineNumber
    [string] $Path
    [string] $Text
    [System.Collections.ArrayList]$Executions
    hidden [hashtable]$LastNode = $null

    ScriptLine()
    {
        $Executions = New-Object 'System.Collections.ArrayList'
    }

    [void]AddExecutionTime([float]$Milliseconds)
    {
        $this.LastNode.Milliseconds = $Milliseconds
        $this.Milliseconds += $Milliseconds
        $this.HitCount += 1
        $this.Average = $this.Milliseconds / $this.HitCount
        
        if($Milliseconds -lt $this.Min)
        {
            $this.Min = $Milliseconds
        }

        if($Milliseconds -gt $this.Max)
        {
            $this.Max = $Milliseconds
        }
    }

    [void] AddExecution([hashtable]$node)
    {
        $this.Executions.Add($node)
        $this.LastNode = $node
    }

    [void] Clear()
    {
        $this.Milliseconds = 0
        $this.HitCount = 0
        $this.Average = 0
        $this.LastNode = $null
        $this.Executions.Clear()
    }

    [string] ToString()
    {
        $values = @(
            $this.Milliseconds
            $this.HitCount
            $this.Average
            $this.LineNumber
            $this.Text
        )
        return ("[{0:0000}ms,{1:000},{2:000}ms] {3,4}:{4}" -f $values)
    }
}