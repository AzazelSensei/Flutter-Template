import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/theme/app_colors.dart';
import 'package:flutter_template/core/theme/app_typography.dart';

// ============================================================================
// TOKEN PACKAGE CARD DETAILED
// ============================================================================
/// Detaylı token paketi kartı
///
/// Figma'da coin option component olarak tanımlanmış.
/// Limited offer bottom sheet'te kullanılır.
class TokenPackageCardDetailed extends StatelessWidget {
  final String originalTokens;
  final String bonusTokens;
  final String price;
  final String badgeText;
  final List<Color> gradientColors;
  final Color badgeColor;
  final bool hasInnerShadow;

  const TokenPackageCardDetailed({
    super.key,
    required this.originalTokens,
    required this.bonusTokens,
    required this.price,
    required this.badgeText,
    required this.gradientColors,
    required this.badgeColor,
    this.hasInnerShadow = false,
  });

  @override
  Widget build(BuildContext context) {
    if (hasInnerShadow) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: const Alignment(0.26, 0.15),
              radius: 1.50,
              colors: gradientColors,
            ),
            border: Border.all(
              width: 1.w,
              color: AppColors.white.withValues(alpha: 0.40),
            ),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Inner shadow overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: const Alignment(0, 0),
                      radius: 0.7,
                      colors: [
                        Colors.transparent,
                        Colors.transparent,
                        AppColors.white.withValues(alpha: 0.8),
                        AppColors.white.withValues(alpha: 1),
                      ],
                      stops: const [0.0, 0.3, 0.95, 1.0],
                    ),
                  ),
                ),
              ),
              // Content
              Padding(
                padding: EdgeInsets.only(left: 8.w, right: 8.w, bottom: 12.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    16.verticalSpace,
                    _TokenAmounts(
                      originalTokens: originalTokens,
                      bonusTokens: bonusTokens,
                    ),
                    14.verticalSpace,
                    Divider(height: 1.h, color: AppColors.white10),
                    14.verticalSpace,
                    _PriceInfo(price: price),
                  ],
                ),
              ),
              // Badge
              Positioned(
                left: 18.w,
                top: -10.h,
                child: _TokenBadge(text: badgeText, backgroundColor: badgeColor),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.only(left: 8.w, right: 8.w, bottom: 12.h),
      decoration: ShapeDecoration(
        gradient: RadialGradient(
          center: const Alignment(0.26, 0.15),
          radius: 1.50,
          colors: gradientColors,
        ),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1.w,
            color: AppColors.white.withValues(alpha: 0.40),
          ),
          borderRadius: BorderRadius.circular(16.r),
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              16.verticalSpace,
              _TokenAmounts(
                originalTokens: originalTokens,
                bonusTokens: bonusTokens,
              ),
              14.verticalSpace,
              Divider(height: 1.h, color: AppColors.white10),
              14.verticalSpace,
              _PriceInfo(price: price),
            ],
          ),
          Positioned(
            left: 18.w,
            top: -10.h,
            child: _TokenBadge(text: badgeText, backgroundColor: badgeColor),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// TOKEN AMOUNTS
// ============================================================================
class _TokenAmounts extends StatelessWidget {
  final String originalTokens;
  final String bonusTokens;

  const _TokenAmounts({
    required this.originalTokens,
    required this.bonusTokens,
  });

  @override
  Widget build(BuildContext context) {
    final bool isLarge = originalTokens.contains('2.000');

    return Column(
      children: [
        Text(
          originalTokens,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.white90,
            fontSize: isLarge ? 16.sp : 15.sp,
            fontFamily: isLarge ? 'Instrument Sans' : 'Euclid Circular A',
            fontWeight: FontWeight.w500,
            decoration: TextDecoration.lineThrough,
            decorationColor: AppColors.white90,
          ),
        ),
        Text(
          bonusTokens,
          textAlign: TextAlign.center,
          style: AppTypography.heading5.copyWith(
            color: AppColors.white,
            fontSize: 28.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          'Jeton',
          style: AppTypography.bodySmallMedium.copyWith(color: AppColors.white),
        ),
      ],
    );
  }
}

// ============================================================================
// PRICE INFO
// ============================================================================
class _PriceInfo extends StatelessWidget {
  final String price;

  const _PriceInfo({required this.price});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          price,
          textAlign: TextAlign.center,
          style: AppTypography.bodyNormalSemibold.copyWith(
            color: AppColors.white,
          ),
        ),
        Text(
          'Başına haftalık',
          style: AppTypography.bodyXSmallMedium.copyWith(
            color: AppColors.white80,
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// TOKEN BADGE
// ============================================================================
class _TokenBadge extends StatelessWidget {
  final String text;
  final Color backgroundColor;

  const _TokenBadge({required this.text, required this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 61.w,
      height: 23.h,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: AppColors.white.withValues(alpha: 0.3),
          width: 1.5.w,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.white.withValues(alpha: 0.4),
            blurRadius: 8,
            spreadRadius: -2,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: CustomPaint(
        painter: _InnerShadowPainter(
          shadowColor: AppColors.white.withValues(alpha: 0.9),
          blurRadius: 6.0,
          borderRadius: 24.r,
        ),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: AppTypography.bodyXSmallRegular.copyWith(
              color: AppColors.white,
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// INNER SHADOW PAINTER
// ============================================================================
class _InnerShadowPainter extends CustomPainter {
  final Color shadowColor;
  final double blurRadius;
  final double borderRadius;

  _InnerShadowPainter({
    required this.shadowColor,
    required this.blurRadius,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = RRect.fromRectAndRadius(
      rect,
      Radius.circular(borderRadius),
    );

    final paint = Paint()
      ..color = Colors.transparent
      ..style = PaintingStyle.fill;

    canvas.saveLayer(rect, paint);

    canvas.drawRRect(rrect, paint);

    final shadowPaint = Paint()
      ..color = shadowColor
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, blurRadius);

    final shadowRect = rect.deflate(2);
    final shadowRRect = RRect.fromRectAndRadius(
      shadowRect,
      Radius.circular(borderRadius - 2),
    );

    canvas.drawRRect(shadowRRect, shadowPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(_InnerShadowPainter oldDelegate) {
    return oldDelegate.shadowColor != shadowColor ||
        oldDelegate.blurRadius != blurRadius ||
        oldDelegate.borderRadius != borderRadius;
  }
}
