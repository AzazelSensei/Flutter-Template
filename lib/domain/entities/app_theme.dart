import 'package:flutter/material.dart';

class AppTheme {
  final String id;
  final String name;
  final Color primary;
  final Color secondary;
  final List<Color> gradientColors;
  final Color bgDark;

  const AppTheme({
    required this.id,
    required this.name,
    required this.primary,
    required this.secondary,
    required this.gradientColors,
    required this.bgDark,
  });
  static const AppTheme netflixRed = AppTheme(
    id: 'netflix_red',
    name: 'Netflix Red',
    primary: Color(0xFFE50914),
    secondary: Color(0xFFB1030C),
    gradientColors: [Color(0xFF3F0306), Color(0xFF090909)],
    bgDark: Color(0xFF090909),
  );

  static const AppTheme oceanBlue = AppTheme(
    id: 'ocean_blue',
    name: 'Ocean Blue',
    primary: Color(0xFF0EA5E9),
    secondary: Color(0xFF0284C7),
    gradientColors: [Color(0xFF0C2438), Color(0xFF090909)],
    bgDark: Color(0xFF090909),
  );

  static const AppTheme purpleDream = AppTheme(
    id: 'purple_dream',
    name: 'Purple Dream',
    primary: Color(0xFFA855F7),
    secondary: Color(0xFF9333EA),
    gradientColors: [Color(0xFF2E1A47), Color(0xFF090909)],
    bgDark: Color(0xFF090909),
  );

  static const AppTheme forestGreen = AppTheme(
    id: 'forest_green',
    name: 'Forest Green',
    primary: Color(0xFF10B981),
    secondary: Color(0xFF059669),
    gradientColors: [Color(0xFF0F2E1F), Color(0xFF090909)],
    bgDark: Color(0xFF090909),
  );

  static const AppTheme sunsetOrange = AppTheme(
    id: 'sunset_orange',
    name: 'Sunset Orange',
    primary: Color(0xFFF97316),
    secondary: Color(0xFFEA580C),
    gradientColors: [Color(0xFF3F1A0C), Color(0xFF090909)],
    bgDark: Color(0xFF090909),
  );
  /*
   * 5 farklı tema seçeneği
   * Kullanıcı settings'den seçebilir
   */
  static const List<AppTheme> availableThemes = [
    netflixRed,
    oceanBlue,
    purpleDream,
    forestGreen,
    sunsetOrange,
  ];
  static AppTheme getThemeById(String id) {
    return availableThemes.firstWhere(
      (theme) => theme.id == id,
      orElse: () => netflixRed, // Fallback: Netflix Red
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'primary': primary.toARGB32(),
      'secondary': secondary.toARGB32(),
      'gradientColors': gradientColors.map((c) => c.toARGB32()).toList(),
      'bgDark': bgDark.toARGB32(),
    };
  }

  factory AppTheme.fromMap(Map<String, dynamic> map) {
    return AppTheme(
      id: map['id'] as String,
      name: map['name'] as String,
      primary: Color(map['primary'] as int),
      secondary: Color(map['secondary'] as int),
      gradientColors: (map['gradientColors'] as List)
          .map((c) => Color(c as int))
          .toList(),
      bgDark: Color(map['bgDark'] as int),
    );
  }
}
