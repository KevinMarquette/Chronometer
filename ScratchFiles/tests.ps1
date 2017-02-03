$script:test2 = 20

Set-PSBreakpoint -Script .\example.ps1 -Line (1..9) -OutVariable breakpoint -Action {global:Set-BPInfo $_}
.\example.ps1

global:Get-BPInfo | fl *

global:Set-BPInfo

$script:test2

$breakpoint | Get-Member

Remove-PSBreakpoint $breakpoint

function global:Set-BPInfo {
    param($value)
    $global:BPinfo += 1
    $global:BPvalue = $value
}

function global:Get-BPInfo {
    $global:BPvalue
}

# per file
# per line
# hit count
# execution
# the command before