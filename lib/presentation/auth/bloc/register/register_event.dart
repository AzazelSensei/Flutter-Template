part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class RegisterSubmitted extends RegisterEvent {
  final String email;
  final String name;
  final String password;

  const RegisterSubmitted({
    required this.email,
    required this.name,
    required this.password,
  });

  @override
  List<Object> get props => [email, name, password];
}

class RegisterEmailChanged extends RegisterEvent {
  final String email;

  const RegisterEmailChanged(this.email);

  @override
  List<Object> get props => [email];
}

class RegisterNameChanged extends RegisterEvent {
  final String name;

  const RegisterNameChanged(this.name);

  @override
  List<Object> get props => [name];
}

class RegisterPasswordChanged extends RegisterEvent {
  final String password;

  const RegisterPasswordChanged(this.password);

  @override
  List<Object> get props => [password];
}
