import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter_template/core/extensions/context_extensions.dart';
import 'package:flutter_template/core/theme/app_colors.dart';
import 'package:flutter_template/core/theme/app_spacing.dart';
import 'package:flutter_template/core/theme/app_typography.dart';
import 'package:flutter_template/presentation/profile/bloc/profile_bloc.dart';
import 'package:flutter_template/presentation/widgets/buttons/app_bar_back_button.dart';
import 'package:flutter_template/presentation/widgets/gradient_background.dart';
import 'package:flutter_template/presentation/widgets/svg_icon.dart';
import 'package:flutter_template/presentation/widgets/upload/image_preview_card.dart';
import 'package:flutter_template/presentation/widgets/upload/upload_button.dart';

// ============================================================================
// PROFILE PHOTO SETUP PAGE
// ============================================================================
class ProfilePhotoSetupPage extends StatefulWidget {
  const ProfilePhotoSetupPage({super.key});

  @override
  State<ProfilePhotoSetupPage> createState() => _ProfilePhotoSetupPageState();
}

// ============================================================================
// PROFILE PHOTO SETUP PAGE STATE
// ============================================================================
class _ProfilePhotoSetupPageState extends State<ProfilePhotoSetupPage> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),

              64.verticalSpace,
              Expanded(child: _buildContent()),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================================================
  // BUILD METHODS
  // ==========================================================================

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
      child: Row(
        children: [
          AppBarBackButton(onPressed: () => Navigator.pop(context)),
          const Expanded(child: _HeaderTitle()),
          44.horizontalSpace,
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            _buildLogoPlaceholder(),
            16.verticalSpace,
            _buildTitleSection(context),
            52.verticalSpace,
            _buildImagePicker(),
          ],
        ),
        _buildBottomButtons(context),
      ],
    );
  }

  Widget _buildLogoPlaceholder() {
    return Container(
      width: 76.w,
      height: 76.w,
      decoration: BoxDecoration(
        color: AppColors.black.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Center(
        child: SizedBox(
          width: 32.w,
          height: 40.w,
          child: SvgIcon(assetPath: 'assets/icons/Vector.svg', size: 32.w),
        ),
      ),
    );
  }

  Widget _buildTitleSection(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 196.w,
          child: Text(
            context.l10n.uploadPhoto,
            textAlign: TextAlign.center,
            style: AppTypography.heading4.copyWith(color: AppColors.white),
          ),
        ),
        12.verticalSpace,
        SizedBox(
          width: 234.w,
          child: Text(
            context.l10n.uploadPhotoDescription,
            textAlign: TextAlign.center,
            style: AppTypography.bodyNormalRegular.copyWith(
              color: AppColors.white90,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImagePicker() {
    if (_selectedImage == null) {
      return UploadButton(onTap: _handlePickImage);
    }
    return ImagePreviewCard(
      image: _selectedImage!,
      onRemove: _handleRemoveImage,
    );
  }

  Widget _buildBottomButtons(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        children: [
          _ContinueButton(
            isEnabled: _selectedImage != null,
            onPressed: _handleContinue,
          ),
          13.verticalSpace,
          _SkipButton(onPressed: _handleSkip),
          24.verticalSpace,
        ],
      ),
    );
  }

  // ==========================================================================
  // EVENT HANDLERS
  // ==========================================================================

  /*
   * Image Picker Optimizasyonları:
   * - maxWidth/maxHeight: Upload boyutunu küçültmek için (512x512 yeterli)
   * - imageQuality: 85 kalite ile dosya boyutunu azaltıyoruz
   * - Hem kullanıcı deneyimi hem de backend yükü için optimize edilmiş
   */
  Future<void> _handlePickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${context.l10n.photoSelectionError}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _handleRemoveImage() {
    setState(() {
      _selectedImage = null;
    });
  }

  void _handleContinue() {
    if (_selectedImage != null) {
      context.read<ProfileBloc>().add(
        ProfilePhotoUpdateRequested(_selectedImage!.path),
      );
      Navigator.pop(context);
    }
  }

  void _handleSkip() {
    Navigator.pop(context);
  }
}

// ============================================================================
// HEADER TITLE
// ============================================================================
class _HeaderTitle extends StatelessWidget {
  const _HeaderTitle();

  @override
  Widget build(BuildContext context) {
    return Text(
      context.l10n.profileDetails,
      textAlign: TextAlign.center,
      style: AppTypography.bodyXLargeSemibold.copyWith(
        color: AppColors.white,
        height: 1.0,
        letterSpacing: 0,
      ),
    );
  }
}

// ============================================================================
// PROFILE GRADIENT BUTTON (Continue Button)
// ============================================================================
/// Profile feature'ında kullanılan gradient button
///
/// Enabled/disabled state'e göre gradient ve opacity değişir.
/// Primary color'a göre dinamik gradient oluşturur.
class _ContinueButton extends StatelessWidget {
  final bool isEnabled;
  final VoidCallback onPressed;

  const _ContinueButton({
    required this.isEnabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final lighterPrimary =
        Color.lerp(primaryColor, Colors.white, 0.2) ?? primaryColor;

    return Opacity(
      opacity: isEnabled ? 1.0 : 0.5,
      child: Container(
        width: double.infinity,
        height: 56.h,
        decoration: BoxDecoration(
          gradient: isEnabled
              ? LinearGradient(
                  colors: [lighterPrimary, primaryColor],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )
              : null,
          color: !isEnabled ? primaryColor : null,
          borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
        ),
        child: ElevatedButton(
          onPressed: isEnabled ? onPressed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            splashFactory: NoSplash.splashFactory,
            overlayColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
            ),
          ),
          child: Text(
            context.l10n.continueButton,
            style: AppTypography.bodyLargeSemibold.copyWith(
              color: AppColors.white,
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// PROFILE SKIP BUTTON
// ============================================================================
/// Profile onboarding flow'unda kullanılan skip button
///
/// TextButton wrapper ile minimal görünüm.
class _SkipButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _SkipButton({
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        minimumSize: Size(double.infinity, 56.h),
      ),
      child: Text(
        context.l10n.skip,
        style: AppTypography.bodyLargeSemibold.copyWith(
          color: AppColors.white,
        ),
      ),
    );
  }
}
