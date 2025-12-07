import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

/// Service for managing local storage of 3D models
class ModelStorageService {
  static const String _modelsFolder = 'saved_models';

  /// Get the directory where models are stored
  Future<Directory> getModelsDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final modelsDir = Directory(p.join(appDir.path, _modelsFolder));

    if (!await modelsDir.exists()) {
      await modelsDir.create(recursive: true);
    }

    return modelsDir;
  }

  /// Save a model file to local storage
  /// Returns the new path where the model is saved
  Future<String?> saveModel(String sourcePath) async {
    try {
      final sourceFile = File(sourcePath);

      // Check if source file exists
      if (!await sourceFile.exists()) {
        print('Source file does not exist: $sourcePath');
        return null;
      }

      // Get models directory
      final modelsDir = await getModelsDirectory();

      // Generate unique filename with timestamp
      final fileName = p.basename(sourcePath);
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final extension = p.extension(fileName);
      final nameWithoutExt = p.basenameWithoutExtension(fileName);
      final newFileName = '${nameWithoutExt}_$timestamp$extension';

      // Create destination path
      final destinationPath = p.join(modelsDir.path, newFileName);

      // Copy file to app storage
      await sourceFile.copy(destinationPath);

      print('Model saved successfully to: $destinationPath');
      return destinationPath;
    } catch (e) {
      print('Error saving model: $e');
      return null;
    }
  }

  /// Get all saved models
  Future<List<SavedModel>> getSavedModels() async {
    try {
      final modelsDir = await getModelsDirectory();
      final files = await modelsDir.list().toList();

      final models = <SavedModel>[];
      for (var file in files) {
        if (file is File) {
          final fileName = p.basename(file.path);
          final stats = await file.stat();

          models.add(
            SavedModel(
              name: fileName,
              path: file.path,
              size: stats.size,
              dateAdded: stats.modified,
            ),
          );
        }
      }

      // Sort by date (newest first)
      models.sort((a, b) => b.dateAdded.compareTo(a.dateAdded));

      return models;
    } catch (e) {
      print('Error getting saved models: $e');
      return [];
    }
  }

  /// Delete a saved model
  Future<bool> deleteModel(String modelPath) async {
    try {
      final file = File(modelPath);
      if (await file.exists()) {
        await file.delete();
        print('Model deleted: $modelPath');
        return true;
      }
      return false;
    } catch (e) {
      print('Error deleting model: $e');
      return false;
    }
  }

  /// Get total size of all saved models
  Future<int> getTotalModelsSize() async {
    try {
      final models = await getSavedModels();
      return models.fold<int>(0, (sum, model) => sum + model.size);
    } catch (e) {
      print('Error calculating total size: $e');
      return 0;
    }
  }

  /// Clear all saved models
  Future<bool> clearAllModels() async {
    try {
      final modelsDir = await getModelsDirectory();
      if (await modelsDir.exists()) {
        await modelsDir.delete(recursive: true);
        await modelsDir.create();
        print('All models cleared');
        return true;
      }
      return false;
    } catch (e) {
      print('Error clearing models: $e');
      return false;
    }
  }

  /// Check if a file is a valid 3D model
  bool isValidModelFile(String filePath) {
    final validExtensions = ['.glb', '.gltf', '.obj'];
    final extension = p.extension(filePath).toLowerCase();
    return validExtensions.contains(extension);
  }

  /// Format file size to human readable string
  String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}

/// Model class representing a saved 3D model
class SavedModel {
  final String name;
  final String path;
  final int size;
  final DateTime dateAdded;

  SavedModel({
    required this.name,
    required this.path,
    required this.size,
    required this.dateAdded,
  });

  String get displayName {
    // Remove timestamp from name for display
    final nameWithoutExt = p.basenameWithoutExtension(name);
    final parts = nameWithoutExt.split('_');
    if (parts.length > 1) {
      // Remove last part (timestamp)
      parts.removeLast();
      return parts.join('_');
    }
    return nameWithoutExt;
  }

  String get extension {
    return p.extension(name).toLowerCase();
  }
}
