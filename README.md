# 📋 Clipboard Manager for macOS

A powerful and elegant clipboard manager for macOS built with Swift and SwiftUI. Keep track of your copied items and easily access them from the menu bar.

## Features

- **📋 Automatic Clipboard Monitoring**: Automatically captures and stores everything you copy
- **🔄 FIFO Queue Management**: Maintains a configurable number of recent clipboard items (default: 10)
- **📱 Menu Bar Integration**: Clean menu bar icon with instant access to your clipboard history
- **🎨 Customizable Interface**: Configurable menu bar icon (choose from emoji options)
- **📝 Smart Content Detection**: Automatically detects and categorizes different content types:
  - Text documents
  - URLs and links
  - Email addresses
  - Phone numbers
  - Code snippets
- **⚡ One-Click Copy**: Click any item to instantly copy it back to your clipboard
- **💾 Persistent Storage**: Your clipboard history persists between app launches
- **⚙️ Configurable Settings**: Adjust maximum items, menu bar icon, and more

## Requirements

- macOS 13.0 or later
- Xcode 15.0 or later (for building from source)

## Installation

### Option 1: Build from Source

1. **Clone or download the project**:
   ```bash
   git clone <repository-url>
   cd clipboard-manager
   ```

2. **Open in Xcode**:
   ```bash
   open ClipboardManager/ClipboardManager.xcodeproj
   ```

3. **Build and run**:
   - Select your target device (Mac)
   - Press `Cmd + R` to build and run
   - The app will appear in your menu bar

### Option 2: Direct Installation

1. Extract the project files to your desired location
2. Open `ClipboardManager.xcodeproj` in Xcode
3. Build and run the project

## Usage

### Getting Started

1. **Launch the app**: The clipboard manager will start automatically and appear as an icon in your menu bar
2. **Start copying**: Copy any text, URL, or content as you normally would
3. **Access your history**: Click the menu bar icon to see your clipboard history
4. **Copy previous items**: Click on any item in the list to copy it back to your clipboard

### Menu Bar Interface

- **📋 Menu Bar Icon**: Click to open the clipboard history popup
- **Popup Window**: Shows your recent clipboard items in reverse chronological order (newest first)
- **Item Categories**: Items are automatically categorized with appropriate icons:
  - 📄 Text documents
  - 🔗 URLs and links
  - ✉️ Email addresses
  - 📞 Phone numbers
  - {} Code snippets

### Settings Configuration

Click the gear icon (⚙️) in the popup to access settings:

- **Max Items**: Set how many clipboard items to keep (5-50, default: 10)
- **Menu Bar Icon**: Choose from various emoji options for your menu bar
- **Show Timestamps**: Toggle relative timestamp display for items
- **Reset to Defaults**: Restore all settings to their default values

### Keyboard Shortcuts

- **Escape**: Close settings panel
- **Click item**: Copy to clipboard
- **Hover**: Preview copy action

## Project Structure

```
ClipboardManager/
├── ClipboardManager.xcodeproj/          # Xcode project file
└── ClipboardManager/                    # Source code
    ├── ClipboardManagerApp.swift        # Main app entry point
    ├── ContentView.swift                # Main UI view
    ├── ClipboardMonitor.swift           # Clipboard monitoring logic
    ├── ClipboardItem.swift              # Data model for clipboard items
    ├── ClipboardStore.swift             # Data persistence and management
    ├── AppSettings.swift                # User preferences and configuration
    ├── MenuBarView.swift                # Menu bar icon view
    ├── ClipboardPopover.swift           # Popup window view
    ├── Assets.xcassets/                 # App icons and assets
    ├── Preview Content/                 # SwiftUI preview assets
    ├── ClipboardManager.entitlements    # App permissions
    └── Info.plist                       # App configuration
```

## Technical Details

### Architecture

The app follows a clean MVVM architecture with SwiftUI:

- **Models**: `ClipboardItem`, `ClipboardItemType`
- **ViewModels**: `ClipboardStore`, `AppSettings`
- **Views**: `ContentView`, `MenuBarView`, `ClipboardPopover`
- **Services**: `ClipboardMonitor`

### Key Components

1. **ClipboardMonitor**: Monitors system clipboard changes using `NSPasteboard`
2. **ClipboardStore**: Manages FIFO queue of clipboard items with persistence
3. **AppSettings**: Handles user preferences with `@Published` properties
4. **MenuBarExtra**: Uses SwiftUI's `MenuBarExtra` for native menu bar integration

### Data Persistence

- Uses `UserDefaults` for storing clipboard items and user preferences
- Clipboard items are encoded/decoded using `Codable`
- Settings are automatically saved when changed

### Content Detection

The app intelligently detects content types using regular expressions:
- **URLs**: Detects http/https/www patterns
- **Emails**: Validates email format with regex
- **Phone Numbers**: Identifies numeric patterns
- **Code**: Detects programming syntax patterns

## Configuration

### Default Settings

- **Maximum Items**: 10 clipboard items
- **Menu Bar Icon**: 📋 (clipboard emoji)
- **Show Timestamps**: Enabled
- **Monitoring Interval**: 0.5 seconds

### Customization

All settings can be modified through the in-app settings panel:

1. Click the menu bar icon
2. Click the gear icon (⚙️)
3. Adjust your preferences
4. Changes are saved automatically

## Privacy & Security

- **Local Storage Only**: All clipboard data is stored locally on your Mac
- **No Network Access**: The app does not send any data over the network
- **Sandboxed**: Runs in Apple's app sandbox for security
- **Minimal Permissions**: Only requires clipboard access

## Troubleshooting

### Common Issues

1. **App doesn't appear in menu bar**:
   - Check that the app is running (look in Activity Monitor)
   - Try quitting and restarting the app

2. **Clipboard items not being captured**:
   - Ensure the app has accessibility permissions if prompted
   - Check that monitoring is active (restart the app)

3. **Settings not saving**:
   - Verify the app has write permissions to user defaults
   - Try resetting to defaults and reconfiguring

### Debug Information

The app logs activity to the console. To view logs:
1. Open Console.app
2. Search for "ClipboardManager"
3. Look for messages starting with "📋"

## Development

### Building from Source

1. **Prerequisites**:
   - macOS 13.0+
   - Xcode 15.0+
   - Swift 5.9+

2. **Build Steps**:
   ```bash
   # Clone repository
   git clone <repository-url>
   cd clipboard-manager
   
   # Open in Xcode
   open ClipboardManager/ClipboardManager.xcodeproj
   
   # Build and run (Cmd+R)
   ```

3. **Project Configuration**:
   - Target: macOS 13.0+
   - Bundle ID: `com.clipboardmanager.app`
   - Category: Utilities
   - LSUIElement: YES (menu bar only app)

### Code Organization

- **App Lifecycle**: `ClipboardManagerApp.swift`
- **UI Components**: `ContentView.swift`, `MenuBarView.swift`
- **Business Logic**: `ClipboardStore.swift`, `ClipboardMonitor.swift`
- **Data Models**: `ClipboardItem.swift`, `AppSettings.swift`
- **Resources**: `Assets.xcassets`, `Info.plist`

### Adding Features

To extend the app:

1. **New Content Types**: Add cases to `ClipboardItemType` enum
2. **Additional Settings**: Add properties to `AppSettings` class
3. **UI Enhancements**: Modify SwiftUI views in respective files
4. **Storage Changes**: Update `ClipboardStore` persistence logic

## Contributing

Feel free to contribute to this project by:

1. Reporting bugs and issues
2. Suggesting new features
3. Submitting pull requests
4. Improving documentation

## License

This project is available under the MIT License. See the LICENSE file for more information.

## Version History

### v1.0.0 (Current)
- Initial release
- Basic clipboard monitoring and storage
- Menu bar integration
- Configurable settings
- Content type detection
- FIFO queue management
- Persistent storage

## Support

For support, please:
1. Check this README for common solutions
2. Review the troubleshooting section
3. Open an issue on the project repository

---

**Built with ❤️ using Swift and SwiftUI**