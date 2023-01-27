import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';
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
  final DateTime dateModified;

  Task(this.id, this.deadline, this.hours, this.hoursDone,
      this.hoursPerReminder, this.name, this.nextReminder, this.dateModified);
  @override
  List<Object?> get props =>
      [id, deadline, hours, hoursDone, hoursPerReminder, name, nextReminder];

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
  factory Task.newTask() {
    var uuid = Uuid();
    return Task(uuid.v1(), DateTime.now(), 0, 0, 0, 'New Task', DateTime.now(),
        DateTime.now());
  }
  factory Task.fromFirestoreJson(Map<String, dynamic> json) => Task(
        json['id'] as String,
        (json['deadline'] as Timestamp).toDate(),
        (json['hours'] as num).toDouble(),
        (json['hoursDone'] as num).toDouble(),
        (json['hoursPerReminder'] as num).toDouble(),
        json['name'] as String,
        (json['nextReminder'] as Timestamp).toDate(),
        (json['dateModified'] as Timestamp).toDate(),
      );
  Map<String, dynamic> toJson() => _$TaskToJson(this);
  Map<String, dynamic> toFirestoreJson() => <String, dynamic>{
        'id': id,
        'deadline': Timestamp.fromDate(deadline),
        'hours': hours,
        'hoursDone': hoursDone,
        'hoursPerReminder': hoursPerReminder,
        'name': name,
        'nextReminder': Timestamp.fromDate(nextReminder),
        'dateModified': Timestamp.fromDate(dateModified),
      };
}
