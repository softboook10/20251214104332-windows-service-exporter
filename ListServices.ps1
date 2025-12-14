# Get the current date and time for a unique filename
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$outputFile = ".\Windows11_Services_$timestamp.txt"

Write-Host "Reading Windows 11 Services..." -ForegroundColor Cyan

# 1. Get Services
# 2. Select specific columns (Status, Name, Display Name, and Start Type)
# 3. Sort by the Display Name (alphabetical, like services.msc)
# 4. Format as a table
# 5. Output to a text file with UTF8 encoding (to handle Cyrillic characters correctly)

Get-Service | 
    Select-Object Status, Name, DisplayName, StartType | 
    Sort-Object DisplayName | 
    Format-Table -AutoSize | 
    Out-File -FilePath $outputFile -Encoding UTF8

Write-Host "Done! The list has been saved to: $outputFile" -ForegroundColor Green