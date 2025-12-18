import 'package:equatable/equatable.dart';

/// [Failure]
/// Uygulama genelindeki tüm hataların türetildiği temel abstract sınıf.
/// [Equatable] kullanarak hata karşılaştırmalarını (equality checks) kolaylaştırır.
///
/// Hata yönetimi sırasında exception fırlatmak yerine (try-catch blokları),
/// bu sınıfları return ederek fonksiyonel bir akış sağlarız.
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

/// API veya sunucu kaynaklı hatalar (500, 404 vb.).
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

/// Yerel veri okuma/yazma hataları.
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

/// İnternet bağlantısı yok veya timeout hataları.
class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

/// Yetkilendirme hataları (401, Token expired).
class AuthenticationFailure extends Failure {
  const AuthenticationFailure(super.message);
}

/// Girdi doğrulama ve validasyon hataları.
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}
