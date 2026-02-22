// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  id: json['id'] as String,
  email: json['email'] as String,
  name: json['name'] as String,
  userType: json['userType'] as String?,
  phoneNumber: json['phoneNumber'] as String?,
  address: json['address'] as String?,
  nationalCode: json['nationalCode'] as String?,
  birthDate: json['birthDate'] == null
      ? null
      : DateTime.parse(json['birthDate'] as String),
  economicCode: json['economicCode'] as String?,
  companyRegistrationNumber: json['companyRegistrationNumber'] as String?,
  ceoName: json['ceoName'] as String?,
  avatar: json['avatar'] as String,
  created: DateTime.parse(json['created'] as String),
  updated: DateTime.parse(json['updated'] as String),
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'name': instance.name,
  'userType': instance.userType,
  'phoneNumber': instance.phoneNumber,
  'address': instance.address,
  'nationalCode': instance.nationalCode,
  'birthDate': instance.birthDate?.toIso8601String(),
  'economicCode': instance.economicCode,
  'companyRegistrationNumber': instance.companyRegistrationNumber,
  'ceoName': instance.ceoName,
  'avatar': instance.avatar,
  'created': instance.created.toIso8601String(),
  'updated': instance.updated.toIso8601String(),
};
