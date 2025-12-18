import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/core/storage/theme_storage.dart';
import 'package:flutter_template/domain/entities/app_theme.dart';
import 'package:flutter_template/core/theme/theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final ThemeStorage _themeStorage;

  ThemeCubit(this._themeStorage) : super(const ThemeState());

  Future<void> loadTheme() async {
    final themeId = await _themeStorage.getThemeId();
    if (themeId != null) {
      final theme = AppTheme.getThemeById(themeId);
      emit(state.copyWith(currentTheme: theme));
    }
  }

  Future<void> changeTheme(AppTheme theme) async {
    await _themeStorage.saveThemeId(theme.id);
    emit(state.copyWith(currentTheme: theme));
  }

  Future<void> resetTheme() async {
    await _themeStorage.deleteTheme();
    emit(const ThemeState());
  }
}
