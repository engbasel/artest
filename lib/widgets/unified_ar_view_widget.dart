import 'package:flutter/material.dart';
import 'package:ar_flutter_plugin_updated/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin_updated/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin_updated/datatypes/node_types.dart';
import 'package:ar_flutter_plugin_updated/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin_updated/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin_updated/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin_updated/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin_updated/models/ar_node.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'dart:io';
import '../models/car_color_model.dart';

/// Unified AR view widget for both Android and iOS
class UnifiedARViewWidget extends StatefulWidget {
  final String modelPath;
  final CarColorModel selectedColor;
  final VoidCallback onModelLoaded;

  const UnifiedARViewWidget({
    Key? key,
    required this.modelPath,
    required this.selectedColor,
    required this.onModelLoaded,
  }) : super(key: key);

  @override
  State<UnifiedARViewWidget> createState() => _UnifiedARViewWidgetState();
}

class _UnifiedARViewWidgetState extends State<UnifiedARViewWidget> {
  ARSessionManager? arSessionManager;
  ARObjectManager? arObjectManager;
  ARAnchorManager? arAnchorManager;
  ARNode? carNode;
  bool modelPlaced = false;

  @override
  void dispose() {
    arSessionManager?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(UnifiedARViewWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Reload model if path changed
    if (oldWidget.modelPath != widget.modelPath && modelPlaced) {
      _reloadModel();
    }
    // Update color if changed
    else if (oldWidget.selectedColor != widget.selectedColor && modelPlaced) {
      _updateCarColor();
    }
  }

  Future<void> _reloadModel() async {
    if (carNode != null && arObjectManager != null) {
      // Remove the old node
      await arObjectManager!.removeNode(carNode!);
      carNode = null;
      modelPlaced = false;

      // Add new model
      await _addCarModel();
    }
  }

  void onARViewCreated(
    ARSessionManager arSessionManager,
    ARObjectManager arObjectManager,
    ARAnchorManager arAnchorManager,
    ARLocationManager arLocationManager,
  ) {
    this.arSessionManager = arSessionManager;
    this.arObjectManager = arObjectManager;
    this.arAnchorManager = arAnchorManager;

    this.arSessionManager!.onInitialize(
      showFeaturePoints: false,
      showPlanes: true,
      showWorldOrigin: false,
      handlePans: true,
      handleRotation: true,
    );

    this.arObjectManager!.onInitialize();

    // Add model after a short delay
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        _addCarModel();
      }
    });
  }

  Future<void> _addCarModel() async {
    if (arObjectManager == null) return;

    // Don't try to load if path is empty
    if (widget.modelPath.isEmpty) {
      print('No model path provided - waiting for user to select a model');
      return;
    }

    // Create a unique name for the node
    final nodeName = 'car_model_${DateTime.now().millisecondsSinceEpoch}';

    // Prepare the model path
    String modelUri = widget.modelPath;

    try {
      if (!widget.modelPath.startsWith('assets/')) {
        // Local file from device storage - use the full path directly
        print('Loading local file from: ${widget.modelPath}');

        // Verify file exists
        final sourceFile = File(widget.modelPath);
        if (!await sourceFile.exists()) {
          print('Source file does not exist: ${widget.modelPath}');
          return;
        }

        // Use the full path for local files
        modelUri = widget.modelPath;
        print('Using full path: $modelUri');
      }

      print('Loading model: $modelUri');

      // Create the AR node with the GLB model
      final newNode = ARNode(
        type: NodeType.fileSystemAppFolderGLB,
        uri: modelUri,
        scale: vector.Vector3(0.3, 0.3, 0.3),
        position: vector.Vector3(0.0, -0.5, -1.5),
        rotation: vector.Vector4(1.0, 0.0, 0.0, 0.0),
        name: nodeName,
      );

      bool? didAddNode = await arObjectManager!.addNode(newNode);

      if (didAddNode == true) {
        carNode = newNode;
        modelPlaced = true;
        print('Model loaded successfully!');

        if (mounted) {
          widget.onModelLoaded();
        }
      } else {
        print('Failed to add node to AR scene!');
      }
    } catch (e) {
      print('Error loading model: $e');
    }
  }

  Future<void> _updateCarColor() async {
    if (carNode != null && arObjectManager != null) {
      // Remove the old node
      await arObjectManager!.removeNode(carNode!);

      // Add a new node (color will be applied through the model's materials)
      await _addCarModel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ARView(
      onARViewCreated: onARViewCreated,
      planeDetectionConfig: PlaneDetectionConfig.horizontalAndVertical,
    );
  }
}
