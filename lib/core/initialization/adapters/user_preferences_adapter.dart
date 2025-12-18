import 'package:flutter_template/core/di/injection_container.dart' as di;
import 'package:flutter_template/core/initialization/app_initializer.dart';
import 'package:flutter_template/core/locale/locale_cubit.dart';
import 'package:flutter_template/core/theme/theme_cubit.dart';

/*
 * NOT: Future.wait ile paralel yükleniyor - startup optimization
 */
class UserPreferencesAdapter implements InitializationAdapter {
  @override
  String get name => 'User Preferences (Theme, Locale)';

  @override
  int get priority => 4;

  @override
  Future<void> initialize() async {
    await Future.wait([
      di.sl<ThemeCubit>().loadTheme(),
      di.sl<LocaleCubit>().loadLocale(),
    ]);
  }
}
