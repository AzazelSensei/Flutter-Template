import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/theme/app_colors.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(gradient: AppColors.bgGradientOf(context)),
      child: Stack(
        children: [
          Positioned(
            left: 43.w,
            top: -71.h,
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 50.6, sigmaY: 50.6),
                child: Container(
                  width: 310.w,
                  height: 208.h,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: const Alignment(0.0, 0.0),
                      radius: 0.50,
                      colors: [
                        primaryColor.withValues(alpha: 0.8),
                        primaryColor.withValues(alpha: 0.0),
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}
