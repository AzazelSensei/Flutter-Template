import 'package:flutter/material.dart';

class ThemeGradientColors extends ThemeExtension<ThemeGradientColors> {
  final List<Color> gradientColors;

  const ThemeGradientColors({required this.gradientColors});

  @override
  ThemeExtension<ThemeGradientColors> copyWith({List<Color>? gradientColors}) {
    return ThemeGradientColors(
      gradientColors: gradientColors ?? this.gradientColors,
    );
  }

  @override
  ThemeExtension<ThemeGradientColors> lerp(
    ThemeExtension<ThemeGradientColors>? other,
    double t,
  ) {
    if (other is! ThemeGradientColors) {
      return this;
    }
    return ThemeGradientColors(gradientColors: gradientColors);
  }
}
