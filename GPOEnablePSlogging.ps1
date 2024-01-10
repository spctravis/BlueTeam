# Import the Group Policy module
Import-Module GroupPolicy

# Define the name of the GPO
$gpoName = "Default Domain Policy"

# Define the hidden folder path
$hiddenFolderPath = "$env:USERPROFILE\.PowerShellLogs"

# Enable PowerShell Script Block Logging
$scriptBlockLoggingKey = "HKLM\Software\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging"
if (!(Get-GPRegistryValue -Name $gpoName -Key $scriptBlockLoggingKey -ValueName "EnableScriptBlockLogging" -ErrorAction SilentlyContinue)) {
    Set-GPRegistryValue -Name $gpoName -Key $scriptBlockLoggingKey -ValueName "EnableScriptBlockLogging" -Type DWord -Value 1
}

# Enable PowerShell Module Logging
$moduleLoggingKey = "HKLM\Software\Policies\Microsoft\Windows\PowerShell\ModuleLogging"
if (!(Get-GPRegistryValue -Name $gpoName -Key $moduleLoggingKey -ValueName "EnableModuleLogging" -ErrorAction SilentlyContinue)) {
    Set-GPRegistryValue -Name $gpoName -Key $moduleLoggingKey -ValueName "EnableModuleLogging" -Type DWord -Value 1
}

# Record all modules
if (!(Get-GPRegistryValue -Name $gpoName -Key $moduleLoggingKey -ValueName "ModuleNames" -ErrorAction SilentlyContinue)) {
    Set-GPRegistryValue -Name $gpoName -Key $moduleLoggingKey -ValueName "ModuleNames" -Type String -Value "*"
}

# Enable PowerShell Transcription
$transcriptionKey = "HKLM\Software\Policies\Microsoft\Windows\PowerShell\Transcription"
if (!(Get-GPRegistryValue -Name $gpoName -Key $transcriptionKey -ValueName "EnableTranscripting" -ErrorAction SilentlyContinue)) {
    Set-GPRegistryValue -Name $gpoName -Key $transcriptionKey -ValueName "EnableTranscripting" -Type DWord -Value 1
}

# Include invocation headers
if (!(Get-GPRegistryValue -Name $gpoName -Key $transcriptionKey -ValueName "IncludeInvocationHeader" -ErrorAction SilentlyContinue)) {
    Set-GPRegistryValue -Name $gpoName -Key $transcriptionKey -ValueName "IncludeInvocationHeader" -Type DWord -Value 1
}

# Set the output directory
if (!(Get-GPRegistryValue -Name $gpoName -Key $transcriptionKey -ValueName "OutputDirectory" -ErrorAction SilentlyContinue)) {
    Set-GPRegistryValue -Name $gpoName -Key $transcriptionKey -ValueName "OutputDirectory" -Type String -Value $hiddenFolderPath
}
# Enable WMI Activity Logging
$wmiLoggingKey = "HKLM\SOFTWARE\Microsoft\WBEM\CIMOM\Logging"
if (!(Get-GPRegistryValue -Name $gpoName -Key $wmiLoggingKey -ValueName "Logging" -ErrorAction SilentlyContinue)) {
    Set-GPRegistryValue -Name $gpoName -Key $wmiLoggingKey -ValueName "Logging" -Type DWord -Value 2
}