// Flutter framework imports
import 'package:flutter/material.dart';

// External package imports
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

// Internal imports
import 'package:flutter_template/core/di/injection_container.dart';
import 'package:flutter_template/core/error/error_handler.dart';
import 'package:flutter_template/core/extensions/context_extensions.dart';
import 'package:flutter_template/core/theme/app_colors.dart';
import 'package:flutter_template/core/theme/app_spacing.dart';
import 'package:flutter_template/core/theme/app_typography.dart';
import 'package:flutter_template/presentation/auth/bloc/login/login_bloc.dart';
import 'package:flutter_template/presentation/auth/view/register_page_new.dart';
import 'package:flutter_template/presentation/main/view/main_page.dart';
import 'package:flutter_template/presentation/widgets/app_logo.dart';
import 'package:flutter_template/presentation/widgets/custom_text_field.dart';
import 'package:flutter_template/presentation/widgets/gradient_background.dart';
import 'package:flutter_template/presentation/widgets/primary_button.dart';
import 'package:flutter_template/presentation/widgets/social_login_button.dart';
import 'package:flutter_template/presentation/widgets/svg_icon.dart';

// ============================================================================
// LOGIN PAGE
// ============================================================================
class LoginPageNew extends StatelessWidget {
  const LoginPageNew({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(loginUseCase: sl()),
      child: const _LoginView(),
    );
  }
}

// ============================================================================
// LOGIN VIEW
// ============================================================================
class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => _LoginViewState();
}

// ============================================================================
// LOGIN VIEW STATE
// ============================================================================
class _LoginViewState extends State<_LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: Column(
          children: [
            _buildAnimationHeader(),
            Expanded(
              child: BlocConsumer<LoginBloc, LoginState>(
                listener: _handleLoginStateChanges,
                builder: (context, state) => _buildScrollableContent(state),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================================
  // BUILD METHODS
  // ==========================================================================

  Widget _buildAnimationHeader() {
    return SizedBox(
      width: double.infinity,
      height: 186.h,
      child: Lottie.asset('assets/Artboard_1.json', fit: BoxFit.cover),
    );
  }

  Widget _buildScrollableContent(LoginState state) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        children: [
          AppLogo(size: 78.w),
          24.verticalSpace,
          const _HeaderSection(),
          36.verticalSpace,
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
          const _ForgotPasswordButton(),
          24.verticalSpace,
          _LoginButton(
            isLoading: state.status == LoginStatus.loading,
            isEnabled: state.isFormValid,
            onPressed: () => _handleLoginSubmit(),
          ),
          24.verticalSpace,
          const _SocialLoginButtons(),
          24.verticalSpace,
          const _SignUpPrompt(),
          24.verticalSpace,
        ],
      ),
    );
  }

  // ==========================================================================
  // EVENT HANDLERS
  // ==========================================================================

  void _handleLoginStateChanges(BuildContext context, LoginState state) {
    final errorHandler = sl<ErrorHandler>();

    if (state.status == LoginStatus.success) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const MainPage()),
        (route) => false,
      );
    } else if (state.status == LoginStatus.failure) {
      // Use centralized error handler
      errorHandler.handleError(
        state.errorMessage ?? context.l10n.loginFailed,
        context: context,
      );
    }
  }

  void _handleLoginSubmit() {
    context.read<LoginBloc>().add(
      LoginSubmitted(
        email: _emailController.text,
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
          context.l10n.login,
          textAlign: TextAlign.center,
          style: AppTypography.heading4.copyWith(color: AppColors.white),
        ),
        SizedBox(height: AppSpacing.md),
        Text(
          context.l10n.loginSubtitle,
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
        context.read<LoginBloc>().add(LoginEmailChanged(value));
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
        context.read<LoginBloc>().add(LoginPasswordChanged(value));
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
// FORGOT PASSWORD BUTTON
// ============================================================================
class _ForgotPasswordButton extends StatelessWidget {
  const _ForgotPasswordButton();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
        },
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(
          context.l10n.forgotPassword,
          style: AppTypography.bodyNormalSemibold.copyWith(
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// LOGIN BUTTON
// ============================================================================
class _LoginButton extends StatelessWidget {
  final bool isLoading;
  final bool isEnabled;
  final VoidCallback onPressed;

  const _LoginButton({
    required this.isLoading,
    required this.isEnabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      text: context.l10n.login,
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
// SIGN UP PROMPT
// ============================================================================
class _SignUpPrompt extends StatelessWidget {
  const _SignUpPrompt();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          context.l10n.dontHaveAccount,
          style: AppTypography.bodyNormalRegular.copyWith(
            color: AppColors.white80,
          ),
        ),
        SizedBox(width: AppSpacing.sm),
        TextButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const RegisterPageNew()),
            );
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            context.l10n.register,
            style: AppTypography.bodyNormalSemibold.copyWith(
              color: AppColors.white,
            ),
          ),
        ),
      ],
    );
  }
}
