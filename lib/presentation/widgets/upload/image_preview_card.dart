import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/theme/app_colors.dart';
import 'package:flutter_template/presentation/widgets/svg_icon.dart';

class ImagePreviewCard extends StatelessWidget {
  final File image;
  final VoidCallback onRemove;
  final double? size;
  final double? borderRadius;
  final Color? backgroundColor;
  final double? removeButtonSize;
  final String? removeIconAsset;

  const ImagePreviewCard({
    super.key,
    required this.image,
    required this.onRemove,
    this.size,
    this.borderRadius,
    this.backgroundColor,
    this.removeButtonSize,
    this.removeIconAsset,
  });

  @override
  Widget build(BuildContext context) {
    final cardSize = size ?? 176.w;
    final radius = borderRadius ?? 32.r;
    final buttonSize = removeButtonSize ?? 36.w;

    return Column(
      children: [
        Container(
          width: cardSize,
          height: cardSize,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: backgroundColor ?? AppColors.white5,
            borderRadius: BorderRadius.circular(radius),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(radius),
            child: Image.file(
              image,
              fit: BoxFit.fill,
              width: cardSize,
              height: cardSize,
            ),
          ),
        ),
        12.verticalSpace,
        GestureDetector(
          onTap: onRemove,
          child: Container(
            width: buttonSize,
            height: buttonSize,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: AppColors.black.withValues(alpha: 0.80),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.white.withValues(alpha: 0.50),
                width: 1.w,
              ),
            ),
            child: Center(
              child: SvgIcon(
                assetPath: removeIconAsset ?? 'assets/icons/X.svg',
                size: 13.52.w,
                color: AppColors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
