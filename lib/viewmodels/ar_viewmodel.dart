import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import '../models/ar_node_model.dart';
import '../models/car_color_model.dart';
import '../services/model_storage_service.dart';

/// ViewModel for managing AR state and business logic
class ARViewModel extends ChangeNotifier {
  final ModelStorageService _storageService = ModelStorageService();

  // State
  bool _isModelLoaded = false;
  bool _isLoading = true;
  String? _errorMessage;
  late ARNodeModel _arNode;
  CarColorModel _selectedColor = CarColorModel.availableColors[0];
  String? _selectedModelPath;
  String? _selectedModelName;
  List<SavedModel> _savedModels = [];

  // Getters
  bool get isModelLoaded => _isModelLoaded;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  ARNodeModel get arNode => _arNode;
  CarColorModel get selectedColor => _selectedColor;
  List<CarColorModel> get availableColors => CarColorModel.availableColors;
  String? get selectedModelPath => _selectedModelPath;
  String? get selectedModelName => _selectedModelName;
  bool get hasCustomModel => _selectedModelPath != null;
  List<SavedModel> get savedModels => _savedModels;

  ARViewModel() {
    // Start without a model - user must select one
    _arNode = ARNodeModel(
      modelPath: '', // Empty path - no default model
      currentColor: _selectedColor.name,
    );
    // Load saved models
    loadSavedModels();
  }

  /// Load all saved models from storage
  Future<void> loadSavedModels() async {
    try {
      _savedModels = await _storageService.getSavedModels();
      notifyListeners();
    } catch (e) {
      print('Error loading saved models: $e');
    }
  }

  /// Pick a 3D model file from device storage and save it locally
  Future<bool> pickModelFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        final filePath = result.files.single.path!;
        final fileName = result.files.single.name;

        // Check if file has a valid 3D model extension
        if (!_storageService.isValidModelFile(filePath)) {
          _errorMessage =
              'Please select a valid 3D model file (.glb, .gltf, or .obj)';
          notifyListeners();
          return false;
        }

        // Verify file exists
        final file = File(filePath);
        if (!await file.exists()) {
          _errorMessage = 'Selected file does not exist';
          notifyListeners();
          return false;
        }

        // Save model to app storage
        _isLoading = true;
        notifyListeners();

        final savedPath = await _storageService.saveModel(filePath);

        if (savedPath != null) {
          _selectedModelPath = savedPath;
          _selectedModelName = fileName;

          // Update AR node with new model
          _arNode = ARNodeModel(
            modelPath: savedPath,
            currentColor: _selectedColor.name,
          );

          // Reset loading state to allow re-initialization
          _isModelLoaded = false;

          // Reload saved models list
          await loadSavedModels();

          _isLoading = false;
          notifyListeners();
          return true;
        } else {
          _errorMessage = 'Failed to save model to app storage';
          _isLoading = false;
          notifyListeners();
          return false;
        }
      }
      return false;
    } catch (e) {
      _errorMessage = 'Failed to pick model file: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Select a saved model
  void selectSavedModel(SavedModel model) {
    _selectedModelPath = model.path;
    _selectedModelName = model.displayName;

    // Update AR node with saved model
    _arNode = ARNodeModel(
      modelPath: model.path,
      currentColor: _selectedColor.name,
    );

    // Reset loading state to allow re-initialization
    _isModelLoaded = false;
    notifyListeners();
  }

  /// Delete a saved model
  Future<bool> deleteSavedModel(SavedModel model) async {
    try {
      final success = await _storageService.deleteModel(model.path);
      if (success) {
        // If the deleted model was selected, clear selection
        if (_selectedModelPath == model.path) {
          useDefaultModel();
        }
        // Reload saved models list
        await loadSavedModels();
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = 'Failed to delete model: $e';
      notifyListeners();
      return false;
    }
  }

  /// Get total size of saved models
  Future<String> getTotalModelsSize() async {
    final size = await _storageService.getTotalModelsSize();
    return _storageService.formatFileSize(size);
  }

  /// Clear all saved models
  Future<bool> clearAllModels() async {
    try {
      final success = await _storageService.clearAllModels();
      if (success) {
        useDefaultModel();
        await loadSavedModels();
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = 'Failed to clear models: $e';
      notifyListeners();
      return false;
    }
  }

  /// Use default model (clear selection)
  void useDefaultModel() {
    _selectedModelPath = null;
    _selectedModelName = null;
    _arNode = ARNodeModel(modelPath: '', currentColor: _selectedColor.name);
    _isModelLoaded = false;
    notifyListeners();
  }

  /// Initialize the AR session
  Future<void> initializeAR() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Simulate loading time for AR initialization
      await Future.delayed(const Duration(milliseconds: 1500));

      _isModelLoaded = true;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to initialize AR: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Change the car color
  void changeCarColor(CarColorModel color) {
    _selectedColor = color;
    _arNode = _arNode.copyWith(currentColor: color.name);
    notifyListeners();
  }

  /// Reset the car position
  void resetCarPosition() {
    _arNode.reset();
    notifyListeners();
  }

  /// Rotate the car
  void rotateCar(double angle) {
    _arNode.rotateY(angle);
    notifyListeners();
  }

  /// Update car scale
  void updateCarScale(double scale) {
    _arNode.updateScale(scale);
    notifyListeners();
  }

  /// Dispose resources
  @override
  void dispose() {
    super.dispose();
  }
}
