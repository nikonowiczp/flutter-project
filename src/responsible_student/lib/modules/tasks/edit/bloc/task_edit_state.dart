part of 'task_edit_bloc.dart';

class TaskEditState extends Equatable {
  final String id;
  final DateTime deadline;
  final double hours;
  final double hoursDone;
  final double hoursPerReminder;
  final String name;
  final DateTime nextReminder;

  final String deadlineError;
  final String hoursError;
  final String hoursDoneError;
  final String hoursPerReminderError;
  final String nameError;
  final String nextReminderError;

  final bool submissionSuccess;
  TaskEditState({
    this.deadlineError = '',
    this.hoursError = '',
    this.hoursDoneError = '',
    this.hoursPerReminderError = '',
    this.nameError = '',
    this.nextReminderError = '',
    required this.id,
    required this.deadline,
    required this.hours,
    required this.hoursDone,
    required this.hoursPerReminder,
    required this.name,
    required this.nextReminder,
    this.submissionSuccess = false,
  });
  @override
  // TODO: implement props
  List<Object?> get props => [
        id,
        deadline,
        hours,
        hoursDone,
        hoursPerReminder,
        name,
        nextReminder,
        deadlineError,
        hoursError,
        hoursDoneError,
        hoursPerReminderError,
        nameError,
        nextReminderError
      ];

  TaskEditState copyWith(
      {String? deadlineError,
      String? hoursError,
      String? hoursDoneError,
      String? hoursPerReminderError,
      String? nameError,
      String? nextReminderError,
      DateTime? deadline,
      double? hours,
      double? hoursDone,
      double? hoursPerReminder,
      String? name,
      DateTime? nextReminder}) {
    return TaskEditState(
        id: id,
        deadlineError: deadlineError ?? this.deadlineError,
        hoursError: hoursError ?? this.hoursError,
        hoursDoneError: hoursDoneError ?? this.hoursDoneError,
        hoursPerReminderError:
            hoursPerReminderError ?? this.hoursPerReminderError,
        nameError: nameError ?? this.nameError,
        nextReminderError: nextReminderError ?? this.nextReminderError,
        deadline: deadline ?? this.deadline,
        hours: hours ?? this.hours,
        hoursDone: hoursDone ?? this.hoursDone,
        hoursPerReminder: hoursPerReminder ?? this.hoursPerReminder,
        name: name ?? this.name,
        nextReminder: nextReminder ?? this.nextReminder);
  }

  Task getTask() {
    return Task(
        id,
        deadline,
        double.parse(hours.toStringAsFixed(1)),
        double.parse(hoursDone.toStringAsFixed(1)),
        double.parse(hoursPerReminder.toStringAsFixed(1)),
        name,
        nextReminder);
  }

  bool canSubmit() {
    return deadlineError.isEmpty &&
        hoursError.isEmpty &&
        hoursDoneError.isEmpty &&
        nameError.isEmpty &&
        nextReminderError.isEmpty;
  }
}
