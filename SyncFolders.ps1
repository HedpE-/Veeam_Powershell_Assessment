param (
    [string]$SourceFolder,
    [string]$ReplicaFolder,
    [string]$LogFilePath
)

# Function to log messages to both console and log file
function Log-Message {
    param (
        [string]$Message
    )
    Write-Output $Message
    Add-Content -Path $LogFilePath -Value $Message
}

# Check if the source folder exists
if (!(Test-Path -Path $SourceFolder)) {
    Write-Error "Source folder '$SourceFolder' does not exist."
    exit
}

# Create the replica folder if it doesn't exist
if (!(Test-Path -Path $ReplicaFolder)) {
    New-Item -ItemType Directory -Path $ReplicaFolder | Out-Null
    Log-Message "Created replica folder: $ReplicaFolder"
}

# Get all files and directories in source and replica
$sourceItems = Get-ChildItem -Path $SourceFolder -Recurse
$replicaItems = Get-ChildItem -Path $ReplicaFolder -Recurse

# Sync from source to replica
foreach ($item in $sourceItems) {
    # Define relative path to keep folder structure identical
    $relativePath = $item.FullName.Substring($SourceFolder.Length + 1)
    $replicaPath = Join-Path -Path $ReplicaFolder -ChildPath $relativePath

    if ($item.PSIsContainer) {
        # Create directories in replica if they don't exist
        if (!(Test-Path -Path $replicaPath)) {
            New-Item -ItemType Directory -Path $replicaPath | Out-Null
            Log-Message "Created directory: $replicaPath"
        }
    } else {
        # Copy files if they don't exist or if they're different
        if (!(Test-Path -Path $replicaPath) -or (Get-FileHash $item.FullName).Hash -ne (Get-FileHash $replicaPath).Hash) {
            Copy-Item -Path $item.FullName -Destination $replicaPath -Force
            Log-Message "Copied file: $replicaPath"
        }
    }
}

# Delete extra items in replica not present in source
foreach ($replicaItem in $replicaItems) {
    $relativePath = $replicaItem.FullName.Substring($ReplicaFolder.Length + 1)
    $sourcePath = Join-Path -Path $SourceFolder -ChildPath $relativePath

    if (!(Test-Path -Path $sourcePath)) {
        # Remove file or directory from replica
        if ($replicaItem.PSIsContainer) {
            Remove-Item -Path $replicaItem.FullName -Recurse -Force
            Log-Message "Removed directory: $replicaItem.FullName"
        } else {
            Remove-Item -Path $replicaItem.FullName -Force
            Log-Message "Removed file: $replicaItem.FullName"
        }
    }
}

Log-Message "Synchronization complete."