import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/core/storage/locale_storage.dart';
import 'package:flutter_template/core/locale/locale_state.dart';

class LocaleCubit extends Cubit<LocaleState> {
  final LocaleStorage _storage;

  LocaleCubit(this._storage) : super(const LocaleState());
  Future<void> loadLocale() async {
    final savedLanguageCode = await _storage.getLocale();
    if (savedLanguageCode != null) {
      final locale = SupportedLocales.fromLanguageCode(savedLanguageCode);
      emit(state.copyWith(locale: locale));
    }
  }

  Future<void> changeLocale(Locale locale) async {
    await _storage.saveLocale(locale.languageCode);
    emit(state.copyWith(locale: locale));
  }

  Future<void> resetLocale() async {
    await _storage.clearLocale();
    emit(const LocaleState());
  }
}
