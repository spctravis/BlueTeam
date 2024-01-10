# Set the startup script for the GPO on a domain controller
# Set-GPStartupScript -Name "Install Sysmon" -Path "\\path\to\your\script\Install-Sysmon.ps1" -Order 2 -Domain "yourdomain.com" 

# Define the path to the Sysmon executable and config file on the file server
$sysmonPath = "\\fileserver\path\to\sysmon.exe"
$configPath = "\\fileserver\path\to\sysmonconfig.xml"

# Define the local path to the Sysmon executable and config file
$localSysmonPath = "C:\path\to\local\sysmon.exe"
$localConfigPath = "C:\path\to\local\sysmonconfig.xml"

# Define a function to copy a file if getting its hash fails or if the hashes are not equal
function Copy-IfHashFails {
    param($sourcePath, $destinationPath)
    try {
        $destinationHash = (Get-FileHash -Path $destinationPath).Hash
        $sourceHash = (Get-FileHash -Path $sourcePath).Hash
        if ($destinationHash -ne $sourceHash) {
            Copy-Item -Path $sourcePath -Destination $destinationPath
        }
    } catch {
        Copy-Item -Path $sourcePath -Destination $destinationPath
    }
}

# Copy the Sysmon executable and config file if getting their hash fails
Copy-IfHashFails -sourcePath $sysmonPath -destinationPath $localSysmonPath
Copy-IfHashFails -sourcePath $configPath -destinationPath $localConfigPath

# Check if Sysmon is installed
if (!(Test-Path -Path $localSysmonPath)) {
    # Sysmon is not installed, install it
    Start-Process -FilePath $localSysmonPath -ArgumentList "-accepteula -i $localConfigPath" -Wait
} else {
    # Sysmon is installed, check if a new version exists on the file server
    if ((Get-FileHash -Path $sysmonPath).Hash -ne (Get-FileHash -Path $localSysmonPath).Hash) {
        # A new version of Sysmon exists on the file server, install it
        Start-Process -FilePath $localSysmonPath -ArgumentList "-accepteula -i $localConfigPath" -Wait
    }
}