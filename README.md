
# SyncFolders.ps1

This PowerShell script synchronizes two folders (`source` and `replica`) in a one-way direction, ensuring that the `replica` folder is an identical copy of the `source` folder. After synchronization, all files and folders in `replica` will match the contents of `source` exactly. Any file operations (creation, copying, or removal) are logged to both the terminal and a log file.

## Features

- One-way synchronization from `source` to `replica`.
- Creates files and folders in `replica` if they do not exist.
- Updates files in `replica` if they have been modified in `source`.
- Removes files and folders in `replica` that do not exist in `source`.
- Logs all synchronization operations to a specified log file and to the terminal.

## Requirements

- PowerShell (script is developed for PowerShell 5.1 or later).
- Read and write permissions for the `source` and `replica` folders.

## Usage

1. **Open PowerShell**: Ensure you are in a session with sufficient permissions to access the specified folders.

2. **Run the Script**: Use the command below, replacing `<SourceFolder>`, `<ReplicaFolder>`, and `<LogFilePath>` with the appropriate paths to the folders and log file.

   ```powershell
   .\SyncFolders.ps1 -SourceFolder "C:\path\to\source" -ReplicaFolder "C:\path\to\replica" -LogFilePath "C:\path\to\logfile.txt"
   ```

3. **Arguments**:
   - `-SourceFolder`: Path to the source folder that will be synchronized.
   - `-ReplicaFolder`: Path to the folder that will be replicated to match the source.
   - `-LogFilePath`: Path to the log file where operations will be recorded.

## Example

```powershell
.\SyncFolders.ps1 -SourceFolder "C:\Documents\Original" -ReplicaFolder "D:\Backup\Replica" -LogFilePath "D:\Backup\sync_log.txt"
```

This command will:
- Ensure that `D:\Backup\Replica` is an identical copy of `C:\Documents\Original`.
- Log all operations to `D:\Backup\sync_log.txt`.

## Script Structure

1. **Folder Check**: Confirms that the `source` and `replica` folders exist. If the `replica` folder does not exist, it will be created.
2. **Content Synchronization**:
   - Files and folders in `source` that are not in `replica` are copied over.
   - Files existing in both folders but with different content are updated in `replica`.
3. **Remove Extra Items**: Items that exist in `replica` but not in `source` are deleted.
4. **Operation Logging**: All actions (creation, copying, deletion) are logged to both the terminal and the specified log file.

## License

Distributed under the MIT License. See `LICENSE` for more information.
