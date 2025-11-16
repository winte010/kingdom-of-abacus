import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_profile.g.dart';

@JsonSerializable()
class UserProfile extends Equatable {
  final String id;
  final String? name;
  final DateTime createdAt;
  final DateTime lastActive;
  final Map<String, dynamic>? settings;

  const UserProfile({
    required this.id,
    this.name,
    required this.createdAt,
    required this.lastActive,
    this.settings,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) => _$UserProfileFromJson(json);
  Map<String, dynamic> toJson() => _$UserProfileToJson(this);

  UserProfile copyWith({
    String? id,
    String? name,
    DateTime? createdAt,
    DateTime? lastActive,
    Map<String, dynamic>? settings,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      lastActive: lastActive ?? this.lastActive,
      settings: settings ?? this.settings,
    );
  }

  @override
  List<Object?> get props => [id, name, createdAt, lastActive, settings];
}
