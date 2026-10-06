// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceRequestModel _$ServiceRequestModelFromJson(Map<String, dynamic> json) =>
    ServiceRequestModel(
      id: json['id'] as String,
      user: json['user'] as String,
      service: json['service'] as String,
      equipment: json['equipment'] as String,
      issueDescription: json['issueDescription'] as String,
      images: (json['images'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      status: json['status'] as String,
      paymentId: json['paymentId'] as String?,
      created: DateTime.parse(json['created'] as String),
      updated: DateTime.parse(json['updated'] as String),
    );

Map<String, dynamic> _$ServiceRequestModelToJson(
  ServiceRequestModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'user': instance.user,
  'service': instance.service,
  'equipment': instance.equipment,
  'issueDescription': instance.issueDescription,
  'images': instance.images,
  'status': instance.status,
  'paymentId': instance.paymentId,
  'created': instance.created.toIso8601String(),
  'updated': instance.updated.toIso8601String(),
};
