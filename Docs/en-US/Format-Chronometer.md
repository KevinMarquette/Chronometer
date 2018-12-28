---
external help file: chronometer-help.xml
Module Name: chronometer
online version:
schema: 2.0.0
---

# Format-Chronometer

## SYNOPSIS

## SYNTAX

### Script (Default)
```
Format-Chronometer [-InputObject <MonitoredScript[]>] [-WarningAt <Int32>] [-ErrorAt <Int32>] [-ShowAll]
 [<CommonParameters>]
```

### Line
```
Format-Chronometer [-Line <ScriptLine[]>] [-WarningAt <Int32>] [-ErrorAt <Int32>] [-ShowAll]
 [<CommonParameters>]
```

## DESCRIPTION
Generates a report from a Chronometer

## EXAMPLES

### EXAMPLE 1
```
$script = ls C:\workspace\PSGraph\PSGraph -Recurse -Filter *.ps1
```

$resultes = Get-Chronometer -Path $script.fullname  -ScriptBlock {Invoke-Pester C:\workspace\PSGraph}
$results | Format-Chronometer -WarnAt 20 -ErrorAt 200

## PARAMETERS

### -ErrorAt
If the average time of a comamand is more than this, the output is red

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 200
Accept pipeline input: False
Accept wildcard characters: False
```

### -InputObject
This is a MonitoredScript object from Get-Chronometer

```yaml
Type: MonitoredScript[]
Parameter Sets: Script
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Line
This is a ScriptLine object from a MonitoredScript object

```yaml
Type: ScriptLine[]
Parameter Sets: Line
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -ShowAll
Forces the report to show scripts with no execution time

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -WarningAt
If the average time of a command is more than this, the output is yellow

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 20
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
