InModuleScope Chronometer {

    Describe "Class: MonitoredScript" -Tag Build {

        It "Creates an object" {
            {[MonitoredScript]::New()} | Should Not Throw
        }

        It  "SetScript()" {

            $monitor = [MonitoredScript]::New()
            {$monitor.SetScript("$PSScriptRoot\..\..\scratchfiles\example.ps1")} | Should Not Throw
        }
    }

}
