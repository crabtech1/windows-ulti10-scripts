# PowerShell Script to Detect AMD GPU and Download Driver

# Set Execution Policy
Set-ExecutionPolicy Bypass -Scope Process -Force

# Function to get AMD GPU information
function Get-AMDHardwareID {
    $hardwareID = Get-WmiObject Win32_PnPEntity | Where-Object { $_.Name -match "AMD" -or $_.Name -match "Radeon" } | Select-Object -ExpandProperty DeviceID
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
    "HD7000" = "https://www.amd.com/drivers/hd7000";
    "R200" = "https://www.amd.com/drivers/r200";
    "R300" = "https://www.amd.com/drivers/r300";
    "R400" = "https://www.amd.com/drivers/r400";
    "RX400" = "https://www.amd.com/drivers/rx400";
    "RX500" = "https://www.amd.com/drivers/rx500";
    "RX5000" = "https://www.amd.com/drivers/rx5000";
    "Vega" = "https://www.amd.com/drivers/vega";
    "Navi" = "https://www.amd.com/drivers/navi";
}

# Detect AMD GPU
$hardwareID = Get-AMDHardwareID
Write-Host "Detecting AMD GPU Hardware ID..."
Write-Host "GPU Hardware ID: $hardwareID"

# Determine appropriate driver URL
$driverURL = $null
if ($hardwareID -match "VEN_1002&DEV_6798") {
    $driverURL = $drivers["HD7000"]
} elseif ($hardwareID -match "VEN_1002&DEV_67B1") {
    $driverURL = $drivers["R200"]
} elseif ($hardwareID -match "VEN_1002&DEV_67DF") {
    $driverURL = $drivers["R300"]
} elseif ($hardwareID -match "VEN_1002&DEV_67FF") {
    $driverURL = $drivers["R400"]
} elseif ($hardwareID -match "VEN_1002&DEV_67EF") {
    $driverURL = $drivers["RX400"]
} elseif ($hardwareID -match "VEN_1002&DEV_67DF") {
    $driverURL = $drivers["RX500"]
} elseif ($hardwareID -match "VEN_1002&DEV_731F") {
    $driverURL = $drivers["RX5000"]
} elseif ($hardwareID -match "VEN_1002&DEV_6863") {
    $driverURL = $drivers["Vega"]
} elseif ($hardwareID -match "VEN_1002&DEV_731E") {
    $driverURL = $drivers["Navi"]
} else {
    Write-Host "Unknown AMD GPU or unsupported hardware ID."
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
