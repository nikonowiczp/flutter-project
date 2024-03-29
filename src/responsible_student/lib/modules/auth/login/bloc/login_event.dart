part of 'login_bloc.dart';

@immutable
abstract class LoginEvent extends Equatable {
  const LoginEvent();
  @override
  List<Object?> get props => [];
}

class LoginButtonPressedEvent extends LoginEvent {
  const LoginButtonPressedEvent();
}

class LoginEmailChangedEvent extends LoginEvent {
  const LoginEmailChangedEvent({required this.email});

  final String email;

  @override
  List<Object> get props => [email];
}

class LoginPasswordChangedEvent extends LoginEvent {
  const LoginPasswordChangedEvent({required this.password});

  final String password;

  @override
  List<Object> get props => [password];
}

class LoggedOutEvent extends LoginEvent {
  const LoggedOutEvent();
}

class LoginWithGmailEvent extends LoginEvent {}

class LoginWithFacebookEvent extends LoginEvent {}

class ClearErrorEvent extends LoginEvent {}
