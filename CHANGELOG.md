# Changelog - AR  Showroom

## Version 1.0.0 - Local 3D Model Support (2025-12-04)

### ✨ New Features

#### 🎨 Local 3D Model Loading
- **File Picker Integration**: Users can now select 3D models from device storage
- **Supported Formats**: `.glb`, `.gltf`, `.obj` files
- **Real-time Switching**: Change models on the fly in AR view
- **Model Validation**: Automatic validation of file extensions
- **Error Handling**: User-friendly error messages for invalid files

#### 🏠 Enhanced Home Screen
- **Model Selection Card**: New UI component showing currently selected model
- **Model Info Display**: Shows model name and type (Custom/Default)
- **Quick Switch**: Easy toggle between custom and default models
- **Visual Feedback**: Success/error messages via SnackBar

#### 📱 Improved AR Screen
- **Model Picker FAB**: Floating action button for quick model selection
- **Dynamic Reloading**: Automatic AR view refresh when model changes
- **Better UX**: Loading states and error handling

### 🔧 Technical Improvements

#### Dependencies Added
```yaml
file_picker: ^8.1.4      # For selecting files from device
path_provider: ^2.1.5    # For file path management
```

#### Permissions Added (Android)
- `READ_EXTERNAL_STORAGE` (API ≤ 32)
- `READ_MEDIA_IMAGES` (API ≥ 33)
- `READ_MEDIA_VIDEO` (API ≥ 33)
- `READ_MEDIA_AUDIO` (API ≥ 33)

#### Code Structure
- **ARViewModel**: Enhanced with file picker logic
  - `pickModelFile()`: Select and validate 3D model files
  - `useDefaultModel()`: Reset to built-in model
  - `hasCustomModel`: Track custom model state
  
- **UnifiedARViewWidget**: Improved model reloading
  - `_reloadModel()`: Handle model path changes
  - Dynamic model switching support

- **HomeScreen**: New model selection UI
  - Model info card with gradient design
  - Error handling and user feedback
  
- **ARCarScreen**: Enhanced with model picker
  - Floating action button for model selection
  - Integrated error handling

### 🐛 Bug Fixes
- Fixed file picker extension validation for Android
- Improved error messages for unsupported file types
- Better handling of file path validation

### 📚 Documentation
- Added comprehensive README.md (English)
- Added README_AR.md (Arabic)
- Added QUICKSTART.md for quick reference
- Inline code documentation

### 🎨 UI/UX Improvements
- Modern gradient design for model selection card
- Consistent color scheme (Blue: #53a8e2)
- Smooth transitions and animations
- Clear visual hierarchy
- Responsive error messages

### 🔄 Breaking Changes
None - Fully backward compatible

### 📝 Notes
- File picker uses `FileType.any` due to Android limitations with custom extensions
- Manual validation ensures only valid 3D model files are accepted
- Models are loaded from absolute file paths
- Color customization works best with simple material models

### 🚀 Performance
- Optimized model loading
- Efficient state management
- Minimal memory footprint

### 🔮 Future Enhancements
- [ ] Model preview before loading
- [ ] Multiple model management
- [ ] Model library/favorites
- [ ] Advanced material editing
- [ ] Model sharing capabilities
- [ ] Cloud storage integration

---

## Previous Versions

### Version 0.1.0 - Initial Release
- Basic AR functionality
- Single default car model
- 5 color options
- Camera permission handling
- Cross-platform support (Android/iOS)
