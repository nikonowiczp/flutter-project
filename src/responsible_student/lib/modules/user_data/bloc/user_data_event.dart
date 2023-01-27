part of 'user_data_bloc.dart';

abstract class UserDataEvent {
  const UserDataEvent();
}

class UserDataLoggedInEvent extends UserDataEvent {
  final bool synchronize;
  const UserDataLoggedInEvent(this.synchronize);
}

class UserDataLoggedOutEvent extends UserDataEvent {
  const UserDataLoggedOutEvent();
}

class UserDataSetShouldLogInEvent extends UserDataEvent {
  const UserDataSetShouldLogInEvent();
}

class UserDataSetShouldNotLogInEvent extends UserDataEvent {
  const UserDataSetShouldNotLogInEvent();
}

class UserDataAddOrUpdateTask extends UserDataEvent {
  final Task task;

  UserDataAddOrUpdateTask(this.task);
}

class UserDataDeleteTask extends UserDataEvent {
  final Task task;

  UserDataDeleteTask(this.task);
}

class UserDataSynchronize extends UserDataEvent {
  final bool deleteLocal;
  final Task? deletedTask;
  final Map<String, Task>? newMap;
  UserDataSynchronize(
      {this.deleteLocal = false, this.deletedTask, this.newMap});
}
