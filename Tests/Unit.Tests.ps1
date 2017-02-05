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
    }
}