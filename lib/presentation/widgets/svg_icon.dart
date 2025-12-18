import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgIcon extends StatelessWidget {
  final String assetPath;
  final double? size;
  final Color? color;

  const SvgIcon({
    super.key,
    required this.assetPath,
    this.size = 24,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      assetPath,
      width: size,
      height: size,
      colorFilter: color != null
          ? ColorFilter.mode(color!, BlendMode.srcIn)
          : null,
    );
  }
}

class AppIcons {
  static const String mail = 'assets/icons/Mail.svg';
  static const String lock = 'assets/icons/Lock.svg';
  static const String user = 'assets/icons/User.svg';
  static const String see = 'assets/icons/See.svg';
  static const String hide = 'assets/icons/Hide.svg';
  static const String google = 'assets/icons/Google.svg';
  static const String facebook = 'assets/icons/Facebook.svg';
  static const String apple = 'assets/icons/Apple.svg';
  static const String home = 'assets/icons/Home.svg';
  static const String homeFill = 'assets/icons/Home-fill.svg';
  static const String profile = 'assets/icons/Profile.svg';
  static const String profileFill = 'assets/icons/Profile-fill.svg';
  static const String heart = 'assets/icons/Heart.svg';
  static const String heartFill = 'assets/icons/Heart-fill.svg';
  static const String plus = 'assets/icons/Plus.svg';
  static const String arrow = 'assets/icons/Arrow.svg';
  static const String gem = 'assets/icons/Gem.svg';
  static const String x = 'assets/icons/X.svg';
}
