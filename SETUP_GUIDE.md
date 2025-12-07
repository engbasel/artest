# Quick Setup Guide - AR  Showroom

## ✅ What's Already Done

Your AR  Showroom is fully configured and ready to run! Here's what's been set up:

### 📁 Project Structure
```
artest/
├── assets/
│   └── models/
│       └── car_model.glb          ✅ 3D model in place
├── lib/
│   ├── models/                     ✅ Data models created
│   ├── viewmodels/                 ✅ Business logic ready
│   ├── widgets/                    ✅ AR & UI widgets built
│   ├── screens/                    ✅ Home & AR screens done
│   └── main.dart                   ✅ App entry configured
├── android/                        ✅ Android permissions set
├── ios/                            ✅ iOS permissions set
└── pubspec.yaml                    ✅ Dependencies configured
```

### 📦 Dependencies Installed

All required packages are installed:
- ✅ `ar_flutter_plugin` - AR functionality
- ✅ `provider` - State management
- ✅ `vector_math` - 3D mathematics
- ✅ `permission_handler` - Runtime permissions
- ✅ `geolocator` - Location services

### 🔧 Platform Configuration

**Android (`android/app/src/main/AndroidManifest.xml`):**
- ✅ Camera permission added
- ✅ Internet permission added
- ✅ ARCore metadata configured
- ✅ Hardware features specified

**iOS (`ios/Runner/Info.plist`):**
- ✅ Camera usage description added
- ✅ ARKit requirement specified

## 🚀 How to Run

### Option 1: Using VS Code / Android Studio

1. **Connect your device** (AR doesn't work on emulators!)
2. **Open the project** in your IDE
3. **Press F5** or click the Run button
4. **Select your device** from the device list
5. **Wait for build** to complete

### Option 2: Using Command Line

```bash
# Make sure you're in the project directory
cd d:\courses\Flutter\projects\artest

# Check connected devices
flutter devices

# Run on connected device
flutter run
```

## 📱 Device Requirements

### Android
- Device must support ARCore ([Check list](https://developers.google.com/ar/devices))
- Android 7.0 (API 24) or higher
- Camera permission required

### iOS
- iPhone 6S or newer
- iOS 11.0 or higher
- Camera permission required

## 🎯 First Time Setup Steps

### Step 1: Grant Permissions
When you first launch the app, it will ask for camera permission:
- **Tap "Allow"** when prompted
- If you accidentally denied it, go to device Settings → Apps → AR  Showroom → Permissions

### Step 2: Launch AR
- Tap the **"Launch AR Experience"** button on the home screen
- Wait for the AR session to initialize (loading indicator will show)

### Step 3: Find a Surface
- Point your camera at a **flat surface** (floor, table, ground)
- Move your device **slowly** to help detect the plane
- You'll see a grid or dots when a surface is detected

### Step 4: Place the Car
- The car model will automatically appear on the detected surface
- If it doesn't appear, try moving to a different surface or improve lighting

### Step 5: Customize Colors
- Scroll through the color picker at the bottom
- Tap any color to change the car instantly
- Try all 5 colors: Red, Black, White, Blue, Silver

### Step 6: Explore
- **Walk around** the car to see it from all angles
- **Use gestures**: rotate, scale, pan
- **Tap the reset button** (floating button) to reposition

## 🐛 Common Issues & Solutions

### Issue: "AR Not Supported"
**Solution:** You're running on an emulator or unsupported device. Use a physical device with ARCore/ARKit support.

### Issue: "Camera Permission Denied"
**Solution:** 
1. Go to Settings → Apps → AR  Showroom → Permissions
2. Enable Camera
3. Restart the app

### Issue: "Model Not Loading"
**Solution:**
```bash
flutter clean
flutter pub get
flutter run
```

### Issue: "Build Failed"
**Solution:**
1. Check that you have the latest Flutter SDK
2. Run `flutter doctor` to check for issues
3. Ensure Android SDK or Xcode is properly installed

### Issue: "Can't Detect Surfaces"
**Solution:**
- Ensure good lighting
- Point at a flat, textured surface
- Move device slowly
- Avoid reflective or transparent surfaces

## 📝 Code Structure Overview

### Main Entry Point
```dart
lib/main.dart
```
- Initializes the app
- Sets up Provider for state management
- Configures theme and navigation

### Home Screen
```dart
lib/screens/home_screen.dart
```
- Beautiful landing page
- Feature highlights
- Launch button for AR experience

### AR Screen
```dart
lib/screens/ar_car_screen.dart
```
- Main AR experience
- Permission handling
- Camera view with overlays
- Color picker integration
- Reset functionality

### AR View Widget
```dart
lib/widgets/unified_ar_view_widget.dart
```
- Handles AR session management
- Loads and displays 3D model
- Manages plane detection
- Supports both Android and iOS

### Color Picker
```dart
lib/widgets/color_picker_widget.dart
```
- Beautiful UI for color selection
- Animated transitions
- Glassmorphism design

### ViewModel
```dart
lib/viewmodels/ar_viewmodel.dart
```
- Manages AR state
- Handles color changes
- Controls model transformations
- Provides loading states

### Models
```dart
lib/models/car_color_model.dart  // Color definitions
lib/models/ar_node_model.dart    // 3D node properties
```

## 🎨 Customization Quick Tips

### Change Available Colors
Edit `lib/models/car_color_model.dart`:
```dart
static const List<CarColorModel> availableColors = [
  CarColorModel(
    name: 'purple',
    color: Color(0xFF9B59B6),
    displayName: 'Royal Purple',
  ),
  // Add more colors...
];
```

### Adjust Model Size
Edit `lib/widgets/unified_ar_view_widget.dart` (line ~87):
```dart
scale: vector.Vector3(0.5, 0.5, 0.5), // Make bigger or smaller
```

### Change Initial Distance
Edit `lib/widgets/unified_ar_view_widget.dart` (line ~88):
```dart
position: vector.Vector3(0.0, -0.5, -1.5), // Adjust Z value
```

## 📚 Next Steps

1. **Test the app** on your device
2. **Try all color options** to see the customization
3. **Explore different surfaces** for AR placement
4. **Read the main README.md** for detailed documentation
5. **Customize colors** or add new features

## 🆘 Need Help?

1. Check the main **README.md** for detailed documentation
2. Review **troubleshooting section** for common issues
3. Run `flutter doctor` to check your development environment
4. Check device compatibility lists for ARCore/ARKit

## ✨ You're All Set!

Everything is configured and ready to go. Just run the app and enjoy your AR  showroom experience!

```bash
flutter run
```

**Happy AR Development! 🚗✨**
