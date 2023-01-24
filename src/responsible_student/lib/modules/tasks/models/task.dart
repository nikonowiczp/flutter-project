import 'package:equatable/equatable.dart';

class Task extends Equatable {
  final DateTime deadline;
  final double hours;
  final double hoursDone;
  final double hoursPerReminder;
  final String name;
  final DateTime nextReminder;

  const Task(this.deadline, this.hours, this.hoursDone, this.hoursPerReminder,
      this.name, this.nextReminder);
  @override
  List<Object?> get props =>
      [deadline, hours, hoursDone, hoursPerReminder, name, nextReminder];
}
