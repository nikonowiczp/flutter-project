import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
part 'local_notification_state.g.dart';

@JsonSerializable()
class LocalNotificationState extends Equatable {
  final bool wasInitialized;
  final Map<String, int> map;
  final int currentNotification;
  const LocalNotificationState(
      {required this.map,
      required this.currentNotification,
      this.wasInitialized = false});
  @override
  List<Object?> get props => [wasInitialized, map, currentNotification];
  factory LocalNotificationState.fromJson(Map<String, dynamic> json) =>
      _$LocalNotificationStateFromJson(json);
  Map<String, dynamic> toJson() => _$LocalNotificationStateToJson(this);

  LocalNotificationState copyWith(
      {bool? wasInitialized, Map<String, int>? map, int? currentNotification}) {
    return LocalNotificationState(
        map: map ?? this.map,
        currentNotification: currentNotification ?? this.currentNotification,
        wasInitialized: wasInitialized ?? this.wasInitialized);
  }
}
