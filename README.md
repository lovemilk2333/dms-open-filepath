# Open File Path for DankMaterialShell

A DankMaterialShell launcher plugin for quickly opening file paths.

## Features

- **Open Directories**: Input a directory path (e.g., `/home/user/Documents/`) to open it in your default file manager.
- **Reveal Files**: Input a file path (e.g., `~/Pictures/photo.jpg`) to reveal it or open it's parent directory.
- **Wine Path Support**: Automatically convert Wine mounted path of root (e.g., `z:\a\b\c`) to Linux path (e.g., `/a/b/c`)
- **Smart Detection**: Automatically provides the "Open" option when your input looks like a path.

## Installation

### Manual Installation

** make sure `rsync` was installed **

```bash
# Copy the plugin directory to your DMS plugins folder
chmod +x ./install && ./install

# Enable in DMS
# 2. Open DMS Settings and goto `Settings > Plugins`.
# 3. Toggle the switch of "Open File Path" to enable it.
```

## Requirements

- DankMaterialShell >= 0.1.0
- `sh` in PATH
- `xdg-open` in PATH

## Compatibility

- **Compositors**: Niri and Hyprland
- **Distros**: Universal - works on any Linux distribution which contains `sh` and `xdg-open`

## Technical Details

- **Type**: Launcher plugin
- **Trigger**: NONE
- **Language**: QML (Qt Modeling Language)

## License

BSD 3-Clause "New" or "Revised" License - See LICENSE file for details
