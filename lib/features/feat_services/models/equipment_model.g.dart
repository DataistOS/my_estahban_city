// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'equipment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EquipmentModel _$EquipmentModelFromJson(Map<String, dynamic> json) =>
    EquipmentModel(
      id: json['id'] as String,
      user: json['user'] as String,
      type: json['type'] as String?,
      title: json['title'] as String,
      identifier: json['identifier'] as String?,
      details: json['details'] as String?,
      created: DateTime.parse(json['created'] as String),
      updated: DateTime.parse(json['updated'] as String),
    );

Map<String, dynamic> _$EquipmentModelToJson(EquipmentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user': instance.user,
      'type': instance.type,
      'title': instance.title,
      'identifier': instance.identifier,
      'details': instance.details,
      'created': instance.created.toIso8601String(),
      'updated': instance.updated.toIso8601String(),
    };
