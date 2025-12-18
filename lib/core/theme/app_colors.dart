import 'package:flutter/material.dart';
import 'package:flutter_template/core/theme/theme_extensions.dart';

class AppColors {
  AppColors._(); // Bu sınıfın örneği alınamasın
  static Color primaryOf(BuildContext context) =>
      Theme.of(context).colorScheme.primary;
  static Color secondaryOf(BuildContext context) =>
      Theme.of(context).colorScheme.secondary;
  static Color bgDarkOf(BuildContext context) =>
      Theme.of(context).colorScheme.surface;
  static const Color primary = Color(0xFFE50914);
  static const Color primaryDark = Color(0xFF6F0B0B);
  static const Color secondary = Color(0xFF5549F6);
  static const Color success = Color(0xFF00C547);
  static const Color info = Color(0xFF004CEB);
  static const Color warning = Color(0xFFFBE616);
  static const Color error = Color(0xFFF37171);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color bgDark = Color(0xFF090909);
  static const Color bgDarkRed = Color(0xFF3F0306);
  static Color get white90 => white.withValues(alpha: 0.90);
  static Color get white80 => white.withValues(alpha: 0.80);
  static Color get white70 => white.withValues(alpha: 0.70);
  static Color get white60 => white.withValues(alpha: 0.60);
  static Color get white50 => white.withValues(alpha: 0.50);
  static Color get white40 => white.withValues(alpha: 0.40);
  static Color get white30 => white.withValues(alpha: 0.30);
  static Color get white20 => white.withValues(alpha: 0.20);
  static Color get white10 => white.withValues(alpha: 0.10);
  static Color get white5 => white.withValues(alpha: 0.05);
  static const LinearGradient bgGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [bgDarkRed, bgDark],
    stops: [0.2, 0.6],
  );
  static LinearGradient bgGradientOf(BuildContext context) {
    final theme = Theme.of(context);
    final gradientColors =
        (theme.extension<ThemeGradientColors>())?.gradientColors ??
        [bgDarkRed, bgDark];
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: gradientColors,
      stops: const [0.2, 0.6],
    );
  }

  static const LinearGradient popularCardGradient = LinearGradient(
    colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
  static const LinearGradient normalCardGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
  static const LinearGradient activeNavGradient = LinearGradient(
    colors: [primary, Color(0xFFB50A11)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
  static const RadialGradient redGlowGradient = RadialGradient(
    center: Alignment(0.0, 0.0),
    radius: 0.50,
    colors: [Color(0xFFFF1B1B), Color(0x008D0000)],
  );
}
