$projectRoot = Resolve-Path "$PSScriptRoot\.."
$moduleRoot = Split-Path (Resolve-Path "$projectRoot\*\*.psd1")
$moduleName = Split-Path $moduleRoot -Leaf

Describe "Basic unit tests" -Tags Build {

    Import-Module (Join-Path $moduleRoot "$moduleName.psm1") -force

    Context "Function: Get-Chronometer" {
        it "Does not throw" {
            # Get-Chronometer -Path ScratchFiles\example.ps1 -Script {"Test"} 
            {Get-Chronometer -Path $PSScriptRoot\..\ScratchFiles\example.ps1 -Script {"Test"} } | Should Not Throw
        }

        it "Executes a script and gives results" {
            # Get-Chronometer -Path ScratchFiles\example.ps1 -Script {"Test"} 
            $results = Get-Chronometer -Path $PSScriptRoot\..\ScratchFiles\example.ps1 -Script {. "$PSScriptRoot\..\ScratchFiles\example.ps1"} 
            $results | Should Not BeNullOrEmpty
        }

         it "Executes a script with linenumbers and gives results" {
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

    Context "Function: Format-Chronometer" {

        it "Does not throw" {
            {$null | Format-Chronometer } | Should Not Throw
        }

        it "Can process a result object without throwing" {
            $results = Get-Chronometer -Path $PSScriptRoot\..\ScratchFiles\example.ps1 -Script {. "$PSScriptRoot\..\ScratchFiles\example.ps1"} 
            $results | Format-Chronometer *>&1 | Should Not BeNullOrEmpty
        }
    }

    InModuleScope $moduleName {
        Context "Class: ScriptLine" {
        
            it "Creates an Object" {
                {[ScriptLine]::New()} | Should Not Throw
            }
            it "ToString()" {
                {[ScriptLine]::New().toString()} | Should Not Throw
            }
            it "Creates an Object" {
                {[ScriptLine]::New().AddExecutionTime(1)} | Should Not Throw
            }
        }

        Context "Class: ScriptProfiler" {
        
            it "Creates an Object" {
                {[ScriptProfiler]::New()} | Should Not Throw
            }
            it "Start()" {
                {[ScriptProfiler]::Start()} | Should Not Throw
            }
        }

        Context "Class: MonitoredScript" {
            it "Creates an object" {
                {[MonitoredScript]::New()} | Should Not Throw
            }
            
            it  "SetScript()" {
                pushd $projectRoot
                $monitor = [MonitoredScript]::New()
                {$monitor.SetScript(".\scratchfiles\example.ps1")} | Should Not Throw
                popd
            }
        }

    }
}