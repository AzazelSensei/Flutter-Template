import 'package:flutter/material.dart';
import 'package:flutter_template/core/error/error_type.dart';
import 'package:flutter_template/core/firebase/crashlytics_service.dart';
import 'package:flutter_template/core/logging/logger_service.dart';
import 'package:flutter_template/core/navigation/navigation_service.dart';
import 'package:flutter_template/core/theme/app_colors.dart';
import 'package:flutter_template/presentation/auth/view/login_page_new.dart';

class ErrorHandler {
  final NavigationService _navigationService;
  final LoggerService _logger;
  final CrashlyticsService _crashlytics;

  ErrorHandler(this._navigationService, this._logger, this._crashlytics);

  void handleError(
    String? errorMessage, {
    BuildContext? context,
    ErrorType? errorType,
    VoidCallback? onRetry,
    Object? error,
    StackTrace? stackTrace,
  }) {
    final message = errorMessage ?? 'Beklenmeyen bir hata oluştu';
    final type = errorType ?? getErrorTypeFromMessage(message);

    _logError(message, type, error, stackTrace);

    if (type.shouldNavigateToLogin) {
      _handleAuthenticationError(context);
      return;
    }

    if (type.shouldShowSnackBar) {
      _showErrorSnackBar(
        context,
        message.isEmpty ? type.defaultMessage : message,
        onRetry: onRetry,
      );
    }
  }

  void _logError(
    String message,
    ErrorType type,
    Object? error,
    StackTrace? stackTrace,
  ) {
    switch (type) {
      case ErrorType.authentication:
        _logger.warning(
          message,
          tag: 'AUTH',
          error: error,
          stackTrace: stackTrace,
        );
        break;
      case ErrorType.network:
        _logger.error(
          message,
          tag: 'NETWORK',
          error: error,
          stackTrace: stackTrace,
        );
        if (error != null && stackTrace != null) {
          _crashlytics.logException(error, stackTrace, reason: message);
        }
        break;
      case ErrorType.server:
        _logger.error(
          message,
          tag: 'SERVER',
          error: error,
          stackTrace: stackTrace,
        );
        /*
         * Server hataları kritik olduğu için Crashlytics'e de logluyoruz.
         * Bu sayede production'daki API sorunlarını takip edebiliriz.
         */
        if (error != null && stackTrace != null) {
          _crashlytics.logException(error, stackTrace, reason: message);
        }
        break;
      case ErrorType.validation:
        _logger.warning(
          message,
          tag: 'VALIDATION',
          error: error,
        );
        break;
      case ErrorType.client:
        _logger.error(
          message,
          tag: 'CLIENT',
          error: error,
          stackTrace: stackTrace,
        );
        if (error != null && stackTrace != null) {
          _crashlytics.logException(error, stackTrace, reason: message);
        }
        break;
      case ErrorType.unknown:
        _logger.error(
          message,
          tag: 'UNKNOWN',
          error: error,
          stackTrace: stackTrace,
        );
        /*
         * Bilinmeyen hatalar için Crashlytics'e loglama yapıyoruz.
         * Bu hatalar genellikle beklenmeyen durumları gösterir.
         */
        if (error != null && stackTrace != null) {
          _crashlytics.logException(error, stackTrace, reason: message);
        }
        break;
    }
  }

  void _handleAuthenticationError(BuildContext? context) {
    _logger.info('Login sayfasına yönlendiriliyor (authentication hatası)', tag: 'AUTH');

    /*
     * NOT: Authentication hatalarında kullanıcıyı login sayfasına yönlendiriyoruz.
     * Öncelikle verilen context kullanılır, eğer yoksa NavigationService kullanılır.
     * Bu sayede her durumda güvenli bir şekilde yönlendirme yapılabilir.
     */
    if (context != null && context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginPageNew()),
        (route) => false,
      );
    } else {
      _navigationService.navigateToAndClearStack(const LoginPageNew());
    }
  }

  void _showErrorSnackBar(
    BuildContext? context,
    String message, {
    VoidCallback? onRetry,
  }) {
    final targetContext = context ?? _navigationService.context;

    if (targetContext == null || !targetContext.mounted) return;

    final messenger = ScaffoldMessenger.of(targetContext);

    /*
     * Yeni SnackBar göstermeden önce mevcut olanları temizliyoruz.
     * Bu sayede üst üste SnackBar birikmesini önlüyoruz.
     */
    messenger.clearSnackBars();

    messenger.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
        action: onRetry != null
            ? SnackBarAction(
                label: 'Tekrar Dene',
                textColor: Colors.white,
                onPressed: onRetry,
              )
            : null,
      ),
    );
  }

  void handleNetworkError({
    BuildContext? context,
    VoidCallback? onRetry,
  }) {
    handleError(
      ErrorType.network.defaultMessage,
      context: context,
      errorType: ErrorType.network,
      onRetry: onRetry,
    );
  }

  void handleServerError({
    BuildContext? context,
    String? message,
    VoidCallback? onRetry,
  }) {
    handleError(
      message ?? ErrorType.server.defaultMessage,
      context: context,
      errorType: ErrorType.server,
      onRetry: onRetry,
    );
  }

  void handleValidationError({
    BuildContext? context,
    required String message,
  }) {
    handleError(
      message,
      context: context,
      errorType: ErrorType.validation,
    );
  }

  void showSuccess(
    String message, {
    BuildContext? context,
  }) {
    _logger.info(message, tag: 'SUCCESS');

    final targetContext = context ?? _navigationService.context;

    if (targetContext == null || !targetContext.mounted) return;

    final messenger = ScaffoldMessenger.of(targetContext);

    messenger.clearSnackBars();

    messenger.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void showInfo(
    String message, {
    BuildContext? context,
  }) {
    final targetContext = context ?? _navigationService.context;

    if (targetContext == null || !targetContext.mounted) return;

    final messenger = ScaffoldMessenger.of(targetContext);

    messenger.clearSnackBars();

    messenger.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.info,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
