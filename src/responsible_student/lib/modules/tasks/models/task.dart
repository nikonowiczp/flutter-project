import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
part 'task.g.dart';

@JsonSerializable()
class Task extends Equatable {
  final String id;
  final DateTime deadline;
  final double hours;
  final double hoursDone;
  final double hoursPerReminder;
  final String name;
  final DateTime nextReminder;

  const Task(this.id, this.deadline, this.hours, this.hoursDone,
      this.hoursPerReminder, this.name, this.nextReminder);
  @override
  List<Object?> get props =>
      [id, deadline, hours, hoursDone, hoursPerReminder, name, nextReminder];

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

  Map<String, dynamic> toJson() => _$TaskToJson(this);
}
