import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/domain/usecases/auth/login_usecase.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase loginUseCase;

  LoginBloc({required this.loginUseCase}) : super(const LoginState()) {
    on<LoginEmailChanged>(_onEmailChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onSubmitted);
  }

  void _onEmailChanged(LoginEmailChanged event, Emitter<LoginState> emit) {
    final isValid = _isEmailValid(event.email);
    emit(state.copyWith(
      email: event.email,
      isEmailValid: isValid,
      errorMessage: null,
    ));
  }

  void _onPasswordChanged(
      LoginPasswordChanged event, Emitter<LoginState> emit) {
    final isValid = event.password.length >= 6;
    emit(state.copyWith(
      password: event.password,
      isPasswordValid: isValid,
      errorMessage: null,
    ));
  }

  Future<void> _onSubmitted(
      LoginSubmitted event, Emitter<LoginState> emit) async {
    try {
      if (!state.isFormValid) return;

      emit(state.copyWith(status: LoginStatus.loading));

      final result = await loginUseCase(
        LoginParams(email: event.email, password: event.password),
      );

      result.fold(
        (failure) => emit(state.copyWith(
          status: LoginStatus.failure,
          errorMessage: failure.message,
        )),
        (token) => emit(state.copyWith(status: LoginStatus.success)),
      );
    } catch (e) {
      emit(state.copyWith(
        status: LoginStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  /*
   * Email validation regex - basit format kontrolü
   * Production'da daha strict validation gerekebilir
   */
  bool _isEmailValid(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }
}
