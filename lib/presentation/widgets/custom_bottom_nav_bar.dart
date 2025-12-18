import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/theme/app_colors.dart';
import 'package:flutter_template/presentation/widgets/svg_icon.dart';

/// Bottom navigation item model
class BottomNavItem {
  final String icon;
  final String iconFill;
  final String label;

  const BottomNavItem({
    required this.icon,
    required this.iconFill,
    required this.label,
  });
}

/// Custom bottom navigation bar with gradient background
///
/// Gradient arkaplan ve animated butonlar ile özelleştirilmiş navbar.
/// Ana navigasyon için kullanılır.
class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onIndexChanged;
  final List<BottomNavItem> items;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onIndexChanged,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: 16.h,
        left: 24.w,
        right: 24.w,
        bottom: 36.h,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.0, 0.29],
          colors: [Color(0x00090909), Color(0xFF090909)],
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(
          items.length,
          (index) => [
            Expanded(
              child: _buildNavButton(
                context: context,
                item: items[index],
                index: index,
                isActive: currentIndex == index,
              ),
            ),
            if (index < items.length - 1) 16.horizontalSpace,
          ],
        ).expand((element) => element).toList(),
      ),
    );
  }

  Widget _buildNavButton({
    required BuildContext context,
    required BottomNavItem item,
    required int index,
    required bool isActive,
  }) {
    return GestureDetector(
      onTap: () => onIndexChanged(index),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: ShapeDecoration(
          gradient: isActive
              ? RadialGradient(
                  center: const Alignment(0.0, -0.9),
                  radius: 1.4,
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.secondary,
                  ],
                )
              : null,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              color: AppColors.white.withValues(alpha: 0.20),
            ),
            borderRadius: BorderRadius.circular(42.r),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgIcon(
              assetPath: isActive ? item.iconFill : item.icon,
              size: 24.w,
              color: AppColors.white,
            ),
            10.horizontalSpace,
            Text(
              item.label,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 14,
                fontFamily: 'Instrument Sans',
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
