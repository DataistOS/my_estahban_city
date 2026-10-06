// lib/features/feat_services/models/service_request_model.dart

import 'package:pocketbase/pocketbase.dart';
import 'package:json_annotation/json_annotation.dart';

part 'service_request_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ServiceRequestModel {
  String id;
  String user;
  String service;
  String equipment;
  String issueDescription;
  List<String> images;
  String status;
  String? paymentId;
  DateTime created;
  DateTime updated;

  ServiceRequestModel({
    required this.id,
    required this.user,
    required this.service,
    required this.equipment,
    required this.issueDescription,
    required this.images,
    required this.status,
    this.paymentId,
    required this.created,
    required this.updated,
  });

  factory ServiceRequestModel.fromJson(Map<String, dynamic> json) =>
      _$ServiceRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceRequestModelToJson(this);

  factory ServiceRequestModel.fromRecord(RecordModel record) {
    var rawImages = record.data['images'];
    List<String> parsedImages = [];
    if (rawImages is List) {
      parsedImages = rawImages.map((e) => e.toString()).toList();
    } else if (rawImages is String && rawImages.isNotEmpty) {
      parsedImages = [rawImages];
    }

    return ServiceRequestModel(
      id: record.id,
      user: record.get<String?>('user') ?? '',
      service: record.get<String?>('service') ?? '',
      equipment: record.get<String?>('equipment') ?? '',
      issueDescription: record.get<String?>('issue_description') ?? '',
      images: parsedImages,
      status: record.get<String?>('status') ?? 'pending',
      paymentId: record.get<String?>('payment_id'),
      created: DateTime.parse(
        record.get<String?>('created') ?? DateTime.now().toIso8601String(),
      ),
      updated: DateTime.parse(
        record.get<String?>('updated') ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}
