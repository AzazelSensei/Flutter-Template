import 'package:dio/dio.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_template/core/error/error_handler.dart';
import 'package:flutter_template/core/firebase/analytics_service.dart';
import 'package:flutter_template/core/firebase/crashlytics_service.dart';
import 'package:flutter_template/core/logging/logger_service.dart';
import 'package:flutter_template/core/navigation/navigation_service.dart';
import 'package:flutter_template/core/network/dio_client.dart';
import 'package:flutter_template/core/storage/locale_storage.dart';
import 'package:flutter_template/core/storage/theme_storage.dart';
import 'package:flutter_template/core/storage/token_storage.dart';
import 'package:flutter_template/data/datasources/movie_remote_data_source.dart';
import 'package:flutter_template/data/datasources/remote/auth_remote_datasource.dart';
import 'package:flutter_template/data/repositories/auth_repository_impl.dart';
import 'package:flutter_template/data/repositories/movie_repository_impl.dart';
import 'package:flutter_template/domain/repositories/auth_repository.dart';
import 'package:flutter_template/domain/repositories/movie_repository.dart';
import 'package:flutter_template/domain/usecases/auth/get_profile_usecase.dart';
import 'package:flutter_template/domain/usecases/auth/login_usecase.dart';
import 'package:flutter_template/domain/usecases/auth/logout_usecase.dart';
import 'package:flutter_template/domain/usecases/auth/register_usecase.dart';
import 'package:flutter_template/domain/usecases/auth/update_profile_photo_usecase.dart';
import 'package:flutter_template/domain/usecases/movie/get_favorites_usecase.dart';
import 'package:flutter_template/domain/usecases/movie/get_movie_list_usecase.dart';
import 'package:flutter_template/domain/usecases/movie/toggle_favorite_usecase.dart';
import 'package:flutter_template/core/locale/locale_cubit.dart';
import 'package:flutter_template/core/theme/theme_cubit.dart';

/*
 * GetIt instance - Servis Bulucu (Service Locator)
 * Uygulamanın tüm bağımlılıklarını yöneten merkezi container.
 * 'sl' kısaltması convention olarak 'Service Locator'dan gelir.
 */
final sl = GetIt.instance;

/// [init] Fonksiyonu
/// ===========================
/// Uygulama başladığında tüm bağımlılık grafiğini (dependency graph) oluşturur.
///
/// KAYIT SIRASI KRİTİKTİR:
/// Bağımlılıklar aşağıdan yukarıya değil, en temelden en karmaşığa doğru kaydedilmelidir.
///
/// 1. [Firebase & External]: En dış katman, 3. parti servisler.
/// 2. [Core]: Loglama, Navigasyon, Error Handling gibi temel yapıtaşları.
/// 3. [Storage]: Veri saklama birimleri (Token, Theme, Locale).
/// 4. [Network]: API istemcisi (Dio).
/// 5. [Data Sources]: Veriye erişen ham sınıflar.
/// 6. [Repositories]: Veriyi işleyen ve Domain katmanına sunan sınıflar.
/// 7. [Use Cases]: İş mantığı (Business Logic) birimleri.
/// 8. [Presentation]: UI mantığı (Cubit/Bloc).
Future<void> init() async {
  /*
   * Firebase Services - İlk olarak kaydediliyor çünkü
   * diğer servisler (özellikle Logger ve ErrorHandler) bunlara depend ediyor
   */
  sl.registerLazySingleton<CrashlyticsService>(
    () => CrashlyticsService(FirebaseCrashlytics.instance),
  );

  sl.registerLazySingleton<AnalyticsService>(
    () => AnalyticsService(FirebaseAnalytics.instance),
  );

  /*
   * Logger Service - Crashlytics entegrasyonu için try-catch kullanılıyor
   * Eğer Crashlytics henüz hazır değilse uygulama çökmemeli
   *
   * verboseResponses: false - Response'lar kısaltılarak gösterilir (varsayılan)
   * verboseResponses: true - Tüm response'lar detaylı gösterilir
   */
  sl.registerLazySingleton<LoggerService>(() {
    final logger = LoggerService(
      // verboseResponses: true, // Detaylı loglar için
    );
    try {
      logger.setCrashlyticsService(sl<CrashlyticsService>());
    } catch (_) {
      // Crashlytics set edilemezse sessizce devam et
    }
    return logger;
  });

  sl.registerLazySingleton<NavigationService>(() => NavigationService());

  /*
   * Error Handler - NavigationService, LoggerService ve CrashlyticsService'e depend ediyor
   * sl() ile otomatik olarak resolve ediliyor (tip inference)
   */
  sl.registerLazySingleton<ErrorHandler>(() => ErrorHandler(sl(), sl(), sl()));

  /*
   * Storage Layer - FlutterSecureStorage token gibi hassas verileri şifreleyerek saklar
   * SharedPreferences'a göre daha güvenli
   */
  sl.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  sl.registerLazySingleton<TokenStorage>(() => TokenStorage(sl()));

  sl.registerLazySingleton<ThemeStorage>(() => ThemeStorage(sl()));

  sl.registerLazySingleton<LocaleStorage>(() => LocaleStorage(sl()));

  /*
   * Presentation Layer - Cubits
   * LazySingleton olarak kaydediliyor çünkü uygulama boyunca tek instance yeterli
   */
  sl.registerLazySingleton<ThemeCubit>(() => ThemeCubit(sl()));

  sl.registerLazySingleton<LocaleCubit>(() => LocaleCubit(sl()));

  /*
   * Network Layer
   * DioClient: Interceptors, headers, timeout vs. yapılandırılmış Dio wrapper
   * Dio instance: DioClient'tan alınıyor, data source'larda kullanılıyor
   */
  sl.registerLazySingleton<DioClient>(() => DioClient(sl(), sl()));

  sl.registerLazySingleton<Dio>(() => sl<DioClient>().dio);

  /*
   * ============================================================================
   * AUTH MODULE - Clean Architecture Layers
   * ============================================================================
   * Data Layer → Domain Layer → Use Cases
   */

  // Data Source: API çağrıları
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );

  // Repository: Data source'u domain'e bağlar
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl(), tokenStorage: sl()),
  );

  // Use Cases: Business logic
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => GetProfileUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProfilePhotoUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));

  /*
   * ============================================================================
   * MOVIE MODULE - Clean Architecture Layers
   * ============================================================================
   * Data Layer → Domain Layer → Use Cases
   */

  // Data Source: API çağrıları
  sl.registerLazySingleton<MovieRemoteDataSource>(
    () => MovieRemoteDataSourceImpl(sl()),
  );

  // Repository: Data source'u domain'e bağlar
  sl.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(remoteDataSource: sl()),
  );

  // Use Cases: Business logic
  sl.registerLazySingleton(() => GetMovieListUseCase(sl()));
  sl.registerLazySingleton(() => GetFavoritesUseCase(sl()));
  sl.registerLazySingleton(() => ToggleFavoriteUseCase(sl()));
}
