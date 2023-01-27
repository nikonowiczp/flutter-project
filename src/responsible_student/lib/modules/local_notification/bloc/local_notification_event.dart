part of 'local_notification_bloc.dart';

abstract class LocalNotificationEvent {}

class LocalNotificationInitialize extends LocalNotificationEvent {}

class LocalNotificationAddNotificationForTask extends LocalNotificationEvent {
  final Task task;

  LocalNotificationAddNotificationForTask(this.task);
}

class LocalNotificationDeleteNotificationForTask
    extends LocalNotificationEvent {
  final Task task;

  LocalNotificationDeleteNotificationForTask(this.task);
}
