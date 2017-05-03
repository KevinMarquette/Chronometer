Given 'We have functions to publish' {
    "$psscriptroot\..\chronometer\public\*.ps1" | Should Exist
}
And 'We have a module' {
    "$psscriptroot\..\chronometer\chronometer.psd1" | Should Exist
    "$psscriptroot\..\chronometer\chronometer.psm1" | Should Exist
}
When 'The user searches for our module' {
    Find-Module chronometer | Should Not BeNullOrEmpty
}
Then 'They can install the module' {
    {Install-Module chronometer -Scope CurrentUser -WhatIf *>&1} | Should Not Throw
}