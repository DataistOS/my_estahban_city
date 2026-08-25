//lib/features/feat_auth/models/user_model.dart

import 'package:pocketbase/pocketbase.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable(explicitToJson: true)
class UserModel {
  String id;
  String email;
  String name;
  String? userType;
  String? tier;
  String? phoneNumber;
  String? address;
  String? nationalCode;
  DateTime? birthDate;
  String? economicCode;
  String? companyRegistrationNumber;
  String? ceoName;
  String avatar;
  DateTime created;
  DateTime updated;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.userType,
    this.tier,
    this.phoneNumber,
    this.address,
    this.nationalCode,
    this.birthDate,
    this.economicCode,
    this.companyRegistrationNumber,
    this.ceoName,
    required this.avatar,
    required this.created,
    required this.updated,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  factory UserModel.fromRecord(RecordModel record) {
    final String safeEmail = record.data['email'] ?? '';
    final String safeName = record.data['name'] ?? '';
    final String safeAvatar = record.data['avatar'] ?? '';

    final String createdString =
        record.get<String?>('created') ?? DateTime.now().toIso8601String();
    final String updatedString =
        record.get<String?>('updated') ?? DateTime.now().toIso8601String();

    final String? birthDateString = record.get<String?>('birth_date');
    final DateTime? parsedBirthDate = birthDateString != null
        ? DateTime.tryParse(birthDateString)
        : null;

    return UserModel(
      id: record.id,
      email: safeEmail,
      name: safeName,
      userType: record.get<String?>('user_type'),
      tier: record.get<String?>('tier') ?? 'free',
      // مقدار پیش‌فرض free
      phoneNumber: record.get<String?>('phone_number'),
      address: record.get<String?>('address'),
      nationalCode: record.get<String?>('national_code'),
      birthDate: parsedBirthDate,
      economicCode: record.get<String?>('economic_code'),
      companyRegistrationNumber: record.get<String?>(
        'company_registration_number',
      ),
      ceoName: record.get<String?>('ceo_name'),
      avatar: safeAvatar,
      created: DateTime.parse(createdString),
      updated: DateTime.parse(updatedString),
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, type: $userType, tier: $tier)';
  }
}
