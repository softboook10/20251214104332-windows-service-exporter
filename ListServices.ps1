# Get current date for filename
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"

# Define output directory and file path
$outputDir = ".\out"
$outputFile = "$outputDir\Windows11_Services_$timestamp.txt"

# Create the 'out' directory if it doesn't exist
if (-not (Test-Path $outputDir)) {
    Write-Host "Creating output directory: $outputDir" -ForegroundColor Yellow
    New-Item -ItemType Directory -Path $outputDir | Out-Null
}

Write-Host "Reading Services and checking Triggers..." -ForegroundColor Cyan

# Process services
$results = Get-Service | Sort-Object DisplayName | ForEach-Object {
    $s = $_
    $name = $s.Name
    $baseStart = $s.StartType
    
    # Define the Registry Path for this service
    $regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\$name"
    $triggerPath = "$regPath\TriggerInfo"

    # Default value
    $finalStart = "$baseStart"

    # Check Registry for Trigger Info
    # If the subkey 'TriggerInfo' exists, Windows appends (Trigger Start)
    if ($baseStart -ne "Disabled") {
        if (Test-Path $triggerPath) {
            $finalStart = "$baseStart (Trigger Start)"
        }
    }

    # Return a custom object
    [PSCustomObject]@{
        Status      = $s.Status
        Name        = $name
        DisplayName = $s.DisplayName
        StartType   = $finalStart
    }
}

# Output to file
# 'Out-String -Width 4096' ensures long lines are not cut off
$results | Format-Table -AutoSize | Out-String -Width 4096 | Out-File -FilePath $outputFile -Encoding UTF8

Write-Host "Done! Saved to $outputFile" -ForegroundColor Green