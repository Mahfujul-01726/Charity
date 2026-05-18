# 🚀 Quick Start Guide - HelpConnect App

## Running the App

### Option 1: Run on Android Emulator/Device

1. **Start Android Emulator** (if using emulator)
   - Open Android Studio
   - Start AVD (Android Virtual Device)

2. **Connect Physical Device** (if using real phone)
   - Enable USB Debugging on your Android phone
   - Connect via USB

3. **Run the app**
   ```bash
   flutter run
   ```

### Option 2: Build APK for Installation

1. **Build Release APK**
   ```bash
   flutter build apk --release
   ```

2. **Locate APK**
   - File location: `build/app/outputs/flutter-apk/app-release.apk`
   - Transfer to Android phone
   - Install and run

## App Navigation Flow

```
Splash Screen (3 seconds)
    ↓
Onboarding (3 pages - can skip)
    ↓
Login/Signup Screen
    ↓
Home Dashboard
    ├── Blood Donation
    ├── Medicine Donation
    ├── Clothes Donation
    ├── Food Donation
    ├── Money Donation (Campaigns)
    ├── Emergency Help
    ├── NGO Locator (Map)
    └── Create Request
    
Bottom Navigation:
    ├── Home
    ├── Search
    ├── Activity (Donation History)
    └── Profile (Settings, Dark Mode)
```

## Key Features to Test

### 1. Authentication
- Open app → See splash animation
- Swipe through 3 onboarding pages OR tap "Skip"
- Try login/signup forms
- Tap "Continue with Google" (placeholder)

### 2. Home Dashboard
- View stats cards (12 donations, 35 impacted, 48 hours)
- Swipe featured campaigns carousel
- Check water project progress (75%)
- Tap any donation category card

### 3. Donation Modules
- **Blood**: Select blood type filter, view donor cards
- **Medicine**: Enter medicine name, set quantity, pick date, upload photo
- **Clothes**: Select category, upload photos, add description
- **Food**: Add food details, set servings, schedule pickup
- **Money**: Browse campaigns, view progress, tap "Donate Now"

### 4. Additional Features
- **History**: View timeline of past donations
- **Campaign Detail**: See full campaign info, story, donors
- **Create Request**: Fill multi-step form (Details → Items → Review)
- **NGO Locator**: View map, browse NGO cards, see ratings
- **Profile**: Toggle dark mode, view settings

## Testing Dark Mode

1. Open app and navigate to Profile tab (bottom navigation)
2. Scroll down to "Dark Mode" toggle
3. Switch ON/OFF
4. Navigate through different screens to see dark theme

## Troubleshooting

### Issue: App won't build
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter run
```

### Issue: Gradle build failed
```bash
# Navigate to android folder
cd android
./gradlew clean

# Return to root
cd ..
flutter run
```

### Issue: GetX errors
- All GetX dependencies are installed
- If errors persist, restart IDE and run `flutter pub get`

## Color Themes to Notice

- **Gradients**: Purple → Blue → Cyan (primary)
- **Buttons**: Various gradient combinations
- **Dark Mode**: Dark blue backgrounds (#0F172A, #1E293B)
- **Accent Colors**: Cyan (#06B6D4), Pink (#EC4899), Orange (#FB923C)

## Sample Data Included

- 3 Featured Campaigns
- 3 Donation History Items (per month)
- 3 NGOs in Locator
- 3 Donors in Blood Donation
- 3 Campaign Cards in Money Donation

## Known Limitations (Placeholders)

These features have UI but need backend:
- ❌ Google Sign-In (needs Firebase config)
- ❌ Actual Payment Processing
- ❌ Real Google Maps (needs API key)
- ❌ Image Upload to Server
- ❌ Push Notifications
- ❌ Real-time Data Sync

## Next Development Steps

1. **Add Firebase**
   - Create project at console.firebase.google.com
   - Download google-services.json
   - Place in android/app/
   - Enable Authentication

2. **Add Google Maps API**
   - Get key from console.cloud.google.com
   - Add to AndroidManifest.xml

3. **Backend Integration**
   - Connect to REST API or Firebase
   - Implement data models
   - Add state persistence

## File Structure Reference

```
lib/
├── main.dart                          # App entry point
├── app/
│   ├── controllers/
│   │   └── theme_controller.dart      # Dark mode controller
│   ├── core/theme/                    # Colors, styles, themes
│   ├── screens/                       # All 16 screens
│   └── widgets/                       # Reusable widgets
```

## Build Commands Cheat Sheet

```bash
# Install dependencies
flutter pub get

# Run debug mode
flutter run

# Run release mode
flutter run --release

# Build APK
flutter build apk --release

# Build App Bundle (for Play Store)
flutter build appbundle --release

# Analyze code
flutter analyze

# Run tests
flutter test

# Clean build
flutter clean
```

## Useful Tips

1. **Hot Reload**: Press `r` in terminal while app is running
2. **Hot Restart**: Press `R` in terminal
3. **Quit**: Press `q` in terminal
4. **Toggle Performance Overlay**: Press `p` in terminal
5. **Take Screenshot**: Use Android device screenshot feature

## Support

For issues or questions:
1. Check PROJECT_SUMMARY.md for detailed implementation info
2. Check README.md for project overview
3. Review code comments in source files

---

**Enjoy testing HelpConnect! 🎉**
