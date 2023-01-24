import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:responsible_student/modules/auth/auth_service/models/user_entity.dart';
import 'package:responsible_student/modules/tasks/models/task.dart';

part 'user_data_event.dart';
part 'user_data_state.dart';

class UserDataBloc extends HydratedBloc<UserDataEvent, UserDataState> {
  UserDataBloc()
      : super(UserDataState(entity: UserEntity.empty(), tasks: const []));

  @override
  UserDataState? fromJson(Map<String, dynamic> json) {
    return UserDataState(
        entity: UserEntity.fromJson(json['userEntity']),
        tasks: json['tasks'],
        isLoggedIn: json['isLoggedIn'],
        status: UserDataStatus.notInitialized);
  }

  @override
  Map<String, dynamic>? toJson(UserDataState state) {
    return {
      'userEntity': state.entity.toJson(),
      'tasks': state.tasks,
      'isLoggedIn': state.isLoggedIn
    };
  }
}
