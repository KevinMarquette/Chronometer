
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


    [void]AddExecutionTime([float]$Milliseconds)
    {
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