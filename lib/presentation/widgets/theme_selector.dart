import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/extensions/context_extensions.dart';
import 'package:flutter_template/core/theme/app_colors.dart';
import 'package:flutter_template/core/theme/app_typography.dart';
import 'package:flutter_template/domain/entities/app_theme.dart' as entity;
import 'package:flutter_template/core/theme/theme_cubit.dart';
import 'package:flutter_template/core/theme/theme_state.dart';

// ============================================================================
// THEME SELECTOR BOTTOM SHEET
// ============================================================================
/// Bottom sheet for selecting app theme
class ThemeSelectorBottomSheet extends StatelessWidget {
  const ThemeSelectorBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 24.w,
        vertical: 24.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.bgDark,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          24.verticalSpace,
          _buildThemeGrid(context),
          16.verticalSpace,
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Text(
      context.l10n.selectTheme,
      style: AppTypography.heading5.copyWith(
        color: AppColors.white,
      ),
    );
  }

  Widget _buildThemeGrid(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.w,
            mainAxisSpacing: 16.h,
            childAspectRatio: 2.5,
          ),
          itemCount: entity.AppTheme.availableThemes.length,
          itemBuilder: (context, index) {
            final theme = entity.AppTheme.availableThemes[index];
            final isSelected = state.currentTheme.id == theme.id;
            return _ThemeCard(
              theme: theme,
              isSelected: isSelected,
              onTap: () async {
                await context.read<ThemeCubit>().changeTheme(theme);
                // Small delay to show theme change before closing
                await Future.delayed(const Duration(milliseconds: 300));
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
            );
          },
        );
      },
    );
  }
}

// ============================================================================
// THEME CARD
// ============================================================================
/// Individual theme card for selection
class _ThemeCard extends StatelessWidget {
  final entity.AppTheme theme;
  final bool isSelected;
  final Future<void> Function() onTap;

  const _ThemeCard({
    required this.theme,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: theme.gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected
                ? AppColors.white
                : AppColors.white.withValues(alpha: 0.20),
            width: isSelected ? 2.w : 1.w,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                color: theme.primary,
                shape: BoxShape.circle,
              ),
            ),
            8.horizontalSpace,
            Expanded(
              child: Text(
                theme.name,
                style: AppTypography.bodyNormalSemibold.copyWith(
                  color: AppColors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: AppColors.white,
                size: 20.w,
              ),
          ],
        ),
      ),
    );
  }
}
