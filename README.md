# Chronometer
A module for measuring performance of Powershell scripts, one line at a time.

## Project status
Preview release. The core logic is fleshed out but more testing is needed.

# Getting started
## Prerequirements
You need to have Powershell 5.0 or newer. This module uses classes.

## Installing Chronometer
This is published in the Powershell Gallery

    Install-Module Chronometer

## Basic usage
Provide a script file and a command to execute.

    $path = myscript.ps1
    $Chronometer = Get-Chronometer -Path $path -Script {. .\myscript.ps1}
    $Chronometer | Format-Chronometer
    

## Things to know
The `Path` can be any ps1 and the script can run any command. Ideally, you would either execute the script or load the script and execute a command inside it. 

Here is a more complex example:

    $script = ls C:\workspace\PSGraph\PSGraph -Recurse -Filter *.ps1
    $Chronometer = @{
        Path = $script.fullname
        Script = {Invoke-Pester C:\workspace\PSGraph}
    }
    $results = Get-Chronometer @Chronometer 
    $results | Format-Chronometer

# More Resources
## Blog Posts
* [Powershell: Chronometer, line by line script execution times](https://powershellexplained.com/2017-02-05-Powershell-Chronometer-line-by-line-script-execution-times)
## Alternate Solutions
* [PSProfiler](https://github.com/IISResetMe/PSProfiler)
