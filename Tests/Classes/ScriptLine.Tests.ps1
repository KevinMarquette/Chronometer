InModuleScope Chronometer {
    Describe "Class: ScriptLine" -Tag Build {

        It "Creates an Object" {
            {[ScriptLine]::New()} | Should Not Throw
        }

        It "ToString()" {
            {[ScriptLine]::New().toString()} | Should Not Throw
        }

        It "Creates an Object" {
            {[ScriptLine]::New().AddExecutionTime(1)} | Should Not Throw
        }
    }
}
