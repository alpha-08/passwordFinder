# Prompt user for directory name
$directory = Read-Host -Prompt "Enter the directory name in C:\"

# Define the full path
$path = "C:\$directory"

# Check if directory exists
if (-Not (Test-Path -Path $path -PathType Container)) {
    Write-Host "The directory $path does not exist."
    exit
}

# Define the file types to search
$fileTypes = @("*.ps1", "*.txt", "*.doc")

# Function to search for keyword in files
function Search-Keyword {
    param (
        [string]$filePath,
        [string]$keyword
    )
    try {
        $content = Get-Content -Path $filePath -ErrorAction Stop
        foreach ($line in $content) {
            if ($line -match $keyword) {
                Write-Host "Keyword found in $($filePath): $($line)"
            }
        }
    } catch {
        Write-Host "Error reading $($filePath): $($_.Exception.Message)"
    }
}

# Search for the keyword in specified file types
foreach ($fileType in $fileTypes) {
    $files = Get-ChildItem -Path $path -Filter $fileType -Recurse -ErrorAction SilentlyContinue
    foreach ($file in $files) {
        Search-Keyword -filePath $file.FullName -keyword "password"
        Search-Keyword -filePath $file.FullName -keyword "Password"
    }
}

Write-Host "Search complete."
