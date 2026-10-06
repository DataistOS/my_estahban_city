// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceModel _$ServiceModelFromJson(Map<String, dynamic> json) => ServiceModel(
  id: json['id'] as String,
  title: json['title'] as String,
  category: json['category'] as String?,
  basePrice: (json['basePrice'] as num?)?.toDouble(),
  description: json['description'] as String?,
  image: json['image'] as String?,
  isActive: json['isActive'] as bool,
  created: DateTime.parse(json['created'] as String),
  updated: DateTime.parse(json['updated'] as String),
);

Map<String, dynamic> _$ServiceModelToJson(ServiceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'category': instance.category,
      'basePrice': instance.basePrice,
      'description': instance.description,
      'image': instance.image,
      'isActive': instance.isActive,
      'created': instance.created.toIso8601String(),
      'updated': instance.updated.toIso8601String(),
    };
