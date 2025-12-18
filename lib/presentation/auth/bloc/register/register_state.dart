part of 'register_bloc.dart';

enum RegisterStatus { initial, loading, success, failure }

class RegisterState extends Equatable {
  final RegisterStatus status;
  final String email;
  final String name;
  final String password;
  final String? errorMessage;
  final bool isEmailValid;
  final bool isNameValid;
  final bool isPasswordValid;

  const RegisterState({
    this.status = RegisterStatus.initial,
    this.email = '',
    this.name = '',
    this.password = '',
    this.errorMessage,
    this.isEmailValid = true,
    this.isNameValid = true,
    this.isPasswordValid = true,
  });

  RegisterState copyWith({
    RegisterStatus? status,
    String? email,
    String? name,
    String? password,
    String? errorMessage,
    bool? isEmailValid,
    bool? isNameValid,
    bool? isPasswordValid,
  }) {
    return RegisterState(
      status: status ?? this.status,
      email: email ?? this.email,
      name: name ?? this.name,
      password: password ?? this.password,
      errorMessage: errorMessage,
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isNameValid: isNameValid ?? this.isNameValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
    );
  }

  bool get isFormValid =>
      isEmailValid &&
      isNameValid &&
      isPasswordValid &&
      email.isNotEmpty &&
      name.isNotEmpty &&
      password.isNotEmpty;

  @override
  List<Object?> get props => [
        status,
        email,
        name,
        password,
        errorMessage,
        isEmailValid,
        isNameValid,
        isPasswordValid,
      ];
}
