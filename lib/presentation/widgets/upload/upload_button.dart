import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/theme/app_colors.dart';
import 'package:flutter_template/presentation/widgets/svg_icon.dart';

class UploadButton extends StatelessWidget {
  final VoidCallback onTap;
  final double? size;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? iconColor;
  final double? iconSize;
  final double? borderRadius;
  final String? iconAsset;

  const UploadButton({
    super.key,
    required this.onTap,
    this.size,
    this.backgroundColor,
    this.borderColor,
    this.iconColor,
    this.iconSize,
    this.borderRadius,
    this.iconAsset,
  });

  @override
  Widget build(BuildContext context) {
    final buttonSize = size ?? 176.w;
    final radius = borderRadius ?? 32.r;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: buttonSize,
        height: buttonSize,
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.white5,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: DottedBorder(
          borderType: BorderType.RRect,
          radius: Radius.circular(radius - 1.r),
          dashPattern: const [5, 4],
          color: borderColor ?? AppColors.white20,
          strokeWidth: 1.w,
          child: Center(
            child: SvgIcon(
              assetPath: iconAsset ?? 'assets/icons/Plus.svg',
              size: iconSize ?? 32.w,
              color: iconColor ?? AppColors.white,
            ),
          ),
        ),
      ),
    );
  }
}
