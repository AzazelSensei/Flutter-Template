import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/theme/app_colors.dart';
import 'package:flutter_template/core/theme/app_typography.dart';
import 'package:flutter_template/core/theme/app_spacing.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final ValueChanged<String>? onChanged;
  final String? errorText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isFocused = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  bool get _isFilled => widget.controller.text.isNotEmpty;
  bool get _hasError => widget.errorText != null;
  Color _borderColor(BuildContext context) {
    if (_hasError) {
      return AppColors.white20;
    }
    if (_isFocused) {
      return Theme.of(context).colorScheme.primary;
    }
    return AppColors.white20;
  }

  Color get _textColor {
    if (_hasError) {
      return AppColors.error;
    }
    if (_isFilled || _isFocused) {
      return AppColors.white;
    }
    return AppColors.white50;
  }

  FontWeight get _fontWeight {
    if (_hasError) {
      return FontWeight.w500;
    }
    if (_isFilled && !_isFocused) {
      return FontWeight.w500;
    }
    return FontWeight.w400;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.white5,
                borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
                border: Border.all(color: _borderColor(context), width: 1.w),
              ),
              child: TextField(
                controller: widget.controller,
                focusNode: _focusNode,
                obscureText: widget.obscureText,
                keyboardType: widget.keyboardType,
                onChanged: (value) {
                  setState(() {}); // Rebuild to update filled state
                  widget.onChanged?.call(value);
                },
                style: AppTypography.bodyNormalRegular.copyWith(
                  color: _textColor,
                  fontWeight: _fontWeight,
                ),
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: AppTypography.bodyNormalRegular.copyWith(
                    color: AppColors.white50,
                    height: 1.0,
                    letterSpacing: 0,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 17.h),
                  prefixIcon: widget.prefixIcon,
                  suffixIcon: widget.suffixIcon,
                ),
              ),
            ),
          ),
        ),
        if (_hasError)
          Padding(
            padding: EdgeInsets.only(left: AppSpacing.md, top: AppSpacing.sm),
            child: Text(
              widget.errorText!,
              style: AppTypography.bodyNormalRegular.copyWith(
                color: AppColors.error,
              ),
            ),
          ),
      ],
    );
  }
}
