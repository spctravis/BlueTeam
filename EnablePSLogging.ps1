# Define the hidden folder path
$hiddenFolderPath = "$env:USERPROFILE\.PowerShellLogs"

# Check if the hidden folder exists, if not, create it
if (!(Test-Path -Path $hiddenFolderPath)) {
    New-Item -ItemType Directory -Path $hiddenFolderPath
}

# Set the folder attribute to hidden
Set-ItemProperty -Path $hiddenFolderPath -Name Attributes -Value 'Hidden'

# Enable PowerShell Script Block Logging
Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging" -Name "EnableScriptBlockLogging" -Value 1

# Enable PowerShell Module Logging and record all modules
Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\PowerShell\ModuleLogging" -Name "EnableModuleLogging" -Value 1
Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\PowerShell\ModuleLogging" -Name "ModuleNames" -Value "*"

# Enable PowerShell Transcription and include invocation headers
Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\PowerShell\Transcription" -Name "EnableTranscripting" -Value 1
Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\PowerShell\Transcription" -Name "IncludeInvocationHeader" -Value 1
Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\PowerShell\Transcription" -Name "OutputDirectory" -Value $hiddenFolderPath

# Define the size limit in bytes (e.g., 500MB)
$sizeLimit = 500MB

# Get the size of the folder
$folderSize = (Get-ChildItem $hiddenFolderPath -Recurse | Measure-Object -Property Length -Sum).Sum

# Check if the size of the folder exceeds the limit
if ($folderSize -gt $sizeLimit) {
    # Get all files in the folder, sorted by last write time
    $files = Get-ChildItem $hiddenFolderPath -File | Sort-Object LastWriteTime

    # Delete the oldest files until the size of the folder is within the limit
    foreach ($file in $files) {
        Remove-Item $file.FullName
        $folderSize -= $file.Length
        if ($folderSize -le $sizeLimit) {
            break
        }
    }
}