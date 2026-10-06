// lib/features/feat_services/models/service_model.dart

import 'package:pocketbase/pocketbase.dart';
import 'package:json_annotation/json_annotation.dart';

part 'service_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ServiceModel {
  String id;
  String title;
  String? category;
  double? basePrice;
  String? description;
  String? image;
  bool isActive;
  DateTime created;
  DateTime updated;

  ServiceModel({
    required this.id,
    required this.title,
    this.category,
    this.basePrice,
    this.description,
    this.image,
    required this.isActive,
    required this.created,
    required this.updated,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) =>
      _$ServiceModelFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceModelToJson(this);

  factory ServiceModel.fromRecord(RecordModel record) {
    return ServiceModel(
      id: record.id,
      title: record.get<String?>('title') ?? '',
      category: record.get<String?>('category'),
      basePrice: record.get<num?>('base_price')?.toDouble(),
      description: record.get<String?>('description'),
      image: record.get<String?>('image'),
      isActive: record.get<bool?>('is_active') ?? true,
      created: DateTime.parse(
        record.get<String?>('created') ?? DateTime.now().toIso8601String(),
      ),
      updated: DateTime.parse(
        record.get<String?>('updated') ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}
