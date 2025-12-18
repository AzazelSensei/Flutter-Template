import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// State for locale management
class LocaleState extends Equatable {
  final Locale locale;

  const LocaleState({
    this.locale = const Locale('en', 'US'),
  });

  LocaleState copyWith({Locale? locale}) {
    return LocaleState(
      locale: locale ?? this.locale,
    );
  }

  @override
  List<Object?> get props => [locale];
}

/// Supported locales for the app
class SupportedLocales {
  static const turkish = Locale('tr', 'TR');
  static const english = Locale('en', 'US');

  static const List<Locale> all = [turkish, english];

  static String getDisplayName(Locale locale) {
    switch (locale.languageCode) {
      case 'tr':
        return 'Türkçe';
      case 'en':
        return 'English';
      default:
        return 'English';
    }
  }

  static String getFlag(Locale locale) {
    switch (locale.languageCode) {
      case 'tr':
        return '🇹🇷';
      case 'en':
        return '🇺🇸';
      default:
        return '🇺🇸';
    }
  }

  static Locale fromLanguageCode(String languageCode) {
    switch (languageCode) {
      case 'tr':
        return turkish;
      case 'en':
        return english;
      default:
        return english;
    }
  }
}
