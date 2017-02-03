
function global:Invoke-PSProfile
{
    [cmdletbinding()]
    param([System.Management.Automation.LineBreakpoint]$InputObject)
    $Global:PSProfile['queue'].Enqueue(@{
        Breakpoint = $_
        ElapsedMilliseconds =  $Global:PSProfile['time'].ElapsedMilliseconds
    })
}

function New-PSProfile
{
    [CmdletBinding()]
    param(
        [string[]]
        $Path,

        [scriptblock]
        $CommandScript

    )

    $breakPoint = @()
    $fileMap = @{}

    foreach($file in (Resolve-Path $Path))
    {
        $fileMap[$file.Path] = @( Get-Content -Path $file | %{@{line=$_}})

        $lines = $fileMap[$file.Path].count
        $breakPoint += Set-PSBreakpoint -Script $file -Line (1..$lines) -Action {global:Invoke-PSProfile -InputObject $_ }
    }

    $Global:PSProfile = @{}
    $Global:PSProfile['queue'] = New-Object System.Collections.Queue
    $Global:PSProfile['time'] = [System.Diagnostics.Stopwatch]::StartNew()

    [void] $CommandScript.Invoke()

    Remove-PSBreakpoint $breakpoint

    foreach($node in $Global:PSProfile['queue'].GetEnumerator())
    {
        $record = $fileMap[$node.Breakpoint.Script][$node.Breakpoint.Line-1]
        if($lastNode)
        {
            $duration = $node.ElapsedMilliseconds - $lastNode.ElapsedMilliseconds
        }
        else
        {
            $duration = $node.ElapsedMilliseconds
        }
        
        
        if($lastRecord)
        {
            $lastRecord.TotalRuntime += $duration
            $lastRecord.HitCount += 1
            $lastRecord.AVG = $lastRecord.TotalRuntime / $lastRecord.HitCount

            if($lastRecord.Min -eq $null -or $lastRecord.Min -gt $duration)
            {
                $lastRecord.Min = $duration
            }
            if($lastRecord.Max -eq $null -or $lastRecord.Max -lt $duration)
            {
                $lastRecord.Max = $duration
            }        
        }

        $lastRecord = $record
        $lastNode = $node
    }

    foreach($script in $fileMap.Keys)
    {
        foreach($line in $fileMap[$script])
        {
            "[{0:0000},{1:00},{2:000}]`t{3}" -f $line.TotalRuntime,$line.HitCount,$line.AVG,$line.line
        }
    }
}

New-PSProfile -Path .\example.ps1 -CommandScript {.\example.ps1} -OutVariable results
