import 'package:flutter/material.dart';
import 'package:flutter_template/core/di/injection_container.dart';
import 'package:flutter_template/core/navigation/navigation_service.dart';
import 'package:flutter_template/l10n/app_localizations.dart';

/// Global localization helper
///
/// ⚠️ DİKKAT: Bu helper sadece BuildContext'in olmadığı özel durumlarda kullanılmalıdır.
/// Normal widget'larda direkt `context.l10n` kullanın.
///
/// Kullanım:
/// ```dart
/// // ❌ Widget içinde kullanma
/// Text(L10n.current.login)
///
/// // ✅ Widget içinde context kullan
/// Text(context.l10n.login)
///
/// // ✅ Sadece context olmayan yerlerde kullan (ör: model class, service, bloc)
/// print(L10n.current.errorOccurred)
/// throw Exception(L10n.current.networkError)
/// ```
class L10n {
  L10n._();

  /// Get current locale translations
  ///
  /// ⚠️ Bu method sadece app initialize edildikten sonra çalışır
  static AppLocalizations get current {
    final context = sl<NavigationService>().navigatorKey.currentContext;
    if (context == null) {
      throw Exception(
        'L10n.current called before app initialization. '
        'Make sure app is fully initialized.',
      );
    }
    return AppLocalizations.of(context)!;
  }

  /// Get current locale
  static Locale get locale {
    final context = sl<NavigationService>().navigatorKey.currentContext;
    if (context == null) {
      return const Locale('tr'); // Default locale
    }
    return Localizations.localeOf(context);
  }

  /// Check if current locale is Turkish
  static bool get isTurkish => locale.languageCode == 'tr';

  /// Check if current locale is English
  static bool get isEnglish => locale.languageCode == 'en';
}
