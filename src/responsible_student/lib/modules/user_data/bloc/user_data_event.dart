part of 'user_data_bloc.dart';

abstract class UserDataEvent {
  const UserDataEvent();
}

class UserDataLoggedInEvent extends UserDataEvent {
  const UserDataLoggedInEvent();
}

class UserDataLoggedOutEvent extends UserDataEvent {
  const UserDataLoggedOutEvent();
}

// Tasks provided are added to current tasks
class UserDataAddTasksEvent extends UserDataEvent {
  final List<Task> tasks;
  const UserDataAddTasksEvent(this.tasks);
}

// All tasks are set to tasks provided
class UserDataUpdateTasksEvent extends UserDataEvent {
  final List<Task> tasks;
  const UserDataUpdateTasksEvent(this.tasks);
}

class UserDataSetShouldLogInEvent extends UserDataEvent {
  const UserDataSetShouldLogInEvent();
}

class UserDataSetShouldNotLogInEvent extends UserDataEvent {
  const UserDataSetShouldNotLogInEvent();
}
