InModuleScope Chronometer {

    Describe "Class: ScriptProfiler" -Tag Build {

        It "Creates an Object" {
            {[ScriptProfiler]::New()} | Should Not Throw
        }

        It "Start()" {
            {[ScriptProfiler]::Start()} | Should Not Throw
        }
    }
}
