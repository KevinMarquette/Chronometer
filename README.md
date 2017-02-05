# Chronometer
A module for measuring performance of Powershell scripts, one line at a time

## Project status
Experimental. Just a working idea at the moment. Functions and argument names are still up in the air. Also don't consider it stable or tested. Use at your own risk.

# Getting started
## Prerequirements
You need to have Powershell 5.0 or newer. This module uses classes.

## Installing Chronometer
Place the Chronometer folder into your `$PSModulePath`. I will publish to the Powershell Gallery once the project is more stable.

## Basic usage
Provide a script file and a command to execute.

    $path = myscript.ps1
    $Chronometer = Get-Chronometer -Path $path -Script {. .\myscript.ps1}
    $Chronometer | % tostring | Format-Chronometer
    
The user experience is important to me but I am working on the core logic right now. I will loop back to make it more intuitive and simple to use. 

## Things to know
The `Path` can be any ps1 and the script can run any command. Ideally, you would either execute the script or load the script and execute a command inside it. 

