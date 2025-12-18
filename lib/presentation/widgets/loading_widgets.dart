import 'package:flutter/material.dart';
import 'package:flutter_template/core/theme/app_colors.dart';
import 'package:flutter_template/core/theme/app_spacing.dart';
import 'package:flutter_template/core/theme/app_typography.dart';
import 'package:flutter_template/core/theme/theme_extensions.dart';

// ============================================================================
// LOADING WIDGETS - COMMON COMPONENTS
// ============================================================================
/// Uygulama genelinde kullanılabilecek loading widget'ları
///
/// Kullanım örnekleri:
/// - LoadingIndicator() - Sadece indicator
/// - LoadingPage() - Scaffold içinde tam sayfa loading
/// - GradientLoadingPage() - Gradient background ile loading
/// - LoadingOverlay() - Mevcut içerik üzerine overlay

// ============================================================================
// 1. LOADING INDICATOR (Base Component)
// ============================================================================
/// En basit loading indicator - her yerde kullanılabilir
class LoadingIndicator extends StatelessWidget {
  final Color? color;
  final double? size;
  final double? strokeWidth;

  const LoadingIndicator({
    super.key,
    this.color,
    this.size,
    this.strokeWidth,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        color: color ?? AppColors.primaryOf(context),
        strokeWidth: strokeWidth ?? AppSpacing.xs,
      ),
    );
  }
}

// ============================================================================
// 2. LOADING PAGE (Full Page - Simple)
// ============================================================================
/// Basit loading sayfası - Scaffold wrapper ile
/// ProfilePage, AuthCheckPage gibi basit sayfalar için
class LoadingPage extends StatelessWidget {
  final Color? backgroundColor;
  final Color? indicatorColor;
  final String? message;

  const LoadingPage({
    super.key,
    this.backgroundColor,
    this.indicatorColor,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? AppColors.bgDark,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LoadingIndicator(color: indicatorColor),
            if (message != null) ...[
              SizedBox(height: AppSpacing.lg),
              Text(
                message!,
                style: AppTypography.bodyNormalRegular.copyWith(
                  color: AppColors.white80,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// 3. GRADIENT LOADING PAGE (Full Page - Gradient Background)
// ============================================================================
/// Gradient arkaplan ile loading sayfası
/// HomePage gibi gradient kullanan sayfalar için
class GradientLoadingPage extends StatelessWidget {
  final List<Color>? gradientColors;
  final AlignmentGeometry? gradientBegin;
  final AlignmentGeometry? gradientEnd;
  final Color? indicatorColor;
  final String? message;

  const GradientLoadingPage({
    super.key,
    this.gradientColors,
    this.gradientBegin,
    this.gradientEnd,
    this.indicatorColor,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    // Theme'den gradient renklerini al, yoksa fallback kullan
    final colors = gradientColors ??
        Theme.of(context).extension<ThemeGradientColors>()?.gradientColors ??
        [AppColors.bgDark, const Color(0xFF3E0205)];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: gradientBegin ?? const Alignment(0.5, 0.0),
          end: gradientEnd ?? const Alignment(0.5, 1.0),
          colors: colors,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LoadingIndicator(color: indicatorColor),
            if (message != null) ...[
              SizedBox(height: AppSpacing.lg),
              Text(
                message!,
                style: AppTypography.bodyNormalRegular.copyWith(
                  color: AppColors.white80,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// 4. LOADING OVERLAY (Overlay Component)
// ============================================================================
/// Mevcut içerik üzerine yarı saydam loading overlay
/// Form submission, data refresh gibi durumlarda kullanılır
class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final Color? overlayColor;
  final Color? indicatorColor;
  final String? message;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.overlayColor,
    this.indicatorColor,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Positioned.fill(
            child: Container(
              color: overlayColor ?? Colors.black.withValues(alpha: 0.5),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LoadingIndicator(color: indicatorColor),
                    if (message != null) ...[
                      SizedBox(height: AppSpacing.lg),
                      Text(
                        message!,
                        style: AppTypography.bodyNormalMedium.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// ============================================================================
// 5. INLINE LOADING (Küçük alanlar için)
// ============================================================================
/// Liste item'ları, button'lar içinde kullanılabilecek küçük loading
class InlineLoading extends StatelessWidget {
  final Color? color;
  final double size;
  final String? message;

  InlineLoading({
    super.key,
    this.color,
    double? size,
    this.message,
  }) : size = size ?? AppSpacing.lg;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            color: color ?? AppColors.primaryOf(context),
            strokeWidth: 2,
          ),
        ),
        if (message != null) ...[
          SizedBox(width: AppSpacing.sm),
          Text(
            message!,
            style: AppTypography.bodySmallRegular.copyWith(
              color: color ?? AppColors.primaryOf(context),
            ),
          ),
        ],
      ],
    );
  }
}
