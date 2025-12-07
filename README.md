# AR  Showroom - Local 3D Model Support

## 🎯 Overview
This AR application now supports loading custom 3D models from your device storage, allowing you to visualize any 3D model in augmented reality with color customization.

## ✨ Features

### 1. **Local Model Selection**
- Pick 3D models directly from your device storage
- Supported formats: `.glb`, `.gltf`, `.obj`
- Real-time model switching in AR view

### 2. **Color Customization**
- Change model colors on the fly
- 5 premium color options available
- Instant color updates in AR

### 3. **AR Experience**
- Place models in your real environment
- 360° rotation and viewing
- Pinch to scale
- Drag to move

## 📱 How to Use

### Loading a Custom Model

#### From Home Screen:
1. Open the app
2. Tap on **"Choose 3D Model"** button in the "Selected Model" card
3. Browse and select a `.glb`, `.gltf`, or `.obj` file from your device
4. The model name will appear in the card
5. Tap **"Launch AR Experience"** to view it in AR

#### From AR Screen:
1. While in AR view, tap the **3D rotation icon** (bottom left)
2. Select a new model from your device
3. The AR view will automatically reload with the new model

### Changing Colors:
1. In AR view, scroll through the color picker at the bottom
2. Tap any color to apply it to your model
3. Colors update instantly

### Resetting Position:
- Tap the **refresh icon** (bottom right) to reset the model position

## 🔧 Technical Details

### File Picker Implementation
- Uses `file_picker` package for cross-platform file selection
- Manual validation for 3D model file extensions
- Error handling for invalid file types

### Permissions Required
- **Camera**: For AR functionality
- **Storage**: For accessing 3D model files from device

### Supported Platforms
- ✅ Android (ARCore)
- ✅ iOS (ARKit)

## 📂 Project Structure

```
lib/
├── main.dart                          # App entry point
├── models/
│   ├── ar_node_model.dart            # AR node data model
│   └── car_color_model.dart          # Color options model
├── screens/
│   ├── home_screen.dart              # Home with model picker
│   └── ar_car_screen.dart            # AR view screen
├── viewmodels/
│   └── ar_viewmodel.dart             # State management + file picker
└── widgets/
    ├── unified_ar_view_widget.dart   # AR rendering widget
    └── color_picker_widget.dart      # Color selection UI
```

## 🎨 UI Features

### Home Screen
- **Model Selection Card**: Shows currently selected model
- **Choose Model Button**: Opens file picker
- **Remove Custom Model**: Returns to default model
- **Feature Cards**: Highlights app capabilities

### AR Screen
- **Model Picker FAB**: Quick access to change models
- **Reset FAB**: Reset model position
- **Color Picker**: Bottom sheet with color options
- **Instructions Overlay**: Helpful tips for AR interaction

## 🚀 Getting Started

### Prerequisites
```bash
flutter pub get
```

### Running the App
```bash
flutter run
```

### Building for Release
```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release
```

## 📝 Notes

### Model File Requirements
- Files must have `.glb`, `.gltf`, or `.obj` extension
- Models should be optimized for mobile AR
- Recommended file size: < 50MB for best performance

### Color Customization
- Colors are applied to the model's materials
- Some models may not support color changes depending on their material setup
- Best results with models that have simple, single-color materials

## 🐛 Troubleshooting

### "Unsupported file type" error
- Make sure your file has a valid extension (`.glb`, `.gltf`, `.obj`)
- File extension is case-insensitive

### Model not appearing in AR
- Ensure the model file is not corrupted
- Try a different model to verify AR functionality
- Check that camera permissions are granted

### Performance Issues
- Use optimized models with lower polygon counts
- Reduce texture sizes if possible
- Close other apps to free up memory

## 🔄 Recent Updates

### v1.0.0 (Current)
- ✅ Added local 3D model file picker
- ✅ Support for .glb, .gltf, and .obj formats
- ✅ Real-time model switching in AR
- ✅ Enhanced error handling and user feedback
- ✅ Improved UI with model selection card
- ✅ Added storage permissions for Android

## 📄 License
This project is for demonstration purposes.

## 👨‍💻 Development
Built with Flutter and AR Flutter Plugin (Updated)
