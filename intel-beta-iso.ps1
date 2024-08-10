# Define the download directory
$downloadDir = "C:\Users\Admin\Downloads\Drivers"

# Ensure the download directory exists
if (-not (Test-Path $downloadDir)) {
    New-Item -Path $downloadDir -ItemType Directory
}

# Function to download and install the driver
function Download-And-Install {
    param (
        [string]$driverURL,
        [string]$fileName
    )

    $outputFile = Join-Path -Path $downloadDir -ChildPath $fileName
    try {
        if ($driverURL) {
            Write-Output "Downloading driver from $driverURL..."
            Invoke-WebRequest -Uri $driverURL -OutFile $outputFile -ErrorAction Stop
            if (Test-Path $outputFile) {
                Write-Output "Installing the driver..."
                Start-Process -FilePath $outputFile -Wait
                Remove-Item -Path $outputFile
            } else {
                Write-Output "Failed to download the driver."
            }
        } else {
            Write-Output "Unknown Intel GPU or unsupported hardware ID."
        }
    } catch {
        Write-Output "Error: $_"
    }
}

# Detect GPU Hardware ID using PowerShell
Write-Output "Detecting GPU Hardware ID..."
try {
    $hardwareId = Get-WmiObject Win32_VideoController | Select-Object -ExpandProperty PNPDeviceID
    if ($null -eq $hardwareId) {
        throw "No GPU detected."
    }
} catch {
    Write-Output "Error detecting GPU Hardware ID: $_"
    exit 1
}

# Print the detected hardware ID
Write-Output "GPU Hardware ID: $hardwareId"

# Define hardware IDs for each Intel GPU generation and their download URLs
$intelDrivers = @{
    "VEN_8086&DEV_0166" = @{
        URL = "https://downloadmirror.intel.com/29969/a08/win64_15.33.53.5161.exe"
        FileName = "win64_15.33.53.5161.exe"
    }
    "VEN_8086&DEV_0412" = @{
        URL = "https://downloadmirror.intel.com/25308/eng/win64_15407.4279.exe"
        FileName = "win64_15407.4279.exe"
    }
    "VEN_8086&DEV_1626" = @{
        URL = "https://downloadmirror.intel.com/25308/eng/win64_15407.4279.exe"
        FileName = "win64_15407.4279.exe"
    }
    "VEN_8086&DEV_1912" = @{
        URL = "https://downloadmirror.intel.com/25308/eng/win64_15407.4279.exe"
        FileName = "win64_15407.4279.exe"
    }
    "VEN_8086&DEV_5912" = @{
        URL = "https://downloadmirror.intel.com/824226/gfx_win_101.2128.exe"
        FileName = "gfx_win_101.2128.exe"
    }
    "VEN_8086&DEV_3E92" = @{
        URL = "https://downloadmirror.intel.com/824226/gfx_win_101.2128.exe"
        FileName = "gfx_win_101.2128.exe"
    }
    "VEN_8086&DEV_3E98" = @{
        URL = "https://downloadmirror.intel.com/824226/gfx_win_101.2128.exe"
        FileName = "gfx_win_101.2128.exe"
    }
    "VEN_8086&DEV_9BC8" = @{
        URL = "https://downloadmirror.intel.com/824226/gfx_win_101.2128.exe"
        FileName = "gfx_win_101.2128.exe"
    }
}

# Determine the appropriate driver to download and install
$matched = $false
foreach ($key in $intelDrivers.Keys) {
    if ($hardwareId -like "*$key*") {
        $driver = $intelDrivers[$key]
        Download-And-Install -driverURL $driver.URL -fileName $driver.FileName
        $matched = $true
        break
    }
}

if (-not $matched) {
    Write-Output "Unknown Intel GPU or unsupported hardware ID."
}

# Pause to view output
Read-Host -Prompt "Press Enter to exit"
