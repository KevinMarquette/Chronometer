---
external help file: chronometer-help.xml
Module Name: chronometer
online version:
schema: 2.0.0
---

# Get-Chronometer

## SYNOPSIS

## SYNTAX

```
Get-Chronometer [-Path <Object[]>] [-LineNumber <Int32[]>] [[-ScriptBlock] <ScriptBlock>] [<CommonParameters>]
```

## DESCRIPTION
Loads a script and then tracks the line by line execution times

## EXAMPLES

### EXAMPLE 1
```
Get-Chronometer -Path .\example.ps1 -Script {
```

.\example.ps1
}

## PARAMETERS

### -LineNumber
Line numbers within the script file to measure

```yaml
Type: Int32[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path
Script file to measure execution times on

```yaml
Type: Object[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -ScriptBlock
The script to start the scrupt or execute other commands

```yaml
Type: ScriptBlock
Parameter Sets: (All)
Aliases: Script, CommandScript

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
