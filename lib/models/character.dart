import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'character.g.dart';

@JsonSerializable()
class Character extends Equatable {
  final String id;
  final String name;
  final String? description;
  final String? portraitAsset;
  final CharacterRole role;

  const Character({
    required this.id,
    required this.name,
    this.description,
    this.portraitAsset,
    required this.role,
  });

  factory Character.fromJson(Map<String, dynamic> json) => _$CharacterFromJson(json);
  Map<String, dynamic> toJson() => _$CharacterToJson(this);

  @override
  List<Object?> get props => [id, name, description, portraitAsset, role];
}

enum CharacterRole {
  @JsonValue('hero')
  hero,
  @JsonValue('ally')
  ally,
  @JsonValue('villain')
  villain,
  @JsonValue('neutral')
  neutral,
}
