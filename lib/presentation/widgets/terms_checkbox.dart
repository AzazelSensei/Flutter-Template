import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/extensions/context_extensions.dart';
import 'package:flutter_template/core/theme/app_colors.dart';
import 'package:flutter_template/core/theme/app_typography.dart';

/// Terms and conditions checkbox
///
/// Kullanıcı sözleşmesi checkbox'ı - custom tasarım ve üç parçalı metin.
/// Register ve benzeri sayfalarda kullanılır.
class TermsCheckbox extends StatelessWidget {
  final bool isChecked;
  final ValueChanged<bool> onChanged;
  final String? prefixText;
  final String? highlightedText;
  final String? suffixText;

  const TermsCheckbox({
    super.key,
    required this.isChecked,
    required this.onChanged,
    this.prefixText,
    this.highlightedText,
    this.suffixText,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => onChanged(!isChecked),
          child: Container(
            width: 24.w,
            height: 24.w,
            decoration: BoxDecoration(
              color: isChecked ? primaryColor : AppColors.white5,
              borderRadius: BorderRadius.circular(6.r),
              border: Border.all(
                color: isChecked ? primaryColor : AppColors.white20,
                width: 1.w,
              ),
            ),
            child: isChecked
                ? Icon(
                    Icons.check,
                    size: 16.w,
                    color: AppColors.white,
                  )
                : null,
          ),
        ),
        12.horizontalSpace,
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: prefixText ?? context.l10n.termsPrefix,
                  style: AppTypography.bodySmallRegular.copyWith(
                    color: AppColors.white60,
                    height: 1.0,
                    letterSpacing: 0,
                  ),
                ),
                TextSpan(
                  text: highlightedText ?? context.l10n.termsAccept,
                  style: AppTypography.bodySmallSemibold.copyWith(
                    color: AppColors.white,
                    decoration: TextDecoration.underline,
                    height: 1.0,
                    letterSpacing: 0,
                  ),
                ),
                TextSpan(
                  text: suffixText ?? context.l10n.termsSuffix,
                  style: AppTypography.bodySmallRegular.copyWith(
                    color: AppColors.white60,
                    height: 1.0,
                    letterSpacing: 0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
