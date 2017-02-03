$projectRoot = Resolve-Path "$PSScriptRoot\.."
$moduleRoot = Split-Path (Resolve-Path "$projectRoot\*\*.psd1")
$moduleName = Split-Path $moduleRoot -Leaf

Import-Module (Join-Path $moduleRoot "$moduleName.psm1") -force

Describe "Basic unit tests" -Tags Build {

    Context "Function: Get-Chronometer" {
        it "Does not throw" {
            {Get-Chronometer -Path $PSScriptRoot\..\ScratchFiles\example.ps1 -Script {"Test"} } | Should Not Throw
        }
    }

    InModuleScope $moduleName {
        Context "Class: ScriptLine" {
        
            it "Creates an Object" {
                {[ScriptLine]::New()} | Should Not Throw
            }
        }

        Context "Class: ScriptProfiler" {
        
            it "Creates an Object" {
                {[ScriptProfiler]::New()} | Should Not Throw
            }
        }
    }
    
}