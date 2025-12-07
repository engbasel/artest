import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/ar_viewmodel.dart';
import '../widgets/unified_ar_view_widget.dart';
import '../widgets/color_picker_widget.dart';
import 'package:permission_handler/permission_handler.dart';

/// Main AR Screen for car visualization
class ARCarScreen extends StatefulWidget {
  const ARCarScreen({Key? key}) : super(key: key);

  @override
  State<ARCarScreen> createState() => _ARCarScreenState();
}

class _ARCarScreenState extends State<ARCarScreen> {
  bool _permissionGranted = false;
  bool _checkingPermission = true;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    final status = await Permission.camera.request();
    setState(() {
      _permissionGranted = status.isGranted;
      _checkingPermission = false;
    });

    if (_permissionGranted) {
      // Initialize AR
      if (mounted) {
        context.read<ARViewModel>().initializeAR();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _checkingPermission
          ? _buildPermissionCheckingView()
          : !_permissionGranted
          ? _buildPermissionDeniedView()
          : _buildARView(),
    );
  }

  Widget _buildPermissionCheckingView() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      ),
    );
  }

  Widget _buildPermissionDeniedView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.camera_alt_outlined,
              size: 80,
              color: Colors.white54,
            ),
            const SizedBox(height: 24),
            const Text(
              'Camera Permission Required',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'To experience AR, please grant camera permission in your device settings.',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                openAppSettings();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Open Settings',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildARView() {
    return Consumer<ARViewModel>(
      builder: (context, viewModel, child) {
        return Stack(
          children: [
            // Unified AR View for both platforms
            if (Platform.isAndroid || Platform.isIOS)
              UnifiedARViewWidget(
                modelPath: viewModel.arNode.modelPath,
                selectedColor: viewModel.selectedColor,
                onModelLoaded: () {
                  // Model loaded callback
                },
              )
            else
              _buildUnsupportedPlatformView(),

            // Loading overlay
            if (viewModel.isLoading) _buildLoadingOverlay(),

            // Top bar with back button and title
            _buildTopBar(context),

            // Bottom color picker
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: ColorPickerWidget(
                colors: viewModel.availableColors,
                selectedColor: viewModel.selectedColor,
                onColorSelected: (color) {
                  viewModel.changeCarColor(color);
                },
              ),
            ),

            // Model picker button
            Positioned(
              left: 20,
              bottom: 240,
              child: _buildModelPickerButton(viewModel),
            ),

            // Reset button
            Positioned(
              right: 20,
              bottom: 240,
              child: _buildResetButton(viewModel),
            ),

            // Instructions overlay (shown when loading is complete)
            if (!viewModel.isLoading && viewModel.isModelLoaded)
              _buildInstructionsOverlay(),
          ],
        );
      },
    );
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.8),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 3,
            ),
            const SizedBox(height: 24),
            const Text(
              'Loading AR Experience...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please point your camera at a flat surface',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black.withOpacity(0.7), Colors.transparent],
            ),
          ),
          child: Row(
            children: [
              // Back button
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.2),
                  padding: const EdgeInsets.all(12),
                ),
              ),
              const SizedBox(width: 16),

              // Title
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AR Car Preview',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Visualize your dream car',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModelPickerButton(ARViewModel viewModel) {
    return FloatingActionButton(
      onPressed: () async {
        final picked = await viewModel.pickModelFile();
        if (picked && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Model loaded: ${viewModel.selectedModelName}'),
              duration: const Duration(seconds: 2),
              backgroundColor: const Color(0xFF53a8e2),
            ),
          );
          // Re-initialize AR with new model
          viewModel.initializeAR();
        } else if (!picked && viewModel.errorMessage != null && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(viewModel.errorMessage!),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      },
      backgroundColor: const Color(0xFF53a8e2),
      child: const Icon(Icons.threed_rotation, color: Colors.white),
    );
  }

  Widget _buildResetButton(ARViewModel viewModel) {
    return FloatingActionButton(
      onPressed: () {
        viewModel.resetCarPosition();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Car position reset'),
            duration: Duration(seconds: 1),
            backgroundColor: Colors.blue,
          ),
        );
      },
      backgroundColor: Colors.white,
      child: const Icon(Icons.refresh, color: Colors.black),
    );
  }

  Widget _buildInstructionsOverlay() {
    return Positioned(
      top: 120,
      left: 20,
      right: 20,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
        ),
        child: Row(
          children: [
            const Icon(Icons.touch_app, color: Colors.white, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Move your device to explore the car from all angles',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUnsupportedPlatformView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 80, color: Colors.white54),
            const SizedBox(height: 24),
            const Text(
              'AR Not Supported',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'AR features are only available on iOS and Android devices.',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
