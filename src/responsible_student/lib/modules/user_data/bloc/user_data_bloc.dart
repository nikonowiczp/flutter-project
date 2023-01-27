import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:responsible_student/modules/auth/auth_service/models/user_entity.dart';
import 'package:responsible_student/modules/auth/auth_service/service/auth_service.dart';
import 'package:responsible_student/modules/tasks/models/task.dart';
import 'package:rxdart/rxdart.dart';

part 'user_data_event.dart';
part 'user_data_state.dart';

class UserDataBloc extends HydratedBloc<UserDataEvent, UserDataState> {
  UserDataBloc(this._authService, this._firestore)
      : super(UserDataState(
            entity: UserEntity.empty(), tasks: const <String, Task>{})) {
    on<UserDataAddTasksEvent>(_onUserDataAddTasksEvent);
    on<UserDataLoggedInEvent>(_onUserDataLoggedInEvent);
    on<UserDataLoggedOutEvent>(_onUserDataLoggedOutEvent);
    on<UserDataUpdateTasksEvent>(_onUserDataUpdateTasksEvent);
    on<UserDataAddOrUpdateTask>(_onUserDataAddOrUpdateTask);
    on<UserDataDeleteTask>(_onUserDataDeleteTask);
    on<UserDataSynchronize>(_onUserDataSynchronize);

    on<UserDataSetShouldLogInEvent>((event, emit) {
      emit(state.copyWith(shouldBeLoggedIn: true));
    });
    on<UserDataSetShouldNotLogInEvent>((event, emit) {
      emit(state.copyWith(shouldBeLoggedIn: false, entity: UserEntity.empty()));
    });
    print('Constructor was called');
    emit(state.copyWith(entity: _authService.getCurrentUser()));
    if (state.isLoggedIn) add(UserDataSynchronize());
  }
  final AuthService _authService;
  final FirebaseFirestore _firestore;

  _onUserDataAddTasksEvent(
      UserDataAddTasksEvent event, Emitter<UserDataState> emit) {
    var newMap = Map<String, Task>.of(state.tasks);

    for (var item in event.tasks) {
      if (!newMap.containsKey(item.id)) {
        newMap[item.id] = item;
      }
    }
    emit(state.copyWith(tasks: newMap));
  }

  _onUserDataLoggedInEvent(
      UserDataLoggedInEvent event, Emitter<UserDataState> emit) {
    emit(
      state.copyWith(
          entity: _authService.getCurrentUser(),
          isLoggedIn: true,
          shouldBeLoggedIn: true),
    );
    add(UserDataSynchronize(deleteLocal: !event.synchronize));
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
    if (state.isLoggedIn) {
      add(UserDataSynchronize(newMap: newMap));
    } else {
      emit(state.copyWith(tasks: newMap));
    }
  }

  _onUserDataDeleteTask(UserDataDeleteTask event, Emitter<UserDataState> emit) {
    var newMap = Map<String, Task>.of(state.tasks);
    if (state.isLoggedIn) {
      add(UserDataSynchronize(deletedTask: event.task));
    } else {
      newMap.remove(event.task.id);
      emit(state.copyWith(tasks: newMap));
    }
  }

  _onUserDataSynchronize(UserDataSynchronize event, Emitter<UserDataState> emit,
      {bool isFirstTime = true}) async {
    if (state.entity.id.isEmpty) {}
    Map<String, Task> oldTasks = event.deleteLocal
        ? {}
        : event.newMap == null
            ? state.tasks
            : event.newMap!;
    Map<String, Task> newTasks = {};
    bool updateTasks = false;
    bool didFindDocument = false;
    DocumentReference tasks =
        _firestore.collection('/task').doc(state.entity.id);
    try {
      await tasks.get().then((value) {
        didFindDocument = true;
        var data = value.data();
        Map<String, dynamic> tasks = (data as Map<String, dynamic>)['tasks'];
        for (var taskEntry in tasks.entries) {
          Task task = Task.fromFirestoreJson(taskEntry.value);
          print(task);
          if (!oldTasks.containsKey(task.id)) {
            newTasks[task.id] = task;
          } else {
            if (oldTasks[task.id]!.dateModified.isAfter(task.dateModified)) {
              updateTasks = true;
              newTasks[task.id] = oldTasks[task.id]!;
            } else {
              newTasks[task.id] = task;
            }
          }
        }
      });
    } catch (e) {
      print(e);
    }

    if ((!didFindDocument) && isFirstTime) {
      print('Did not find document');
      await _onUserDataSynchronize(event, emit, isFirstTime: false);
      return;
    }
    for (var taskEntry in oldTasks.entries) {
      if (!newTasks.containsKey(taskEntry.key)) {
        newTasks[taskEntry.value.id] = taskEntry.value;
        updateTasks = true;
      }
    }
    if (event.deletedTask != null &&
        newTasks.containsKey(event.deletedTask!.id)) {
      newTasks.remove(event.deletedTask!.id);
    }

    if (updateTasks) {
      Map<String, dynamic> taskData = new Map<String, dynamic>();
      for (var task in newTasks.values) {
        taskData[task.id] = task.toFirestoreJson();
      }
      await tasks.set({'tasks': taskData});
    }

    emit(state.copyWith(tasks: newTasks));
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
