import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:responsible_student/modules/local_notification/service/local_notification_service.dart';
import 'package:responsible_student/modules/tasks/models/task.dart';

import 'local_notification_state.dart';
part 'local_notification_event.dart';

class LocalNotificationBloc
    extends HydratedBloc<LocalNotificationEvent, LocalNotificationState> {
  LocalNotificationBloc()
      : super(const LocalNotificationState(map: {}, currentNotification: 1)) {
    on<LocalNotificationInitialize>(_onLocalNotificationInitialize);
    on<LocalNotificationAddNotificationForTask>(
        _onLocalNotificationAddNotificationForTask);
    on<LocalNotificationDeleteNotificationForTask>(
        _onLocalNotificationDeleteNotificationForTask);
    if (!state.wasInitialized) {
      add(LocalNotificationInitialize());
    }
  }
  _onLocalNotificationInitialize(
      LocalNotificationInitialize event, Emitter<LocalNotificationState> emit) {
    LocalNoticeService().addNotification(
      0,
      'Test notification',
      'Notification Body',
      DateTime.now().millisecondsSinceEpoch + 1000,
      channel: 'testing',
    );
    emit(state.copyWith(wasInitialized: true));
  }

  _onLocalNotificationAddNotificationForTask(
      LocalNotificationAddNotificationForTask event,
      Emitter<LocalNotificationState> emit) {
    var newMap = Map<String, int>.from(state.map);
    if (newMap.containsKey(event.task.id)) {
      LocalNoticeService().cancelNotification(newMap[event.task.id]!);
    }
    LocalNoticeService().addNotification(
      state.currentNotification,
      'You should work on ${event.task.name}',
      'Today you need to work on it for ${event.task.hoursPerReminder} hours',
      DateTime.now().isAfter(event.task.nextReminder)
          ? DateTime.now().microsecondsSinceEpoch + 1000
          : event.task.nextReminder.microsecondsSinceEpoch,
    );
    newMap[event.task.id] = state.currentNotification;
    emit(state.copyWith(
        map: newMap, currentNotification: state.currentNotification + 1));
  }

  _onLocalNotificationDeleteNotificationForTask(
      LocalNotificationDeleteNotificationForTask event,
      Emitter<LocalNotificationState> emit) {
    var newMap = Map<String, int>.from(state.map);
    if (newMap.containsKey(event.task.id)) {
      LocalNoticeService().cancelNotification(newMap[event.task.id]!);
      newMap.remove(event.task.id);
    }
    emit(state.copyWith(map: newMap));
  }

  @override
  LocalNotificationState? fromJson(Map<String, dynamic> json) {
    return LocalNotificationState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(LocalNotificationState state) {
    return state.toJson();
  }
}
