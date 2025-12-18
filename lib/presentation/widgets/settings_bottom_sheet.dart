import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/extensions/context_extensions.dart';
import 'package:flutter_template/core/theme/app_colors.dart';
import 'package:flutter_template/core/theme/app_spacing.dart';
import 'package:flutter_template/core/theme/app_typography.dart';
import 'package:flutter_template/domain/entities/app_theme.dart';
import 'package:flutter_template/core/locale/locale_cubit.dart';
import 'package:flutter_template/core/locale/locale_state.dart';
import 'package:flutter_template/core/theme/theme_cubit.dart';
import 'package:flutter_template/core/theme/theme_state.dart';

class SettingsBottomSheet extends StatelessWidget {
  const SettingsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.bgGradientOf(context),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.l10n.settings,
                    style: AppTypography.heading5.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.close, color: AppColors.white, size: 24.w),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.xl),
              Text(
                context.l10n.theme,
                style: AppTypography.bodyLargeSemibold.copyWith(
                  color: AppColors.white,
                ),
              ),
              SizedBox(height: AppSpacing.md),
              const _ThemeSelector(),
              SizedBox(height: AppSpacing.xxl),
              Text(
                context.l10n.language,
                style: AppTypography.bodyLargeSemibold.copyWith(
                  color: AppColors.white,
                ),
              ),
              SizedBox(height: AppSpacing.md),
              const _LanguageSelector(),
              SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}

class _ThemeSelector extends StatelessWidget {
  const _ThemeSelector();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.md,
          children: AppTheme.availableThemes.map((theme) {
            final isSelected = state.currentTheme.id == theme.id;

            return GestureDetector(
              onTap: () => context.read<ThemeCubit>().changeTheme(theme),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.white20 : AppColors.white5,
                  borderRadius: BorderRadius.circular(AppSpacing.md),
                  border: Border.all(
                    color: isSelected ? theme.primary : AppColors.white20,
                    width: isSelected ? 2.w : 1.w,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 16.w,
                      height: 16.w,
                      decoration: BoxDecoration(
                        color: theme.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: AppSpacing.sm),
                    Text(
                      theme.name,
                      style: AppTypography.bodyNormalSemibold.copyWith(
                        color: isSelected ? AppColors.white : AppColors.white80,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class _LanguageSelector extends StatelessWidget {
  const _LanguageSelector();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, LocaleState>(
      builder: (context, state) {
        return Column(
          children: SupportedLocales.all.map((locale) {
            final isSelected = state.locale == locale;

            return Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.sm),
              child: GestureDetector(
                onTap: () => context.read<LocaleCubit>().changeLocale(locale),
                child: Container(
                  padding: EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.white20 : AppColors.white5,
                    borderRadius: BorderRadius.circular(AppSpacing.md),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primaryOf(context)
                          : AppColors.white20,
                      width: isSelected ? 2.w : 1.w,
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        SupportedLocales.getFlag(locale),
                        style: TextStyle(fontSize: 24.sp),
                      ),
                      SizedBox(width: AppSpacing.md),
                      Text(
                        SupportedLocales.getDisplayName(locale),
                        style: AppTypography.bodyLargeSemibold.copyWith(
                          color: isSelected
                              ? AppColors.white
                              : AppColors.white80,
                        ),
                      ),
                      const Spacer(),
                      if (isSelected)
                        Icon(
                          Icons.check_circle,
                          color: AppColors.primaryOf(context),
                          size: 24.w,
                        ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
