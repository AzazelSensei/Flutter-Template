import 'package:dio/dio.dart';
import 'package:flutter_template/core/logging/logger_service.dart';

/// Dio interceptor for logging HTTP requests and responses
class LoggingInterceptor extends Interceptor {
  final LoggerService _logger;

  LoggingInterceptor(this._logger);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    /*
     * Request duration ölçümü için Stopwatch başlatıyoruz
     * extra map'e koyarak response'da tekrar erişebiliyoruz
     */
    final stopwatch = Stopwatch()..start();
    options.extra['stopwatch'] = stopwatch;

    _logger.logRequest(
      method: options.method,
      url: options.uri.toString(),
      headers: options.headers,
      data: options.data,
    );

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final stopwatch = response.requestOptions.extra['stopwatch'] as Stopwatch?;
    stopwatch?.stop();

    _logger.logResponse(
      statusCode: response.statusCode ?? 0,
      url: response.requestOptions.uri.toString(),
      data: response.data,
      duration: stopwatch?.elapsed,
    );

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _logger.logNetworkError(
      url: err.requestOptions.uri.toString(),
      error: err,
      stackTrace: err.stackTrace,
    );

    handler.next(err);
  }
}
