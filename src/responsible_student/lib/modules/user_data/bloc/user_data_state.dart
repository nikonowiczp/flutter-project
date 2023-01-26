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
  final Map<String, Task> tasks;
  final bool isLoggedIn;
  final bool shouldBeLoggedIn;
  final UserDataStatus status;
  const UserDataState(
      {required this.entity,
      required this.tasks,
      this.shouldBeLoggedIn = true,
      this.isLoggedIn = false,
      this.status = UserDataStatus.notInitialized});

  @override
  List<Object?> get props => [entity, tasks, isLoggedIn, status];

  UserDataState copyWith({
    UserEntity? entity,
    Map<String, Task>? tasks,
    bool? isLoggedIn,
    bool? shouldBeLoggedIn,
    UserDataStatus? status,
  }) {
    return UserDataState(
      entity: entity ?? this.entity,
      tasks: tasks ?? this.tasks,
      shouldBeLoggedIn: shouldBeLoggedIn ?? this.shouldBeLoggedIn,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      status: status ?? this.status,
    );
  }
}
