part of 'user_data_bloc.dart';

enum UserDataStatus {
  notInitialized,
  awaitingLogIn,
  awaitingLogOut,
  loadedNotLoggedIn,
  loadedLoggedIn
}

class UserDataState extends Equatable {
  final UserEntity entity;
  final List<Task> tasks;
  final bool isLoggedIn;
  final UserDataStatus status;
  const UserDataState(
      {required this.entity,
      required this.tasks,
      this.isLoggedIn = false,
      this.status = UserDataStatus.notInitialized});

  @override
  List<Object?> get props => [entity, tasks, isLoggedIn, status];
}
