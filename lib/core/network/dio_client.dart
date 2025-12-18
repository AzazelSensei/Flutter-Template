import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';
import 'package:flutter_template/core/constants/app_constants.dart';
import 'package:flutter_template/core/logging/logger_service.dart';
import 'package:flutter_template/core/network/logging_interceptor.dart';
import 'package:flutter_template/core/storage/token_storage.dart';

/*
 * NOT: HTTP Client Wrapper (Dio)
 *
 * Merkezi network konfigürasyonu:
 * - Base URL ve timeout ayarları
 * - Otomatik token enjeksiyonu
 * - Request/Response logging
 * - 401 otomatik logout mekanizması
 */
/// [DioClient], uygulama genelinde HTTP isteklerini yöneten merkezi sınıftır.
/// [Dio] kütüphanesi üzerine inşa edilmiştir ve temel konfigürasyonları (Base URL, Timeout vb.)
/// içerir.
///
/// Singleton veya Factory olarak DI container üzerinden erişilmesi önerilir.
class DioClient {
  final Dio _dio;
  final TokenStorage _tokenStorage;
  final LoggerService _logger;

  /*
   * Constructor'da initialization list kullanarak Dio instance'ı oluşturuyoruz.
   * Bu sayede _dio final olabilir ve body içinde interceptor'ları ekleyebiliriz.
   */
  DioClient(this._tokenStorage, this._logger)
    : _dio = Dio(
        BaseOptions(
          baseUrl: dotenv.env['BASE_URL'] ?? 'https://default.api.com',
          connectTimeout: AppConstants.connectionTimeout,
          receiveTimeout: AppConstants.receiveTimeout,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      ) {
    /*
     * INTERCEPTOR 1: Logging
     * Her request ve response loglanır (development'ta debug için)
     */
    _dio.interceptors.add(LoggingInterceptor(_logger));

    /*
     * INTERCEPTOR 2: Authentication & Error Handling
     *
     * onRequest: Her istekten önce token'ı otomatik olarak ekler
     * - Storage'dan token çeker
     * - Bearer Authentication header'ı olarak ekler
     * - Manuel olarak her API çağrısında token eklemek zorunda kalmayız
     *
     * onError: Hata durumlarını handle eder
     * - 401 (Unauthorized): Token geçersiz/süresi dolmuş demektir
     * - Otomatik olarak token'ı siler
     * - Kullanıcı error handler tarafından login sayfasına yönlendirilir
     */
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _tokenStorage.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            _logger.warning('Unauthorized request - clearing token');
            await _tokenStorage.deleteToken();
          }
          return handler.next(error);
        },
      ),
    );
  }

  Dio get dio => _dio;
}
