import 'package:flutter/material.dart';

/// Model representing a car color option
class CarColorModel {
  final String name;
  final Color color;
  final String displayName;

  const CarColorModel({
    required this.name,
    required this.color,
    required this.displayName,
  });

  /// Predefined car colors
  static const List<CarColorModel> availableColors = [
    // Classic Colors
    CarColorModel(
      name: 'red',
      color: Color(0xFFDC143C),
      displayName: 'أحمر قرمزي',
    ),
    CarColorModel(
      name: 'black',
      color: Color(0xFF1C1C1C),
      displayName: 'أسود داكن',
    ),
    CarColorModel(
      name: 'white',
      color: Color(0xFFF5F5F5),
      displayName: 'أبيض لؤلؤي',
    ),
    CarColorModel(
      name: 'blue',
      color: Color(0xFF1E3A8A),
      displayName: 'أزرق محيطي',
    ),
    CarColorModel(
      name: 'silver',
      color: Color(0xFFC0C0C0),
      displayName: 'فضي معدني',
    ),

    // Vibrant Colors
    CarColorModel(
      name: 'orange',
      color: Color(0xFFFF6B35),
      displayName: 'برتقالي ناري',
    ),
    CarColorModel(
      name: 'yellow',
      color: Color(0xFFFFC300),
      displayName: 'أصفر ذهبي',
    ),
    CarColorModel(
      name: 'green',
      color: Color(0xFF2D6A4F),
      displayName: 'أخضر زمردي',
    ),
    CarColorModel(
      name: 'purple',
      color: Color(0xFF6A0572),
      displayName: 'بنفسجي ملكي',
    ),

    // Metallic & Special Colors
    CarColorModel(
      name: 'gold',
      color: Color(0xFFD4AF37),
      displayName: 'ذهبي لامع',
    ),
    CarColorModel(
      name: 'bronze',
      color: Color(0xFFCD7F32),
      displayName: 'برونزي',
    ),
    CarColorModel(
      name: 'navy',
      color: Color(0xFF000080),
      displayName: 'أزرق كحلي',
    ),
    CarColorModel(
      name: 'maroon',
      color: Color(0xFF800000),
      displayName: 'عنابي',
    ),
    CarColorModel(
      name: 'teal',
      color: Color(0xFF008080),
      displayName: 'أزرق مخضر',
    ),
    CarColorModel(
      name: 'pink',
      color: Color(0xFFFF1493),
      displayName: 'وردي فاتح',
    ),
  ];
}
