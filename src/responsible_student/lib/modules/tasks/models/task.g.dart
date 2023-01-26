// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Task _$TaskFromJson(Map<String, dynamic> json) => Task(
      json['id'] as String,
      DateTime.parse(json['deadline'] as String),
      (json['hours'] as num).toDouble(),
      (json['hoursDone'] as num).toDouble(),
      (json['hoursPerReminder'] as num).toDouble(),
      json['name'] as String,
      DateTime.parse(json['nextReminder'] as String),
    );

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
      'id': instance.id,
      'deadline': instance.deadline.toIso8601String(),
      'hours': instance.hours,
      'hoursDone': instance.hoursDone,
      'hoursPerReminder': instance.hoursPerReminder,
      'name': instance.name,
      'nextReminder': instance.nextReminder.toIso8601String(),
    };
