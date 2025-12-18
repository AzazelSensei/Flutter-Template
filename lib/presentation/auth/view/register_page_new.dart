// Flutter framework imports
import 'package:flutter/material.dart';

// External package imports
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Internal imports
import 'package:flutter_template/core/di/injection_container.dart';
import 'package:flutter_template/core/error/error_handler.dart';
import 'package:flutter_template/core/extensions/context_extensions.dart';
import 'package:flutter_template/core/theme/app_colors.dart';
import 'package:flutter_template/core/theme/app_spacing.dart';
import 'package:flutter_template/core/theme/app_typography.dart';
import 'package:flutter_template/presentation/auth/bloc/register/register_bloc.dart';
import 'package:flutter_template/presentation/main/view/main_page.dart';
import 'package:flutter_template/presentation/widgets/app_logo.dart';
import 'package:flutter_template/presentation/widgets/custom_text_field.dart';
import 'package:flutter_template/presentation/widgets/gradient_background.dart';
import 'package:flutter_template/presentation/widgets/primary_button.dart';
import 'package:flutter_template/presentation/widgets/social_login_button.dart';
import 'package:flutter_template/presentation/widgets/svg_icon.dart';
import 'package:flutter_template/presentation/widgets/terms_checkbox.dart';


// ============================================================================
// REGISTER PAGE
// ============================================================================
class RegisterPageNew extends StatelessWidget {
  const RegisterPageNew({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterBloc(registerUseCase: sl()),
      child: const _RegisterView(),
    );
  }
}

// ============================================================================
// REGISTER VIEW
// ============================================================================
class _RegisterView extends StatefulWidget {
  const _RegisterView();

  @override
  State<_RegisterView> createState() => _RegisterViewState();
}

// ============================================================================
// REGISTER VIEW STATE
// ============================================================================
class _RegisterViewState extends State<_RegisterView> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscurePasswordConfirm = true;
  bool _agreedToTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              16.verticalSpace,
              Expanded(
                child: BlocConsumer<RegisterBloc, RegisterState>(
                  listener: _handleRegisterStateChanges,
                  builder: (context, state) => _buildScrollableContent(state),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================================================
  // BUILD METHODS
  // ==========================================================================

  Widget _buildScrollableContent(RegisterState state) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        children: [
          AppLogo(size: 78.w),
          24.verticalSpace,
          const _HeaderSection(),
          36.verticalSpace,
          _NameField(
            controller: _nameController,
            isValid: state.isNameValid,
            hasValue: state.name.isNotEmpty,
          ),
          16.verticalSpace,
          _EmailField(
            controller: _emailController,
            isValid: state.isEmailValid,
            hasValue: state.email.isNotEmpty,
          ),
          16.verticalSpace,
          _PasswordField(
            controller: _passwordController,
            obscurePassword: _obscurePassword,
            isValid: state.isPasswordValid,
            hasValue: state.password.isNotEmpty,
            onToggleVisibility: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
          16.verticalSpace,
          _PasswordConfirmField(
            controller: _passwordConfirmController,
            obscurePassword: _obscurePasswordConfirm,
            onToggleVisibility: () {
              setState(() {
                _obscurePasswordConfirm = !_obscurePasswordConfirm;
              });
            },
          ),
          16.verticalSpace,
          TermsCheckbox(
            isChecked: _agreedToTerms,
            onChanged: (value) {
              setState(() {
                _agreedToTerms = value;
              });
            },
          ),
          24.verticalSpace,
          _RegisterButton(
            isLoading: state.status == RegisterStatus.loading,
            isEnabled: state.isFormValid && _agreedToTerms,
            onPressed: () => _handleRegisterSubmit(),
          ),
          24.verticalSpace,
          const _SocialLoginButtons(),
          24.verticalSpace,
          const _LoginPrompt(),
          24.verticalSpace,
        ],
      ),
    );
  }

  // ==========================================================================
  // EVENT HANDLERS
  // ==========================================================================

  void _handleRegisterStateChanges(BuildContext context, RegisterState state) {
    final errorHandler = sl<ErrorHandler>();

    if (state.status == RegisterStatus.success) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const MainPage()),
        (route) => false,
      );
    } else if (state.status == RegisterStatus.failure) {
      // Use centralized error handler
      errorHandler.handleError(
        state.errorMessage ?? context.l10n.registerFailed,
        context: context,
      );
    }
  }

  void _handleRegisterSubmit() {
    final errorHandler = sl<ErrorHandler>();

    // Validate password match
    if (_passwordController.text != _passwordConfirmController.text) {
      errorHandler.handleValidationError(
        context: context,
        message: context.l10n.passwordsNotMatch,
      );
      return;
    }

    context.read<RegisterBloc>().add(
          RegisterSubmitted(
            email: _emailController.text,
            name: _nameController.text,
            password: _passwordController.text,
          ),
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
          context.l10n.createAccount,
          textAlign: TextAlign.center,
          style: AppTypography.heading4.copyWith(color: AppColors.white),
        ),
        SizedBox(height: AppSpacing.md),
        Text(
          context.l10n.registerSubtitle,
          textAlign: TextAlign.center,
          style: AppTypography.bodyNormalRegular.copyWith(
            color: AppColors.white90,
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// NAME FIELD
// ============================================================================
class _NameField extends StatelessWidget {
  final TextEditingController controller;
  final bool isValid;
  final bool hasValue;

  const _NameField({
    required this.controller,
    required this.isValid,
    required this.hasValue,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      hintText: context.l10n.name,
      controller: controller,
      errorText: !isValid && hasValue ? context.l10n.nameTooShort : null,
      onChanged: (value) {
        context.read<RegisterBloc>().add(RegisterNameChanged(value));
      },
      prefixIcon: Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.xl,
          AppSpacing.lg,
          AppSpacing.ms,
          AppSpacing.lg,
        ),
        child: SvgIcon(
          assetPath: AppIcons.user,
          size: 24.w,
          color: AppColors.white50,
        ),
      ),
    );
  }
}

// ============================================================================
// EMAIL FIELD
// ============================================================================
class _EmailField extends StatelessWidget {
  final TextEditingController controller;
  final bool isValid;
  final bool hasValue;

  const _EmailField({
    required this.controller,
    required this.isValid,
    required this.hasValue,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      hintText: context.l10n.email,
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      errorText: !isValid && hasValue ? context.l10n.invalidEmail : null,
      onChanged: (value) {
        context.read<RegisterBloc>().add(RegisterEmailChanged(value));
      },
      prefixIcon: Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.xl,
          AppSpacing.lg,
          AppSpacing.ms,
          AppSpacing.lg,
        ),
        child: SvgIcon(
          assetPath: AppIcons.mail,
          size: 24.w,
          color: AppColors.white50,
        ),
      ),
    );
  }
}

// ============================================================================
// PASSWORD FIELD
// ============================================================================
class _PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final bool obscurePassword;
  final bool isValid;
  final bool hasValue;
  final VoidCallback onToggleVisibility;

  const _PasswordField({
    required this.controller,
    required this.obscurePassword,
    required this.isValid,
    required this.hasValue,
    required this.onToggleVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      hintText: context.l10n.password,
      controller: controller,
      obscureText: obscurePassword,
      errorText: !isValid && hasValue
          ? context.l10n.passwordTooShort
          : null,
      onChanged: (value) {
        context.read<RegisterBloc>().add(RegisterPasswordChanged(value));
      },
      prefixIcon: Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.xl,
          AppSpacing.lg,
          AppSpacing.ms,
          AppSpacing.lg,
        ),
        child: SvgIcon(
          assetPath: AppIcons.lock,
          size: 24.w,
          color: AppColors.white50,
        ),
      ),
      suffixIcon: Padding(
        padding: EdgeInsets.only(right: AppSpacing.md),
        child: IconButton(
          icon: SvgIcon(
            assetPath: obscurePassword ? AppIcons.hide : AppIcons.see,
            size: 24.w,
            color: AppColors.white50,
          ),
          onPressed: onToggleVisibility,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ),
    );
  }
}

// ============================================================================
// PASSWORD CONFIRM FIELD
// ============================================================================
class _PasswordConfirmField extends StatelessWidget {
  final TextEditingController controller;
  final bool obscurePassword;
  final VoidCallback onToggleVisibility;

  const _PasswordConfirmField({
    required this.controller,
    required this.obscurePassword,
    required this.onToggleVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      hintText: context.l10n.confirmPassword,
      controller: controller,
      obscureText: obscurePassword,
      onChanged: (value) {
        // Password confirmation validation
      },
      prefixIcon: Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.xl,
          AppSpacing.lg,
          AppSpacing.ms,
          AppSpacing.lg,
        ),
        child: SvgIcon(
          assetPath: AppIcons.lock,
          size: 24.w,
          color: AppColors.white50,
        ),
      ),
      suffixIcon: Padding(
        padding: EdgeInsets.only(right: AppSpacing.md),
        child: IconButton(
          icon: SvgIcon(
            assetPath: obscurePassword ? AppIcons.hide : AppIcons.see,
            size: 24.w,
            color: AppColors.white50,
          ),
          onPressed: onToggleVisibility,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ),
    );
  }
}

// ============================================================================
// REGISTER BUTTON
// ============================================================================
class _RegisterButton extends StatelessWidget {
  final bool isLoading;
  final bool isEnabled;
  final VoidCallback onPressed;

  const _RegisterButton({
    required this.isLoading,
    required this.isEnabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      text: context.l10n.register,
      isLoading: isLoading,
      onPressed: isEnabled ? onPressed : null,
      useGradient: false,
    );
  }
}

// ============================================================================
// SOCIAL LOGIN BUTTONS
// ============================================================================
class _SocialLoginButtons extends StatelessWidget {
  const _SocialLoginButtons();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SocialLoginButton(
          iconAsset: AppIcons.google,
          onPressed: () {
          },
        ),
        15.horizontalSpace,
        SocialLoginButton(
          iconAsset: AppIcons.apple,
          onPressed: () {
          },
        ),
        15.horizontalSpace,
        SocialLoginButton(
          iconAsset: AppIcons.facebook,
          onPressed: () {
          },
        ),
      ],
    );
  }
}

// ============================================================================
// LOGIN PROMPT
// ============================================================================
class _LoginPrompt extends StatelessWidget {
  const _LoginPrompt();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          context.l10n.alreadyHaveAccount,
          style: AppTypography.bodyNormalRegular.copyWith(
            color: AppColors.white80,
          ),
        ),
        SizedBox(width: AppSpacing.sm),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            context.l10n.login,
            style: AppTypography.bodyNormalSemibold.copyWith(
              color: AppColors.white,
            ),
          ),
        ),
      ],
    );
  }
}
