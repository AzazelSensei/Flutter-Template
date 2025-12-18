part of 'login_bloc.dart';

enum LoginStatus { initial, loading, success, failure }

class LoginState extends Equatable {
  final LoginStatus status;
  final String email;
  final String password;
  final String? errorMessage;
  final bool isEmailValid;
  final bool isPasswordValid;

  const LoginState({
    this.status = LoginStatus.initial,
    this.email = '',
    this.password = '',
    this.errorMessage,
    this.isEmailValid = true,
    this.isPasswordValid = true,
  });

  LoginState copyWith({
    LoginStatus? status,
    String? email,
    String? password,
    String? errorMessage,
    bool? isEmailValid,
    bool? isPasswordValid,
  }) {
    return LoginState(
      status: status ?? this.status,
      email: email ?? this.email,
      password: password ?? this.password,
      errorMessage: errorMessage,
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
    );
  }

  bool get isFormValid => isEmailValid && isPasswordValid && email.isNotEmpty && password.isNotEmpty;

  @override
  List<Object?> get props => [
        status,
        email,
        password,
        errorMessage,
        isEmailValid,
        isPasswordValid,
      ];
}
