// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_notification_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocalNotificationState _$LocalNotificationStateFromJson(
        Map<String, dynamic> json) =>
    LocalNotificationState(
      map: Map<String, int>.from(json['map'] as Map),
      currentNotification: json['currentNotification'] as int,
      wasInitialized: json['wasInitialized'] as bool? ?? false,
    );

Map<String, dynamic> _$LocalNotificationStateToJson(
        LocalNotificationState instance) =>
    <String, dynamic>{
      'wasInitialized': instance.wasInitialized,
      'map': instance.map,
      'currentNotification': instance.currentNotification,
    };
