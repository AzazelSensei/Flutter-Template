import 'package:dio/dio.dart';
import 'package:flutter_template/core/constants/api_constants.dart';
import 'package:flutter_template/data/models/user_model.dart';
import 'package:flutter_template/data/models/responses/api_error.dart';

abstract class AuthRemoteDataSource {
  Future<String> login({required String email, required String password});
  Future<String> register({
    required String email,
    required String name,
    required String password,
  });
  Future<UserModel> getProfile();
  Future<UserModel> updateProfilePhoto(String photoPath);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl(this.dio);

  @override
  Future<String> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        ApiConstants.login,
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data['data'];
        final token = data['token'] as String;
        return token;
      } else {
        throw Exception('Login failed: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      try {
        if (e.response?.data != null) {
          final apiError = ApiError.fromJson(e.response!.data);
          throw Exception(_translateErrorMessage(apiError.message));
        }
      } catch (_) {}

      throw Exception('Giriş işlemi başarısız oldu');
    }
  }

  @override
  Future<String> register({
    required String email,
    required String name,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        ApiConstants.register,
        data: {'email': email, 'name': name, 'password': password},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data['data'];
        final token = data['token'] as String;
        return token;
      } else {
        throw Exception('Registration failed: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      try {
        if (e.response?.data != null) {
          final apiError = ApiError.fromJson(e.response!.data);
          throw Exception(_translateErrorMessage(apiError.message));
        }
      } catch (_) {}

      throw Exception('Kayıt işlemi başarısız oldu');
    }
  }

  @override
  Future<UserModel> getProfile() async {
    try {
      final response = await dio.get(ApiConstants.profile);

      if (response.statusCode == 200) {
        final userData = response.data['data'] ?? response.data;
        return UserModel.fromJson(userData);
      } else {
        throw Exception('Failed to get profile: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      try {
        if (e.response?.data != null) {
          final apiError = ApiError.fromJson(e.response!.data);
          throw Exception(_translateErrorMessage(apiError.message));
        }
      } catch (_) {}

      throw Exception('Profil bilgileri alınamadı');
    }
  }

  @override
  Future<UserModel> updateProfilePhoto(String photoPath) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(photoPath),
      });

      final response = await dio.post(ApiConstants.uploadPhoto, data: formData);

      /*
       * NOT: Upload başarılı olduktan sonra güncel profile'ı tekrar çekiyoruz.
       * Upload response'unda tam user bilgisi dönmediği için bu gerekli.
       */
      if (response.statusCode == 200) {
        final profileResponse = await dio.get(ApiConstants.profile);
        if (profileResponse.statusCode == 200) {
          final userData = profileResponse.data['data'] ?? profileResponse.data;
          return UserModel.fromJson(userData);
        } else {
          throw Exception('Failed to get updated profile');
        }
      } else {
        throw Exception(
          'Failed to update profile photo: ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      try {
        if (e.response?.data != null) {
          final apiError = ApiError.fromJson(e.response!.data);
          throw Exception(_translateErrorMessage(apiError.message));
        }
      } catch (_) {}

      throw Exception('Profil fotoğrafı güncellenemedi');
    }
  }

  /*
   * Backend'den gelen İngilizce error code'ları kullanıcı dostu Türkçe mesajlara çeviriliyor
   * Böylece kullanıcı deneyimi iyileştiriliyor
   */
  String _translateErrorMessage(String errorMessage) {
    if (errorMessage == 'USER_EXISTS') {
      return 'Bu e-posta adresi zaten kullanımda';
    }
    if (errorMessage == 'USER_NOT_FOUND' ||
        errorMessage == 'INVALID_CREDENTIALS') {
      return 'E-posta veya şifre hatalı';
    }
    if (errorMessage.toLowerCase().contains('email')) {
      return 'Geçersiz e-posta adresi';
    }
    if (errorMessage.toLowerCase().contains('password')) {
      return 'Şifre hatalı';
    }
    if (errorMessage.toLowerCase().contains('unauthorized')) {
      return 'Oturum süreniz dolmuş, lütfen tekrar giriş yapın';
    }
    return errorMessage;
  }
}
