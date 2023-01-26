import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:responsible_student/modules/auth/auth_service/models/user_entity.dart';
import 'package:responsible_student/modules/auth/auth_service/service/auth_service.dart';
import 'package:responsible_student/modules/tasks/models/task.dart';
import 'package:rxdart/rxdart.dart';

part 'user_data_event.dart';
part 'user_data_state.dart';

class UserDataBloc extends HydratedBloc<UserDataEvent, UserDataState> {
  UserDataBloc(this._authService)
      : super(UserDataState(
            entity: UserEntity.empty(), tasks: const <String, Task>{})) {
    on<UserDataAddTasksEvent>(_onUserDataAddTasksEvent);
    on<UserDataLoggedInEvent>(_onUserDataLoggedInEvent);
    on<UserDataLoggedOutEvent>(_onUserDataLoggedOutEvent);
    on<UserDataUpdateTasksEvent>(_onUserDataUpdateTasksEvent);
    on<UserDataAddOrUpdateTask>(_onUserDataAddOrUpdateTask);
    on<UserDataDeleteTask>(_onUserDataDeleteTask);

    on<UserDataSetShouldLogInEvent>((event, emit) {
      emit(state.copyWith(shouldBeLoggedIn: true));
    });
    on<UserDataSetShouldNotLogInEvent>((event, emit) {
      emit(state.copyWith(shouldBeLoggedIn: false));
    });

    print('Constructor was called');
    emit(state.copyWith(entity: _authService.getCurrentUser()));
  }
  final AuthService _authService;
  _onUserDataAddTasksEvent(
      UserDataAddTasksEvent event, Emitter<UserDataState> emit) {
    var newMap = Map<String, Task>.of(state.tasks);
    print('_onUserDataAddTasksEvent');

    for (var item in event.tasks) {
      if (!newMap.containsKey(item.id)) {
        newMap[item.id] = item;
        print('Added item to items');
        print(item);
      }
    }
    print('Old map count');
    print(state.tasks.entries.length);
    print('New items map count');
    print(newMap.entries.length);
    emit(state.copyWith(tasks: newMap));
  }

  _onUserDataLoggedInEvent(
      UserDataLoggedInEvent event, Emitter<UserDataState> emit) {
    emit(state.copyWith(
        entity: _authService.getCurrentUser(),
        isLoggedIn: true,
        shouldBeLoggedIn: true));
  }

  _onUserDataLoggedOutEvent(
      UserDataLoggedOutEvent event, Emitter<UserDataState> emit) {
    _authService.signOut();
    emit(state.copyWith(
        entity: _authService.getCurrentUser(), isLoggedIn: false));
  }

  _onUserDataUpdateTasksEvent(
      UserDataUpdateTasksEvent event, Emitter<UserDataState> emit) {
    emit(state.copyWith(
        entity: _authService.getCurrentUser(), isLoggedIn: true));
  }

  _onUserDataAddOrUpdateTask(
      UserDataAddOrUpdateTask event, Emitter<UserDataState> emit) {
    print('Add or update task');
    var newMap = Map<String, Task>.of(state.tasks);

    if (newMap.containsKey(event.task.id)) {
      newMap.update(event.task.id, (value) => event.task);
    } else {
      newMap[event.task.id] = event.task;
    }
    emit(state.copyWith(tasks: newMap));
  }

  _onUserDataDeleteTask(UserDataDeleteTask event, Emitter<UserDataState> emit) {
    var newMap = Map<String, Task>.of(state.tasks);

    newMap.remove(event.task.id);
    emit(state.copyWith(tasks: newMap));
  }

  @override
  UserDataState? fromJson(Map<String, dynamic> json) {
    UserEntity entity = UserEntity.fromJson(json['userEntity']);
    Map<String, dynamic> tasksString = json['tasks'];
    Map<String, Task> taskMap = tasksString
        .map((key, value) => MapEntry<String, Task>(key, Task.fromJson(value)));
    UserDataState newState = UserDataState(
        entity: entity,
        tasks: taskMap,
        isLoggedIn: json['isLoggedIn'] as bool,
        shouldBeLoggedIn: json['shouldBeLoggedIn'] as bool,
        status: UserDataStatus.notInitialized);
    return newState;
  }

  @override
  Map<String, dynamic>? toJson(UserDataState state) {
    return {
      'userEntity': state.entity,
      'tasks': state.tasks,
      'isLoggedIn': state.isLoggedIn,
      'shouldBeLoggedIn': state.shouldBeLoggedIn
    };
  }
}
