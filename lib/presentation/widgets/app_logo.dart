import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppLogo extends StatelessWidget {
  final double size;

  const AppLogo({
    super.key,
    this.size = 78,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/logo/Icon.svg',
      width: size.w,
      height: size.w,
      fit: BoxFit.contain,
    );
  }
}
