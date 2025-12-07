import 'package:vector_math/vector_math_64.dart' as vector;

/// Model representing an AR node (3D object in AR space)
class ARNodeModel {
  final String modelPath;
  vector.Vector3 position;
  vector.Vector3 rotation;
  vector.Vector3 scale;
  String currentColor;

  ARNodeModel({
    required this.modelPath,
    vector.Vector3? position,
    vector.Vector3? rotation,
    vector.Vector3? scale,
    this.currentColor = 'red',
  }) : position = position ?? vector.Vector3(0, 0, -1.5),
       rotation = rotation ?? vector.Vector3(0, 0, 0),
       scale = scale ?? vector.Vector3(0.5, 0.5, 0.5);

  /// Reset the node to default position
  void reset() {
    position = vector.Vector3(0, 0, -1.5);
    rotation = vector.Vector3(0, 0, 0);
    scale = vector.Vector3(0.5, 0.5, 0.5);
  }

  /// Rotate the node on Y axis
  void rotateY(double angle) {
    rotation.y += angle;
  }

  /// Update scale uniformly
  void updateScale(double scaleFactor) {
    scale = vector.Vector3(scaleFactor, scaleFactor, scaleFactor);
  }

  /// Copy with method for immutability
  ARNodeModel copyWith({
    String? modelPath,
    vector.Vector3? position,
    vector.Vector3? rotation,
    vector.Vector3? scale,
    String? currentColor,
  }) {
    return ARNodeModel(
      modelPath: modelPath ?? this.modelPath,
      position: position ?? this.position,
      rotation: rotation ?? this.rotation,
      scale: scale ?? this.scale,
      currentColor: currentColor ?? this.currentColor,
    );
  }
}
