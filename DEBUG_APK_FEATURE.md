# Debug APK Sharing Feature

## Settings Screen Integration

The debug APK sharing feature has been integrated into the Settings screen under Developer Options:

```
Settings Screen
├── Profile Header
├── App Preferences 
│   ├── Notifications
│   ├── Dark Mode
│   ├── Language
│   └── Currency
├── Support & Legal
│   ├── Help Center
│   ├── Terms of Service
│   └── Privacy Policy
├── App Information
│   ├── About Pipit
│   └── Check for Updates
└── Developer Options (Debug Mode Only)
    ├── Debug Information
    ├── API Settings
    └── Share Debug APK  ← NEW FEATURE
```

## Debug APK Dialog Features

When users tap "Share Debug APK", they get a comprehensive dialog with:

### Information Section
- Explanation of what debug APKs are
- Available build types (Development & Staging)
- Package name information

### Action Buttons
1. **Cancel** - Close the dialog
2. **Copy Info** - Copy debug APK information to clipboard
3. **Download** - Open download instructions

### Copy Info Content
```
Debug APK Information:
    
Repository: rclet/hook
Access: GitHub Actions Artifacts

To download debug APKs:
1. Visit: https://github.com/rclet/hook/actions
2. Click on the latest workflow run
3. Download "android-debug-apks" artifact
4. Extract and install the APK

Development Build: app-dev-debug.apk
Staging Build: app-staging-debug.apk

Package Names:
- Dev: com.nupuit.pipit.dev  
- Staging: com.nupuit.pipit.staging

Note: Debug builds include additional logging and are for testing only.
```

## Download Instructions Dialog

Step-by-step visual guide:
1. Visit GitHub repository
2. Go to Actions tab  
3. Select latest workflow run
4. Download "android-debug-apks"
5. Extract and install APK

## CI/CD Integration

The feature works seamlessly with the enhanced CI/CD pipeline:

- **Automatic Builds**: Debug APKs built on every push
- **Artifact Storage**: Available as GitHub Actions artifacts
- **Multiple Flavors**: Separate dev and staging builds
- **Easy Access**: Direct links and instructions provided

## User Experience

- ✅ Only visible in debug builds (Developer Options)
- ✅ Clear instructions and guidance
- ✅ Clipboard integration for easy sharing
- ✅ Professional UI with proper theming
- ✅ Step-by-step download process
- ✅ Package name information for testing