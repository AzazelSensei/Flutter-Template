import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/di/injection_container.dart' as di;
import 'package:flutter_template/core/initialization/initialization_adapters.dart';
import 'package:flutter_template/core/logging/logger_service.dart';
import 'package:flutter_template/core/navigation/navigation_service.dart';
import 'package:flutter_template/core/theme/app_theme.dart';
import 'package:flutter_template/l10n/app_localizations.dart';
import 'package:flutter_template/core/locale/locale_cubit.dart';
import 'package:flutter_template/core/locale/locale_state.dart';
import 'package:flutter_template/presentation/splash/splash_page.dart';
import 'package:flutter_template/core/theme/theme_cubit.dart';
import 'package:flutter_template/core/theme/theme_state.dart';

/*
 * Uygulama initialization işlemi Adapter Pattern kullanılarak yapılır.
 * Tüm adapter'lar öncelik sırasına göre (priority) çalıştırılır.
 *
 * Adapter registration logic: lib/core/initialization/adapter_registration.dart
 */
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  // Logger - varsayılan olarak response'lar kısaltılarak gösterilir
  // Detaylı loglar için: LoggerService(verboseResponses: true)
  final logger = LoggerService();
  AppInitializer.setLogger(logger);

  registerInitializationAdapters();
  await AppInitializer.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(402, 874),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(value: di.sl<ThemeCubit>()),
            BlocProvider.value(value: di.sl<LocaleCubit>()),
          ],
          child: BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, themeState) {
              return BlocBuilder<LocaleCubit, LocaleState>(
                builder: (context, localeState) {
                  return MaterialApp(
                    title: 'Shartflix',
                    debugShowCheckedModeBanner: false,
                    theme: AppTheme.darkTheme(themeState.currentTheme),
                    locale: localeState.locale,
                    navigatorKey: di.sl<NavigationService>().navigatorKey,
                    localizationsDelegates: const [
                      AppLocalizations.delegate,
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                    ],
                    supportedLocales: AppLocalizations.supportedLocales,
                    home: const SplashPage(),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
