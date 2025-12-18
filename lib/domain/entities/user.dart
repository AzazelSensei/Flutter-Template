import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? profilePhotoUrl;

  const User({
    required this.id,
    required this.email,
    required this.name,
    this.profilePhotoUrl,
  });

  @override
  List<Object?> get props => [id, email, name, profilePhotoUrl];
}
