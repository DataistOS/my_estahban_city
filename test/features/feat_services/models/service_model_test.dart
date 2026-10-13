// test/features/feat_services/models/service_model_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:my_estahban_city/features/feat_services/models/service_model.dart';

void main() {
  group('ServiceModel Unit Tests', () {
    test('fromRecord parses RecordModel into ServiceModel correctly', () {
      final recordData = {
        'id': 'srv_123456789',
        'collectionId': 'col_services',
        'collectionName': 'services',
        'created': '2026-01-01 10:00:00.000Z',
        'updated': '2026-01-01 11:00:00.000Z',
        'title': 'تعمیر و سرویس لپ‌تاپ',
        'category': 'تعمیرات کامپیوتر',
        'base_price': 250000.0,
        'description': 'عویض خمیر سیلیکون و سرویس فن سیستم',
        'image': 'service_image.png',
        'is_active': true,
      };

      final record = RecordModel.fromJson(recordData);
      final service = ServiceModel.fromRecord(record);

      expect(service.id, 'srv_123456789');
      expect(service.title, 'تعمیر و سرویس لپ‌تاپ');
      expect(service.category, 'تعمیرات کامپیوتر');
      expect(service.basePrice, 250000.0);
      expect(service.description, 'عویض خمیر سیلیکون و سرویس فن سیستم');
      expect(service.image, 'service_image.png');
      expect(service.isActive, isTrue);
      expect(service.created, DateTime.parse('2026-01-01 10:00:00.000Z'));
      expect(service.updated, DateTime.parse('2026-01-01 11:00:00.000Z'));
    });

    test('toJson and fromJson convert ServiceModel correctly', () {
      final now = DateTime.now();
      final service = ServiceModel(
        id: 'srv_999',
        title: 'نصب سیستم‌عامل',
        category: 'نرم‌افزار',
        basePrice: 150000.0,
        description: 'نصب و راه اندازی درایورها',
        image: 'os_install.png',
        isActive: true,
        created: now,
        updated: now,
      );

      final json = service.toJson();
      final converted = ServiceModel.fromJson(json);

      expect(converted.id, 'srv_999');
      expect(converted.title, 'نصب سیستم‌عامل');
      expect(converted.category, 'نرم‌افزار');
      expect(converted.basePrice, 150000.0);
      expect(converted.description, 'نصب و راه اندازی درایورها');
      expect(converted.image, 'os_install.png');
      expect(converted.isActive, isTrue);
    });
  });
}
