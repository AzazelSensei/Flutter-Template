import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/theme/app_colors.dart';
import 'package:flutter_template/presentation/widgets/svg_icon.dart';

// ============================================================================
// APP BAR BACK BUTTON
// ============================================================================
/// Uygulamanın standart geri butonu
///
/// AppBar, modal ve dialog'larda kullanılabilir.
/// Özelleştirilebilir background, border ve icon renkleri.
///
/// Örnek kullanım:
/// ```dart
/// AppBarBackButton(
///   onPressed: () => Navigator.pop(context),
/// )
/// ```
class AppBarBackButton extends StatelessWidget {
  /// Butona basıldığında çalışacak fonksiyon
  final VoidCallback? onPressed;

  /// Container background rengi
  final Color? backgroundColor;

  /// Border rengi
  final Color? borderColor;

  /// Icon rengi
  final Color? iconColor;

  /// Icon asset path (varsayılan: 'assets/icons/Arrow.svg')
  final String? iconAsset;

  /// Buton boyutu
  final double? size;

  /// Border radius
  final double? borderRadius;

  const AppBarBackButton({
    super.key,
    this.onPressed,
    this.backgroundColor,
    this.borderColor,
    this.iconColor,
    this.iconAsset,
    this.size,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final buttonSize = size ?? 44.w;
    final radius = borderRadius ?? 16.r;

    return GestureDetector(
      onTap: onPressed ?? () => Navigator.pop(context),
      child: Container(
        width: buttonSize,
        height: buttonSize,
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.white5,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(
            color: borderColor ?? AppColors.white20,
            width: 1.w,
          ),
        ),
        child: Center(
          child: SvgIcon(
            assetPath: iconAsset ?? 'assets/icons/Arrow.svg',
            size: 24.w,
            color: iconColor ?? AppColors.white,
          ),
        ),
      ),
    );
  }
}
