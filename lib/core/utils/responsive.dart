import 'package:flutter/material.dart';

/*
 * Responsive Design Utility
 *
 * Design base: 402x874 (Figma design boyutu)
 * Mantık: Tüm boyutlar design'a göre oranlanır
 *
 * Örnek: 100.w -> Ekran genişliğine göre scale edilir
 * - 402px ekranda: 100px
 * - 800px ekranda: ~199px
 *
 * flutter_screenutil yerine custom implementation kullanılıyor
 */
class Responsive {
  static late double _screenWidth;
  static late double _screenHeight;
  static late double _designWidth;
  static late double _designHeight;
  static const double designWidth = 402;
  static const double designHeight = 874;

  static void init(BuildContext context) {
    final size = MediaQuery.of(context).size;
    _screenWidth = size.width;
    _screenHeight = size.height;
    _designWidth = designWidth;
    _designHeight = designHeight;
  }

  static double w(double width) {
    return (_screenWidth / _designWidth) * width;
  }

  static double h(double height) {
    return (_screenHeight / _designHeight) * height;
  }

  static double sp(double fontSize) {
    return (_screenWidth / _designWidth) * fontSize;
  }

  static double r(double radius) {
    return (_screenWidth / _designWidth) * radius;
  }

  static double horizontalPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) return width * 0.06;
    if (width < 900) return width * 0.1;
    return width * 0.15;
  }

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 600 && width < 900;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 900;
}

extension ResponsiveExtension on num {
  double get w => Responsive.w(toDouble());
  double get h => Responsive.h(toDouble());
  double get sp => Responsive.sp(toDouble());
  double get r => Responsive.r(toDouble());
}
