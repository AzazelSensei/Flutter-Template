import 'package:flutter/material.dart';

/*
 * Singleton Navigation Service
 *
 * Flutter'ın standart Navigator'ını GlobalKey ile yönetmemizi sağlar.
 *
 * ÖNEMİ:
 * BuildContext'e erişimin olmadığı yerlerde (örneğin BLoC/Cubit içi,
 * Interceptor'lar veya Repository katmanları) navigasyon yapabilmek için kullanılır.
 * (Örn: Token expire olduğunda API katmanından Login sayfasına atmak)
 */
class NavigationService {
  static final NavigationService _instance = NavigationService._internal();

  factory NavigationService() => _instance;

  NavigationService._internal();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  BuildContext? get context => navigatorKey.currentContext;
  Future<T?>? navigateTo<T>(Widget page) {
    return navigatorKey.currentState?.push<T>(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  /*
   * Tüm navigation stack'i temizleyip yeni sayfaya git
   * Kullanım: Logout sonrası login'e gitmek gibi
   */
  Future<T?>? navigateToAndClearStack<T>(Widget page) {
    return navigatorKey.currentState?.pushAndRemoveUntil<T>(
      MaterialPageRoute(builder: (_) => page),
      (route) => false,
    );
  }

  Future<T?>? replaceTo<T>(Widget page) {
    return navigatorKey.currentState?.pushReplacement<T, dynamic>(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  void pop<T>([T? result]) {
    navigatorKey.currentState?.pop(result);
  }

  void popUntil(RoutePredicate predicate) {
    navigatorKey.currentState?.popUntil(predicate);
  }

  bool canPop() {
    return navigatorKey.currentState?.canPop() ?? false;
  }

  Future<T?> showBottomSheet<T>({
    required Widget child,
    bool isScrollControlled = true,
    bool isDismissible = true,
    bool enableDrag = true,
    Color? backgroundColor,
  }) {
    if (context == null) {
      throw Exception('NavigationService: Context is null');
    }

    return showModalBottomSheet<T>(
      context: context!,
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: backgroundColor ?? Colors.transparent,
      builder: (_) => child,
    );
  }

  Future<T?> showCustomDialog<T>({
    required Widget child,
    bool barrierDismissible = true,
  }) {
    if (context == null) {
      throw Exception('NavigationService: Context is null');
    }

    return showDialog<T>(
      context: context!,
      barrierDismissible: barrierDismissible,
      builder: (_) => child,
    );
  }
}
