import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsible_student/modules/auth/auth_service/service/auth_service.dart';
part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc({
    required AuthService authService,
  })  : _authService = authService,
        super(const SignupState()) {
    on<SignupButtonPressedEvent>(_handleCreateAccountEvent);
    on<SignupEmailChangedEvent>(_handleSignupEmailChangedEvent);
    on<SignupPasswordChangedEvent>(_handleSignupPasswordChangedEvent);
  }

  final AuthService _authService;

  Future<void> _handleSignupEmailChangedEvent(
    SignupEmailChangedEvent event,
    Emitter<SignupState> emit,
  ) async {
    emit(state.copyWith(email: event.email));
  }

  Future<void> _handleSignupPasswordChangedEvent(
    SignupPasswordChangedEvent event,
    Emitter<SignupState> emit,
  ) async {
    emit(state.copyWith(password: event.password));
  }

  Future<void> _handleCreateAccountEvent(
    SignupButtonPressedEvent event,
    Emitter<SignupState> emit,
  ) async {
    try {
      await _authService.createUserWithEmailAndPassword(
        email: state.email,
        password: state.password,
      );
      emit(state.copyWith(status: SignupStatus.success));
    } catch (e) {
      emit(state.copyWith(message: e.toString(), status: SignupStatus.failure));
    }
  }
}
