import 'package:flutter_template/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.name,
    super.profilePhotoUrl,
  });

  /*
   * Backend'in farklı endpoint'lerinde farklı field name'ler kullanması
   * durumu için fallback chain kullanıyoruz
   */
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      profilePhotoUrl:
          json['photoUrl'] ??
          json['profilePhotoUrl'] ??
          json['profile_photo_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'profilePhotoUrl': profilePhotoUrl,
    };
  }

  User toEntity() {
    return User(
      id: id,
      email: email,
      name: name,
      profilePhotoUrl: profilePhotoUrl,
    );
  }
}
