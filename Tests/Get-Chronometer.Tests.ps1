Describe "Function: Get-Chronometer" -Tag Build {
    It "Does not throw" {
        # Get-Chronometer -Path ScratchFiles\example.ps1 -Script {"Test"}
        {Get-Chronometer -Path $PSScriptRoot\..\ScratchFiles\example.ps1 -Script {"Test"} } | Should Not Throw
    }

    It "Executes a script and gives results" {
        # Get-Chronometer -Path ScratchFiles\example.ps1 -Script {"Test"}
        $results = Get-Chronometer -Path $PSScriptRoot\..\ScratchFiles\example.ps1 -Script {. "$PSScriptRoot\..\ScratchFiles\example.ps1"}
        $results | Should Not BeNullOrEmpty
    }

    It "Executes a script with linenumbers and gives results" {
        # Get-Chronometer -Path ScratchFiles\example.ps1 -Script {"Test"}
        $params = @{
            Path = "$PSScriptRoot\..\ScratchFiles\example.ps1"
            Script = {. "$PSScriptRoot\..\ScratchFiles\example.ps1"}
            LineNumber = 2,3,5,6
        }
        $results = Get-Chronometer @params
        $results | Should Not BeNullOrEmpty
    }
}
