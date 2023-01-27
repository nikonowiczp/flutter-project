// ignore_for_file: depend_on_referenced_packages

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:responsible_student/modules/auth/auth_service/service/auth_service.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({required AuthService authService})
      : _authService = authService,
        super(const LoginState()) {
    on<LoginButtonPressedEvent>(_handleLoginWithEmailAndPasswordEvent);
    on<LoginEmailChangedEvent>(_handleLoginEmailChangedEvent);
    on<LoginPasswordChangedEvent>(_handleLoginPasswordChangedEvent);
    on<LoggedOutEvent>(_handleLoggedOutEvent);
    on<LoginWithGmailEvent>(_handleLoginWithGmail);
    on<LoginWithFacebookEvent>(_onLoginWithFacebookEvent);
    on<ClearErrorEvent>(_onClearErrorEvent);
  }
  late StreamSubscription authServiceBlocSubscription;

  final AuthService _authService;

  Future<void> _handleLoggedOutEvent(
    LoggedOutEvent event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(
      message: '',
      status: LoginStatus.loading,
      email: '',
      password: '',
    ));
  }

  Future<void> _handleLoginEmailChangedEvent(
    LoginEmailChangedEvent event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(email: event.email));
  }

  Future<void> _handleLoginPasswordChangedEvent(
    LoginPasswordChangedEvent event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(password: event.password));
  }

  Future<void> _handleLoginWithEmailAndPasswordEvent(
    LoginButtonPressedEvent event,
    Emitter<LoginState> emit,
  ) async {
    try {
      await _authService.signInWithEmailAndPassword(
        email: state.email,
        password: state.password,
      );
      emit(state.copyWith(message: 'Success', status: LoginStatus.success));
    } catch (e) {
      emit(state.copyWith(message: e.toString(), status: LoginStatus.failure));
    }
  }

  Future<void> _handleLoginWithGmail(
      LoginWithGmailEvent event, Emitter<LoginState> emit) async {
    try {
      var credential = await _authService.signInWithGoogle();
      emit(state.copyWith(message: 'Success', status: LoginStatus.success));
    } catch (e) {
      print('Login with gmail error');
      print(e);
      emit(state.copyWith(message: e.toString(), status: LoginStatus.failure));
    }
  }

  Future<void> _onLoginWithFacebookEvent(
      LoginWithFacebookEvent event, Emitter<LoginState> emit) async {
    try {
      var credential = await _authService.signInWithFacebook();
      emit(state.copyWith(message: 'Success', status: LoginStatus.success));
    } catch (e) {
      print('Login with facebook error');
      print(e);
      emit(state.copyWith(message: e.toString(), status: LoginStatus.failure));
    }
  }

  _onClearErrorEvent(ClearErrorEvent event, Emitter<LoginState> emit) {
    emit(state.copyWith(message: ''));
  }
}
