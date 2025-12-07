import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:provider/provider.dart';
import '../viewmodels/ar_viewmodel.dart';

/// Screen for viewing 3D models without AR using model_viewer_plus
class ModelViewerScreen extends StatefulWidget {
  const ModelViewerScreen({Key? key}) : super(key: key);

  @override
  State<ModelViewerScreen> createState() => _ModelViewerScreenState();
}

class _ModelViewerScreenState extends State<ModelViewerScreen> {
  bool _showColorPicker = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a1a2e),
      body: Consumer<ARViewModel>(
        builder: (context, viewModel, child) {
          // Check if a model is selected
          if (!viewModel.hasCustomModel) {
            return _buildNoModelView(context, viewModel);
          }

          return Stack(
            children: [
              // 3D Model Viewer
              _buildModelViewer(viewModel),

              // Top App Bar
              _buildTopBar(context),

              // Color Picker Panel
              if (_showColorPicker) _buildColorPicker(viewModel),

              // Bottom Controls
              _buildBottomControls(viewModel),
            ],
          );
        },
      ),
    );
  }

  Widget _buildNoModelView(BuildContext context, ARViewModel viewModel) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: const Color(0xFF53a8e2).withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.threed_rotation,
                  size: 80,
                  color: const Color(0xFF53a8e2),
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'لم يتم اختيار موديل',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'الرجاء اختيار موديل 3D من الصفحة الرئيسية',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back),
                label: const Text('العودة للصفحة الرئيسية'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF53a8e2),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModelViewer(ARViewModel viewModel) {
    // Convert Flutter Color to hex string for model-viewer
    final colorHex =
        '#${viewModel.selectedColor.color.value.toRadixString(16).substring(2)}';

    return ModelViewer(
      key: ValueKey(
        viewModel.selectedColor.name,
      ), // Force rebuild on color change
      src: 'file://${viewModel.selectedModelPath}',
      alt: viewModel.selectedModelName ?? 'موديل 3D',
      ar: false, // Disable AR mode
      autoRotate: true,
      cameraControls: true,
      backgroundColor: const Color(0xFF1a1a2e),
      loading: Loading.eager,
      interactionPrompt: InteractionPrompt.none,
      // Custom camera settings for better view
      cameraOrbit: '0deg 75deg 105%',
      minCameraOrbit: 'auto auto 5%',
      maxCameraOrbit: 'auto auto 500%',
      // Enable shadows for better depth perception
      shadowIntensity: 1.0,
      shadowSoftness: 0.8,
      // Environment and lighting
      exposure: 1.0,
      // Apply color using JavaScript to change material color
      relatedJs:
          '''
        const modelViewer = document.querySelector('model-viewer');
        
        // Wait for model to load
        modelViewer.addEventListener('load', () => {
          const material = modelViewer.model.materials[0];
          
          if (material) {
            // Set the base color
            material.pbrMetallicRoughness.setBaseColorFactor('$colorHex');
            
            // Optional: Adjust metallic and roughness for better appearance
            material.pbrMetallicRoughness.setMetallicFactor(0.8);
            material.pbrMetallicRoughness.setRoughnessFactor(0.3);
          }
        });
        
        // Also apply immediately if already loaded
        if (modelViewer.loaded) {
          const material = modelViewer.model.materials[0];
          if (material) {
            material.pbrMetallicRoughness.setBaseColorFactor('$colorHex');
            material.pbrMetallicRoughness.setMetallicFactor(0.8);
            material.pbrMetallicRoughness.setRoughnessFactor(0.3);
          }
        }
      ''',
      relatedCss: '''
        model-viewer {
          --poster-color: transparent;
        }
      ''',
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Back button
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                tooltip: 'رجوع',
              ),
            ),
            const SizedBox(width: 12),
            // Title
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Consumer<ARViewModel>(
                  builder: (context, viewModel, child) {
                    return Text(
                      viewModel.selectedModelName ?? 'موديل 3D',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomControls(ARViewModel viewModel) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.7),
                Colors.black.withOpacity(0.9),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFF53a8e2).withOpacity(0.3),
              width: 2,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Current color indicator
              Row(
                children: [
                  const Icon(Icons.palette, color: Color(0xFF53a8e2), size: 24),
                  const SizedBox(width: 12),
                  const Text(
                    'اللون الحالي:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: viewModel.selectedColor.color,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: viewModel.selectedColor.color.withOpacity(0.5),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      viewModel.selectedColor.name,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Change color button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _showColorPicker = !_showColorPicker;
                    });
                  },
                  icon: Icon(_showColorPicker ? Icons.close : Icons.color_lens),
                  label: Text(
                    _showColorPicker ? 'إغلاق' : 'تغيير اللون',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF53a8e2),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildColorPicker(ARViewModel viewModel) {
    return Positioned(
      top: 100,
      left: 16,
      right: 16,
      child: Container(
        constraints: const BoxConstraints(maxHeight: 400),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.black.withOpacity(0.9),
              const Color(0xFF1a1a2e).withOpacity(0.95),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFF53a8e2).withOpacity(0.5),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Icon(Icons.palette, color: Color(0xFF53a8e2), size: 24),
                const SizedBox(width: 12),
                const Text(
                  'اختر اللون',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _showColorPicker = false;
                    });
                  },
                  icon: const Icon(Icons.close, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Color options grid with scroll
            Flexible(
              child: SingleChildScrollView(
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1,
                  ),
                  itemCount: viewModel.availableColors.length,
                  itemBuilder: (context, index) {
                    final color = viewModel.availableColors[index];
                    final isSelected =
                        color.name == viewModel.selectedColor.name;

                    return GestureDetector(
                      onTap: () {
                        viewModel.changeCarColor(color);
                        // Show feedback
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'تم تغيير اللون إلى ${color.displayName}',
                            ),
                            backgroundColor: const Color(0xFF53a8e2),
                            duration: const Duration(milliseconds: 800),
                          ),
                        );
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: color.color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? Colors.white
                                : Colors.white.withOpacity(0.3),
                            width: isSelected ? 3 : 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: color.color.withOpacity(0.5),
                              blurRadius: isSelected ? 12 : 6,
                              spreadRadius: isSelected ? 3 : 1,
                            ),
                          ],
                        ),
                        child: isSelected
                            ? const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 24,
                              )
                            : null,
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Selected color name
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF53a8e2).withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF53a8e2), width: 1),
              ),
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: viewModel.selectedColor.color,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      viewModel.selectedColor.displayName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
