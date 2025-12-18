import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/domain/usecases/auth/register_usecase.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterUseCase registerUseCase;

  RegisterBloc({required this.registerUseCase}) : super(const RegisterState()) {
    on<RegisterEmailChanged>(_onEmailChanged);
    on<RegisterNameChanged>(_onNameChanged);
    on<RegisterPasswordChanged>(_onPasswordChanged);
    on<RegisterSubmitted>(_onSubmitted);
  }

  void _onEmailChanged(RegisterEmailChanged event, Emitter<RegisterState> emit) {
    final isValid = _isEmailValid(event.email);
    emit(state.copyWith(
      email: event.email,
      isEmailValid: isValid,
      errorMessage: null,
    ));
  }

  void _onNameChanged(RegisterNameChanged event, Emitter<RegisterState> emit) {
    final isValid = event.name.length >= 2;
    emit(state.copyWith(
      name: event.name,
      isNameValid: isValid,
      errorMessage: null,
    ));
  }

  void _onPasswordChanged(
      RegisterPasswordChanged event, Emitter<RegisterState> emit) {
    final isValid = event.password.length >= 6;
    emit(state.copyWith(
      password: event.password,
      isPasswordValid: isValid,
      errorMessage: null,
    ));
  }

  Future<void> _onSubmitted(
      RegisterSubmitted event, Emitter<RegisterState> emit) async {
    try {
      if (!state.isFormValid) return;

      emit(state.copyWith(status: RegisterStatus.loading));

      final result = await registerUseCase(
        RegisterParams(
          email: event.email,
          name: event.name,
          password: event.password,
        ),
      );

      result.fold(
        (failure) => emit(state.copyWith(
          status: RegisterStatus.failure,
          errorMessage: failure.message,
        )),
        (token) => emit(state.copyWith(status: RegisterStatus.success)),
      );
    } catch (e) {
      emit(state.copyWith(
        status: RegisterStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  bool _isEmailValid(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }
}
