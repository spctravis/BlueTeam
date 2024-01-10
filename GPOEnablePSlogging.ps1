# Import the Group Policy module
Import-Module GroupPolicy

# Define the name of the GPO
$gpoName = "EnablePSLogging"

# Define the hidden folder path
$hiddenFolderPath = "$env:USERPROFILE\.PowerShellLogs"

# Enable PowerShell Script Block Logging
$scriptBlockLoggingKey = "HKLM\Software\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging"
if (!(Get-GPRegistryValue -Name $gpoName -Key $scriptBlockLoggingKey -ValueName "EnableScriptBlockLogging")) {
    Set-GPRegistryValue -Name $gpoName -Key $scriptBlockLoggingKey -ValueName "EnableScriptBlockLogging" -Type DWord -Value 1
}

# Enable PowerShell Module Logging
$moduleLoggingKey = "HKLM\Software\Policies\Microsoft\Windows\PowerShell\ModuleLogging"
if (!(Get-GPRegistryValue -Name $gpoName -Key $moduleLoggingKey -ValueName "EnableModuleLogging")) {
    Set-GPRegistryValue -Name $gpoName -Key $moduleLoggingKey -ValueName "EnableModuleLogging" -Type DWord -Value 1
}

# Record all modules
if (!(Get-GPRegistryValue -Name $gpoName -Key $moduleLoggingKey -ValueName "ModuleNames")) {
    Set-GPRegistryValue -Name $gpoName -Key $moduleLoggingKey -ValueName "ModuleNames" -Type String -Value "*"
}

# Enable PowerShell Transcription
$transcriptionKey = "HKLM\Software\Policies\Microsoft\Windows\PowerShell\Transcription"
if (!(Get-GPRegistryValue -Name $gpoName -Key $transcriptionKey -ValueName "EnableTranscripting")) {
    Set-GPRegistryValue -Name $gpoName -Key $transcriptionKey -ValueName "EnableTranscripting" -Type DWord -Value 1
}

# Include invocation headers
if (!(Get-GPRegistryValue -Name $gpoName -Key $transcriptionKey -ValueName "IncludeInvocationHeader")) {
    Set-GPRegistryValue -Name $gpoName -Key $transcriptionKey -ValueName "IncludeInvocationHeader" -Type DWord -Value 1
}

# Set the output directory
if (!(Get-GPRegistryValue -Name $gpoName -Key $transcriptionKey -ValueName "OutputDirectory")) {
    Set-GPRegistryValue -Name $gpoName -Key $transcriptionKey -ValueName "OutputDirectory" -Type String -Value $hiddenFolderPath
}

# Enable auditing of process creation (Event ID 4688)
$auditProcessCreationKey = "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Audit\ProcessCreation"
if (!(Get-GPRegistryValue -Name $gpoName -Key $auditProcessCreationKey -ValueName "IncludeCmdLine")) {
    Set-GPRegistryValue -Name $gpoName -Key $auditProcessCreationKey -ValueName "IncludeCmdLine" -Type DWord -Value 1
}