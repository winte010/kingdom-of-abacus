// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Character _$CharacterFromJson(Map<String, dynamic> json) => Character(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      portraitAsset: json['portraitAsset'] as String?,
      role: $enumDecode(_$CharacterRoleEnumMap, json['role']),
    );

Map<String, dynamic> _$CharacterToJson(Character instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'portraitAsset': instance.portraitAsset,
      'role': _$CharacterRoleEnumMap[instance.role]!,
    };

const _$CharacterRoleEnumMap = {
  CharacterRole.hero: 'hero',
  CharacterRole.ally: 'ally',
  CharacterRole.villain: 'villain',
  CharacterRole.neutral: 'neutral',
};
