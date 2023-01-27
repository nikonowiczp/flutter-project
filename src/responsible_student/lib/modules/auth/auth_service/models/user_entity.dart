import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_entity.g.dart';

@JsonSerializable()
class UserEntity extends Equatable {
  const UserEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.imageUrl,
  });

  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String imageUrl;

  factory UserEntity.fromJson(Map<String, dynamic> json) =>
      _$UserEntityFromJson(json);

  Map<String, dynamic> toJson() => _$UserEntityToJson(this);

  factory UserEntity.empty() => const UserEntity(
        id: "",
        firstName: "",
        lastName: "",
        email: "",
        imageUrl: "",
      );
  @override
  List<Object?> get props => [id, firstName, lastName, email, imageUrl];

  bool isEmpty() {
    return id == "" &&
        firstName == "" &&
        lastName == "" &&
        email == "" &&
        imageUrl == "";
  }
}
