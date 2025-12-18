import 'package:dartz/dartz.dart';
import 'package:flutter_template/core/error/failures.dart';

/*
 * Clean Architecture Use Case Pattern
 *
 * Either<Failure, Type>:
 * - Left: Hata durumu (Failure)
 * - Right: Başarı durumu (Type)
 *
 * Bu pattern sayede exception throwing yerine functional error handling kullanıyoruz
 */
/// [UseCase], Clean Architecture'ın Domain katmanındaki iş mantığı birimlerini temsil eder.
/// Her bir UseCase, uygulamanın tek bir özelliğini veya aksiyonunu (örneğin: Login, GetMovies)
/// gerçekleştirmekten sorumludur.
///
/// [Type]: UseCase'in başarılı durumda döndüreceği verinin tipi.
/// [Params]: UseCase çalıştırılırken gereken parametre sınıfı. (Parametre yoksa [NoParams] kullanılır)
abstract class UseCase<Type, Params> {
  /// UseCase'in tetikleyici fonksiyonu.
  /// [Either] yapısı sayesinde hata ([Failure]) veya başarı ([Type]) döner.
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams {}
