// lib/features/feat_services/models/equipment_model.dart

import 'package:pocketbase/pocketbase.dart';
import 'package:json_annotation/json_annotation.dart';

part 'equipment_model.g.dart';

@JsonSerializable(explicitToJson: true)
class EquipmentModel {
  String id;
  String user;
  String? type;
  String title;
  String? identifier;
  String? details;
  DateTime created;
  DateTime updated;

  EquipmentModel({
    required this.id,
    required this.user,
    this.type,
    required this.title,
    this.identifier,
    this.details,
    required this.created,
    required this.updated,
  });

  factory EquipmentModel.fromJson(Map<String, dynamic> json) =>
      _$EquipmentModelFromJson(json);

  Map<String, dynamic> toJson() => _$EquipmentModelToJson(this);

  factory EquipmentModel.fromRecord(RecordModel record) {
    return EquipmentModel(
      id: record.id,
      user: record.get<String?>('user') ?? '',
      type: record.get<String?>('type'),
      title: record.get<String?>('title') ?? '',
      identifier: record.get<String?>('identifier'),
      details: record.get<String?>('details'),
      created: DateTime.parse(
        record.get<String?>('created') ?? DateTime.now().toIso8601String(),
      ),
      updated: DateTime.parse(
        record.get<String?>('updated') ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}
