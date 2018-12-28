Describe "Function: Format-Chronometer" -Tag Build {

    It "Does not throw" {
        {$null | Format-Chronometer } | Should Not Throw
    }

    It "Can process a result object without throwing" {
        $results = Get-Chronometer -Path $PSScriptRoot\..\ScratchFiles\example.ps1 -Script {. "$PSScriptRoot\..\ScratchFiles\example.ps1"}
        $results | Format-Chronometer *>&1 | Should Not BeNullOrEmpty
    }
}
