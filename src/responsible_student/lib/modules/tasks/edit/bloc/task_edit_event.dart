part of 'task_edit_bloc.dart';

abstract class TaskEditEvent {}

class TaskEditDeadlineChanged extends TaskEditEvent {
  final DateTime deadline;

  TaskEditDeadlineChanged(this.deadline);
}

class TaskEditHoursChanged extends TaskEditEvent {
  final double hours;

  TaskEditHoursChanged(this.hours);
}

class TaskEditHoursDoneChanged extends TaskEditEvent {
  final double hoursDone;

  TaskEditHoursDoneChanged(this.hoursDone);
}

class TaskEditHoursPerReminderChanged extends TaskEditEvent {
  final double hoursPerReminder;

  TaskEditHoursPerReminderChanged(this.hoursPerReminder);
}

class TaskEditNameChanged extends TaskEditEvent {
  final String name;

  TaskEditNameChanged(this.name);
}

class TaskEditNextReminderChanged extends TaskEditEvent {
  final DateTime nextReminder;

  TaskEditNextReminderChanged(this.nextReminder);
}

class TaskEditSubmitEvent extends TaskEditEvent {}

class TaskEditCheckAllErrors extends TaskEditEvent {}
