# PowerShell Script to Detect NVIDIA GPU and Download Driver

# Set Execution Policy
Set-ExecutionPolicy Bypass -Scope Process -Force

# Function to get NVIDIA GPU information
function Get-NVIDIAHardwareID {
    $hardwareID = Get-WmiObject Win32_PnPEntity | Where-Object { $_.Name -match "NVIDIA" } | Select-Object -ExpandProperty DeviceID
    return $hardwareID
}

# Function to download driver
function Download-Driver {
    param (
        [string]$url,
        [string]$destination
    )
    Invoke-WebRequest -Uri $url -OutFile $destination
}

# Define driver URLs
$drivers = @{
    "Kepler" = "https://de1-dl.techpowerup.com/files/A4wxnVS9VqagItdL_dkOyA/1723288029/474.44-desktop-win10-win11-64bit-international-dch-whql.exe";
    "Pascal" = "https://de1-dl.techpowerup.com/files/akls0hZ1fM1Y13pciXYmIA/1723288126/560.81-desktop-win10-win11-64bit-international-dch-whql.exe";
    "Maxwell" = "https://de1-dl.techpowerup.com/files/akls0hZ1fM1Y13pciXYmIA/1723288126/560.81-desktop-win10-win11-64bit-international-dch-whql.exe";
    "Turing" = "https://de1-dl.techpowerup.com/files/akls0hZ1fM1Y13pciXYmIA/1723288126/560.81-desktop-win10-win11-64bit-international-dch-whql.exe";
    "Ampere" = "https://de1-dl.techpowerup.com/files/akls0hZ1fM1Y13pciXYmIA/1723288126/560.81-desktop-win10-win11-64bit-international-dch-whql.exe";
}

# Detect NVIDIA GPU
$hardwareID = Get-NVIDIAHardwareID
Write-Host "Detecting NVIDIA GPU Hardware ID..."
Write-Host "GPU Hardware ID: $hardwareID"

# Determine appropriate driver URL
$driverURL = $null
if ($hardwareID -match "Kepler") {
    $driverURL = $drivers["Kepler"]
} elseif ($hardwareID -match "Pascal") {
    $driverURL = $drivers["Pascal"]
} elseif ($hardwareID -match "Maxwell") {
    $driverURL = $drivers["Maxwell"]
} elseif ($hardwareID -match "Turing") {
    $driverURL = $drivers["Turing"]
} elseif ($hardwareID -match "Ampere") {
    $driverURL = $drivers["Ampere"]
} else {
    Write-Host "Unknown NVIDIA GPU or unsupported hardware ID."
    Read-Host -Prompt "Press Enter to exit"
    exit
}

# Download driver
if ($driverURL) {
    $destination = "C:\Users\Admin\Downloads\Drivers\$(Split-Path -Leaf $driverURL)"
    Write-Host "Downloading driver from $driverURL to $destination..."
    Download-Driver -url $driverURL -destination $destination
    Write-Host "Driver downloaded successfully. Starting installer..."
    Start-Process -FilePath $destination -Wait
} else {
    Write-Host "No driver URL found for the detected GPU."
    Read-Host -Prompt "Press Enter to exit"
}
