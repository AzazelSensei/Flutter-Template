import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/extensions/context_extensions.dart';
import 'package:flutter_template/core/theme/app_colors.dart';
import 'package:flutter_template/core/theme/app_typography.dart';
import 'package:flutter_template/presentation/widgets/token_package_card_detailed.dart';

// ============================================================================
// MAIN BOTTOM SHEET
// ============================================================================
class LimitedOfferBottomSheet extends StatelessWidget {
  const LimitedOfferBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(32.r),
        topRight: Radius.circular(32.r),
      ),
      child: IntrinsicHeight(
        child: Container(
          decoration: BoxDecoration(
            gradient: AppColors.bgGradientOf(context),
          ),
          child: Stack(
            fit: StackFit.passthrough,
            children: [
              const _BackgroundGlows(),

              SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 32.h,
                    right: 24.w,
                    bottom: 0,
                    left: 24.w,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const _HeaderSection(),
                      24.verticalSpace,
                      const _BonusesSection(),
                      24.verticalSpace,
                      const _TokenPackagesSection(),
                      24.verticalSpace,
                      const _CTAButton(),
                    ],
                  ),
                ),
              ),

              // Close button
              const _CloseButton(),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// BACKGROUND GLOWS
// ============================================================================
class _BackgroundGlows extends StatelessWidget {
  const _BackgroundGlows();

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Stack(
      children: [
        Positioned(
          left: 0,
          right: 0,
          top: -65.8.h,
          child: Center(
            child: Container(
              width: 310.w,
              height: 208.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: primaryColor,
                    blurRadius: 50.6,
                    spreadRadius: 0,
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: -65.8.h,
          child: Center(
            child: Container(
              width: 217.394.w,
              height: 217.394.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withValues(alpha: 0.6),
                    blurRadius: 125,
                    spreadRadius: 0,
                  ),
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
// HEADER SECTION
// ============================================================================
class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          context.l10n.limitedOffer,
          textAlign: TextAlign.center,
          style: AppTypography.heading4.copyWith(color: AppColors.white),
        ),
        8.verticalSpace,
        SizedBox(
          width: 298.w,
          child: Text(
            context.l10n.limitedOfferDescription,
            textAlign: TextAlign.center,
            style: AppTypography.bodyNormalRegular.copyWith(
              color: AppColors.white90,
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// BONUSES SECTION
// ============================================================================
class _BonusesSection extends StatelessWidget {
  const _BonusesSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: ShapeDecoration(
        gradient: RadialGradient(
          center: const Alignment(0.55, 0.50),
          radius: 1.73,
          colors: [AppColors.white10, AppColors.white.withValues(alpha: 0.03)],
        ),
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1.w, color: AppColors.white20),
          borderRadius: BorderRadius.circular(24.r),
        ),
      ),
      child: Column(
        children: [
          Text(
            context.l10n.yourBonuses,
            style: AppTypography.bodyLargeMedium.copyWith(
              color: AppColors.white,
            ),
          ),
          14.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: _BonusItem(
                  label: context.l10n.premiumAccount,
                  assetPath: 'assets/limited_offer/1.png',
                ),
              ),
              Expanded(
                child: _BonusItem(
                  label: context.l10n.moreMatches,
                  assetPath: 'assets/limited_offer/2.png',
                ),
              ),
              Expanded(
                child: _BonusItem(
                  label: context.l10n.spotlight,
                  assetPath: 'assets/limited_offer/3.png',
                ),
              ),
              Expanded(
                child: _BonusItem(
                  label: context.l10n.moreLikes,
                  assetPath: 'assets/limited_offer/4.png',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// BONUS ITEM
// ============================================================================
class _BonusItem extends StatelessWidget {
  final String label;
  final String assetPath;

  const _BonusItem({required this.label, required this.assetPath});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final darkerPrimary = Color.lerp(primaryColor, Colors.black, 0.5) ?? primaryColor;

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(27.5.r),
          child: Container(
            width: 56.w,
            height: 56.h,
            decoration: BoxDecoration(
              color: darkerPrimary,
            ),
            child: Stack(
              children: [
                // Inner shadow overlay - from edges to center
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
                // Icon
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(8.w),
                    child: Image.asset(assetPath, fit: BoxFit.contain),
                  ),
                ),
              ],
            ),
          ),
        ),
        12.verticalSpace,
        SizedBox(
          width: 80.5.w,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: AppTypography.bodySmallRegular.copyWith(
              color: AppColors.white,
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// TOKEN PACKAGES SECTION
// ============================================================================
class _TokenPackagesSection extends StatelessWidget {
  const _TokenPackagesSection();

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final darkerPrimary = Color.lerp(primaryColor, Colors.black, 0.5) ?? primaryColor;
    // Special purple/blue color for the featured middle package
    const featuredColor = Color(0xFF5849E6);

    return Column(
      children: [
        SizedBox(
          width: 354.w,
          child: Text(
            context.l10n.selectTokenPackage,
            textAlign: TextAlign.center,
            style: AppTypography.bodyNormalRegular.copyWith(
              height: 1.0,
              color: const Color(0xFFFFFFE5),
            ),
          ),
        ),
        32.verticalSpace,
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: TokenPackageCardDetailed(
                originalTokens: '200',
                bonusTokens: '300',
                price: '₺99,99',
                badgeText: '+10%',
                gradientColors: [darkerPrimary, primaryColor],
                badgeColor: darkerPrimary,
              ),
            ),
            8.horizontalSpace,
            Expanded(
              child: TokenPackageCardDetailed(
                originalTokens: '2.000',
                bonusTokens: '3.375',
                price: '₺799,99',
                badgeText: '+70%',
                gradientColors: [featuredColor, primaryColor],
                badgeColor: featuredColor,
              ),
            ),
            8.horizontalSpace,
            Expanded(
              child: TokenPackageCardDetailed(
                originalTokens: '1.000',
                bonusTokens: '1.350',
                price: '₺399,99',
                badgeText: '+35%',
                gradientColors: [darkerPrimary, primaryColor],
                badgeColor: darkerPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ============================================================================
// CTA BUTTON
// ============================================================================
class _CTAButton extends StatelessWidget {
  const _CTAButton();

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Container(
      width: double.infinity,
      height: 56.h,
      padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 8.h),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
      ),
      child: Center(
        child: Text(
          context.l10n.seeAllTokens,
          style: AppTypography.bodyLargeSemibold.copyWith(
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// CLOSE BUTTON
// ============================================================================
class _CloseButton extends StatelessWidget {
  const _CloseButton();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 24.w,
      top: 16.h,
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          width: 36.w,
          height: 36.h,
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: AppColors.black.withValues(alpha: 0.10),
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1.w, color: AppColors.white50),
              borderRadius: BorderRadius.circular(900.r),
            ),
          ),
          child: Center(
            child: Icon(Icons.close, color: AppColors.white, size: 20.sp),
          ),
        ),
      ),
    );
  }
}
