enum ErrorType {
  authentication,
  network,
  server,
  client,
  validation,
  unknown,
}

extension ErrorTypeExtension on ErrorType {
  bool get shouldNavigateToLogin => this == ErrorType.authentication;

  bool get shouldShowSnackBar => this != ErrorType.authentication;

  String get defaultMessage {
    switch (this) {
      case ErrorType.authentication:
        return 'Oturumunuz sonlandı. Lütfen tekrar giriş yapın.';
      case ErrorType.network:
        return 'İnternet bağlantınızı kontrol edin.';
      case ErrorType.server:
        return 'Sunucu hatası. Lütfen daha sonra tekrar deneyin.';
      case ErrorType.client:
        return 'İstek işlenirken bir hata oluştu.';
      case ErrorType.validation:
        return 'Lütfen girdiğiniz bilgileri kontrol edin.';
      case ErrorType.unknown:
        return 'Beklenmeyen bir hata oluştu.';
    }
  }
}

/*
 * Hata mesajının içeriğine bakarak ErrorType belirler.
 * Bu sayede API'den gelen hata mesajları otomatik olarak kategorize edilir.
 */
ErrorType getErrorTypeFromMessage(String errorMessage) {
  final lowerMessage = errorMessage.toLowerCase();

  if (lowerMessage.contains('token') ||
      lowerMessage.contains('unauthorized') ||
      lowerMessage.contains('authentication') ||
      lowerMessage.contains('401') ||
      lowerMessage.contains('oturum')) {
    return ErrorType.authentication;
  }

  if (lowerMessage.contains('network') ||
      lowerMessage.contains('internet') ||
      lowerMessage.contains('connection') ||
      lowerMessage.contains('timeout') ||
      lowerMessage.contains('bağlantı')) {
    return ErrorType.network;
  }

  if (lowerMessage.contains('server') ||
      lowerMessage.contains('500') ||
      lowerMessage.contains('503') ||
      lowerMessage.contains('sunucu')) {
    return ErrorType.server;
  }

  if (lowerMessage.contains('validation') ||
      lowerMessage.contains('invalid') ||
      lowerMessage.contains('geçersiz') ||
      lowerMessage.contains('required') ||
      lowerMessage.contains('zorunlu')) {
    return ErrorType.validation;
  }

  return ErrorType.unknown;
}
