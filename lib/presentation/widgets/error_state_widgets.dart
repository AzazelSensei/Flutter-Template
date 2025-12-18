import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/extensions/context_extensions.dart';
import 'package:flutter_template/core/theme/app_colors.dart';
import 'package:flutter_template/core/theme/app_spacing.dart';
import 'package:flutter_template/core/theme/app_typography.dart';
import 'package:flutter_template/core/theme/theme_extensions.dart';

// ============================================================================
// ERROR & EMPTY STATE WIDGETS - COMMON COMPONENTS
// ============================================================================
/// Uygulama genelinde kullanılabilecek error ve empty state widget'ları
///
/// ERROR STATE Kullanım örnekleri:
/// - ErrorStateView() - Basit error state (icon + mesaj)
/// - ErrorStateWithRetry() - Retry butonu ile error state
/// - GradientErrorState() - Gradient background ile error state
/// - ErrorStateOverlay() - Mevcut içerik üzerine overlay
///
/// EMPTY STATE Kullanım örnekleri:
/// - EmptyStateView() - Basit empty state (icon + mesaj)
/// - GradientEmptyState() - Gradient background ile empty state
/// - SliverEmptyState() - Sliver için empty state

// ============================================================================
// 1. ERROR STATE VIEW (Base Component)
// ============================================================================
/// En basit error state component - icon ve mesaj
class ErrorStateView extends StatelessWidget {
  final String? message;
  final IconData? icon;
  final Color? iconColor;
  final Color? textColor;
  final double? iconSize;

  const ErrorStateView({
    super.key,
    this.message,
    this.icon,
    this.iconColor,
    this.textColor,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon ?? Icons.error_outline,
            color: iconColor ?? AppColors.white60,
            size: iconSize ?? 48.w,
          ),
          16.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Text(
              message ?? context.l10n.errorOccurred,
              style: AppTypography.bodyNormalRegular.copyWith(
                color: textColor ?? AppColors.white80,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// 2. ERROR STATE WITH RETRY (Interactive Component)
// ============================================================================
/// Retry butonu içeren error state
/// HomePage, ProfilePage gibi refresh edilebilir sayfalar için
class ErrorStateWithRetry extends StatelessWidget {
  final String? message;
  final VoidCallback? onRetry;
  final String? retryButtonText;
  final IconData? icon;
  final Color? iconColor;
  final Color? textColor;
  final double? iconSize;

  const ErrorStateWithRetry({
    super.key,
    this.message,
    this.onRetry,
    this.retryButtonText,
    this.icon,
    this.iconColor,
    this.textColor,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon ?? Icons.error_outline,
            color: iconColor ?? AppColors.white60,
            size: iconSize ?? 48.w,
          ),
          16.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Text(
              message ?? context.l10n.errorOccurred,
              style: AppTypography.bodyNormalRegular.copyWith(
                color: textColor ?? AppColors.white80,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          if (onRetry != null) ...[
            16.verticalSpace,
            TextButton(
              onPressed: onRetry,
              child: Text(
                retryButtonText ?? context.l10n.retry,
                style: AppTypography.bodyNormalSemibold.copyWith(
                  color: AppColors.primaryOf(context),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ============================================================================
// 3. GRADIENT ERROR STATE (Full Page - Gradient Background)
// ============================================================================
/// Gradient arkaplan ile error state
/// HomePage gibi gradient kullanan sayfalar için
class GradientErrorState extends StatelessWidget {
  final String? message;
  final VoidCallback? onRetry;
  final String? retryButtonText;
  final List<Color>? gradientColors;
  final AlignmentGeometry? gradientBegin;
  final AlignmentGeometry? gradientEnd;
  final IconData? icon;
  final Color? iconColor;
  final Color? textColor;
  final double? iconSize;

  const GradientErrorState({
    super.key,
    this.message,
    this.onRetry,
    this.retryButtonText,
    this.gradientColors,
    this.gradientBegin,
    this.gradientEnd,
    this.icon,
    this.iconColor,
    this.textColor,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    final colors = gradientColors ??
        Theme.of(context).extension<ThemeGradientColors>()?.gradientColors ??
        [AppColors.bgDark, const Color(0xFF3E0205)];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: gradientBegin ?? const Alignment(0.5, 1.0),
          end: gradientEnd ?? const Alignment(0.5, 0.0),
          colors: colors,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon ?? Icons.error_outline,
              color: iconColor ?? AppColors.white60,
              size: iconSize ?? 48.w,
            ),
            16.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Text(
                message ?? context.l10n.errorOccurred,
                style: AppTypography.bodyNormalRegular.copyWith(
                  color: textColor ?? AppColors.white80,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            if (onRetry != null) ...[
              16.verticalSpace,
              TextButton(
                onPressed: onRetry,
                child: Text(
                  retryButtonText ?? context.l10n.retry,
                  style: AppTypography.bodyNormalSemibold.copyWith(
                    color: AppColors.primaryOf(context),
                  ),
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
// 4. ERROR STATE OVERLAY (Overlay Component)
// ============================================================================
/// Mevcut içerik üzerine yarı saydam error overlay
/// Modal veya partial error gösterimleri için
class ErrorStateOverlay extends StatelessWidget {
  final bool showError;
  final Widget child;
  final String? message;
  final VoidCallback? onRetry;
  final VoidCallback? onDismiss;
  final Color? overlayColor;
  final Color? iconColor;
  final Color? textColor;

  const ErrorStateOverlay({
    super.key,
    required this.showError,
    required this.child,
    this.message,
    this.onRetry,
    this.onDismiss,
    this.overlayColor,
    this.iconColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (showError)
          Positioned.fill(
            child: Container(
              color: overlayColor ?? Colors.black.withValues(alpha: 0.8),
              child: Center(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 24.w),
                  padding: EdgeInsets.all(24.w),
                  decoration: BoxDecoration(
                    color: AppColors.bgDark,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: iconColor ?? AppColors.white60,
                        size: 48.w,
                      ),
                      16.verticalSpace,
                      Text(
                        message ?? context.l10n.errorOccurred,
                        style: AppTypography.bodyNormalRegular.copyWith(
                          color: textColor ?? AppColors.white80,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (onRetry != null || onDismiss != null) ...[
                        24.verticalSpace,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (onDismiss != null)
                              TextButton(
                                onPressed: onDismiss,
                                child: Text(
                                  context.l10n.close,
                                  style: AppTypography.bodyNormalMedium.copyWith(
                                    color: AppColors.white60,
                                  ),
                                ),
                              ),
                            if (onRetry != null && onDismiss != null) 16.horizontalSpace,
                            if (onRetry != null)
                              TextButton(
                                onPressed: onRetry,
                                child: Text(
                                  context.l10n.retry,
                                  style: AppTypography.bodyNormalSemibold.copyWith(
                                    color: AppColors.primaryOf(context),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// ============================================================================
// 5. INLINE ERROR (Küçük alanlar için)
// ============================================================================
/// Liste item'ları, card'lar içinde kullanılabilecek küçük error
class InlineError extends StatelessWidget {
  final String? message;
  final Color? color;
  final double? iconSize;

  const InlineError({
    super.key,
    this.message,
    this.color,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.error_outline,
          color: color ?? AppColors.error,
          size: iconSize ?? 16.w,
        ),
        SizedBox(width: AppSpacing.sm),
        Flexible(
          child: Text(
            message ?? context.l10n.errorOccurred,
            style: AppTypography.bodySmallRegular.copyWith(
              color: color ?? AppColors.error,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// 6. EMPTY STATE VIEW (Base Component)
// ============================================================================
/// En basit empty state component - icon ve mesaj
class EmptyStateView extends StatelessWidget {
  final String? message;
  final IconData? icon;
  final Color? iconColor;
  final Color? textColor;
  final double? iconSize;

  const EmptyStateView({
    super.key,
    this.message,
    this.icon,
    this.iconColor,
    this.textColor,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon ?? Icons.inbox_outlined,
            color: iconColor ?? AppColors.white60,
            size: iconSize ?? 48.w,
          ),
          16.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Text(
              message ?? context.l10n.noContentYet,
              style: AppTypography.bodyNormalRegular.copyWith(
                color: textColor ?? AppColors.white80,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// 7. GRADIENT EMPTY STATE (Full Page - Gradient Background)
// ============================================================================
/// Gradient arkaplan ile empty state
/// HomePage gibi gradient kullanan sayfalar için
class GradientEmptyState extends StatelessWidget {
  final String? message;
  final List<Color>? gradientColors;
  final AlignmentGeometry? gradientBegin;
  final AlignmentGeometry? gradientEnd;
  final IconData? icon;
  final Color? iconColor;
  final Color? textColor;
  final double? iconSize;

  const GradientEmptyState({
    super.key,
    this.message,
    this.gradientColors,
    this.gradientBegin,
    this.gradientEnd,
    this.icon,
    this.iconColor,
    this.textColor,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
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
            Icon(
              icon ?? Icons.inbox_outlined,
              color: iconColor ?? AppColors.white60,
              size: iconSize ?? 48.w,
            ),
            16.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Text(
                message ?? context.l10n.noContentYet,
                style: AppTypography.bodyNormalRegular.copyWith(
                  color: textColor ?? AppColors.white80,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// 8. SLIVER EMPTY STATE (For ScrollView/CustomScrollView)
// ============================================================================
/// CustomScrollView içinde kullanılabilecek empty state
/// ProfilePage favorites gibi sliver widget'lar için
class SliverEmptyState extends StatelessWidget {
  final String? message;
  final IconData? icon;
  final Color? iconColor;
  final Color? textColor;
  final double? iconSize;
  final EdgeInsetsGeometry? padding;

  const SliverEmptyState({
    super.key,
    this.message,
    this.icon,
    this.iconColor,
    this.textColor,
    this.iconSize,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: padding ?? EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
        child: Center(
          child: Column(
            children: [
              Icon(
                icon ?? Icons.inbox_outlined,
                color: iconColor ?? AppColors.white40,
                size: iconSize ?? 48.w,
              ),
              16.verticalSpace,
              Text(
                message ?? context.l10n.noContentYet,
                style: AppTypography.bodyNormalRegular.copyWith(
                  color: textColor ?? AppColors.white60,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
