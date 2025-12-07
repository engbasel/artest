# Usage Examples - AR Car Showroom

## 📖 Table of Contents
1. [Basic Usage](#basic-usage)
2. [Advanced Features](#advanced-features)
3. [Code Examples](#code-examples)
4. [Best Practices](#best-practices)

---

## Basic Usage

### Example 1: Loading Your First Custom Model

**Scenario**: You have a car model file `my_car.glb` on your device.

**Steps**:
1. Open the AR Car Showroom app
2. On the home screen, locate the "Selected Model" card
3. Tap the **"Choose 3D Model"** button
4. Navigate to your file location
5. Select `my_car.glb`
6. You'll see a success message: "Model loaded: my_car.glb"
7. Tap **"Launch AR Experience"**
8. Point your camera at a flat surface
9. Your custom car model will appear!

### Example 2: Changing Colors

**Scenario**: You want to see your car in different colors.

**Steps**:
1. While in AR view, look at the bottom of the screen
2. You'll see 5 color circles
3. Swipe left/right to browse colors
4. Tap any color to apply it instantly
5. The car color changes in real-time!

**Available Colors**:
- 🔴 Red
- 🔵 Blue  
- ⚫ Black
- ⚪ White
- 🟢 Green

### Example 3: Switching Models in AR

**Scenario**: You want to compare two different car models.

**Steps**:
1. Load your first model and launch AR
2. Tap the **3D rotation icon** (bottom left)
3. Select your second model
4. The AR view automatically reloads
5. Your new model appears in the same position!

---

## Advanced Features

### Example 4: Using Different File Formats

**Supported Formats**:

#### GLB (Recommended)
```
✅ Best performance
✅ Single file
✅ Includes textures
Example: sports_car.glb
```

#### GLTF
```
✅ Good performance
⚠️  May need separate texture files
Example: sedan.gltf
```

#### OBJ
```
⚠️  Basic support
⚠️  Requires separate MTL file for materials
Example: truck.obj
```

### Example 5: Optimizing Model Performance

**Before Loading**:
- Check file size (keep under 50MB)
- Reduce polygon count if needed
- Compress textures

**Good Model Example**:
```
File: optimized_car.glb
Size: 15 MB
Polygons: 50,000
Textures: 2048x2048
Result: ✅ Smooth performance
```

**Poor Model Example**:
```
File: heavy_car.glb
Size: 150 MB
Polygons: 500,000
Textures: 4096x4096
Result: ❌ Laggy, may crash
```

---

## Code Examples

### Example 6: Programmatic Model Loading

If you're a developer extending this app:

```dart
// In your ViewModel or Controller
final viewModel = context.read<ARViewModel>();

// Load a model programmatically
bool success = await viewModel.pickModelFile();

if (success) {
  print('Model loaded: ${viewModel.selectedModelName}');
  print('Path: ${viewModel.selectedModelPath}');
} else {
  print('Error: ${viewModel.errorMessage}');
}
```

### Example 7: Handling Model Changes

```dart
// Listen to model changes
Consumer<ARViewModel>(
  builder: (context, viewModel, child) {
    return Text(
      viewModel.hasCustomModel 
        ? 'Custom: ${viewModel.selectedModelName}'
        : 'Default Model'
    );
  },
)
```

### Example 8: Resetting to Default Model

```dart
// Reset to the built-in car model
viewModel.useDefaultModel();
```

---

## Best Practices

### ✅ DO

1. **Use Optimized Models**
   - Keep file sizes reasonable (< 50MB)
   - Use compressed textures
   - Reduce unnecessary polygons

2. **Test in Good Lighting**
   - Natural daylight works best
   - Avoid direct sunlight
   - Use consistent lighting

3. **Choose Flat Surfaces**
   - Tables, floors, desks
   - Avoid carpets or textured surfaces
   - Ensure good contrast

4. **Validate Files**
   - Check file extension before selecting
   - Test models in 3D viewer first
   - Keep backups of working models

### ❌ DON'T

1. **Don't Use Huge Files**
   - Avoid > 100MB models
   - Don't use 4K+ textures
   - Skip unnecessary details

2. **Don't Expect All Colors to Work**
   - Some models have baked textures
   - Materials may not support color changes
   - Test color customization first

3. **Don't Move Too Fast**
   - AR tracking needs stable camera
   - Slow movements work better
   - Give AR time to initialize

---

## Real-World Scenarios

### Scenario A: Car Dealership Demo

**Use Case**: Show customers different car models in their driveway.

**Workflow**:
1. Prepare 5-10 car models (.glb format)
2. Load first model in showroom
3. Customer launches AR in their driveway
4. Switch between models using the 3D icon
5. Try different colors for each model
6. Customer makes informed decision!

### Scenario B: 3D Artist Portfolio

**Use Case**: Showcase your 3D modeling work in AR.

**Workflow**:
1. Export your models as .glb
2. Load them in the app
3. View in real-world scale
4. Take screenshots for portfolio
5. Share AR experience with clients

### Scenario C: Educational Demo

**Use Case**: Teach students about car design.

**Workflow**:
1. Prepare models of different car types
2. Load classic car model
3. Compare with modern car model
4. Discuss design differences in AR
5. Students interact with 3D models

---

## Troubleshooting Examples

### Problem: "Unsupported file type" Error

**Example Error**:
```
Please select a valid 3D model file (.glb, .gltf, or .obj)
```

**Solution**:
```
❌ Wrong: my_car.fbx
❌ Wrong: my_car.blend
✅ Correct: my_car.glb
✅ Correct: my_car.gltf
✅ Correct: my_car.obj
```

### Problem: Model Too Dark/Bright

**Cause**: Lighting in AR environment

**Solution**:
1. Move to different location
2. Adjust room lighting
3. Try different time of day
4. Use model with better materials

### Problem: Colors Not Changing

**Cause**: Model has baked textures

**Solution**:
1. Use models with simple materials
2. Check if model supports color changes
3. Try a different model
4. Edit model in 3D software to add color support

---

## Tips & Tricks

### 💡 Tip 1: Quick Model Comparison
Load multiple models and switch between them quickly using the 3D icon in AR view.

### 💡 Tip 2: Perfect Positioning
Use the reset button to quickly reposition the model if it drifts.

### 💡 Tip 3: Best Viewing Angle
Walk around the model in AR for a full 360° view.

### 💡 Tip 4: Screenshot Ready
Position model, choose color, then take screenshot for sharing.

### 💡 Tip 5: Performance Mode
Close other apps before launching AR for best performance.

---

**Happy AR Modeling! 🚗✨**
