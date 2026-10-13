// test/features/feat_services/models/equipment_model_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:my_estahban_city/features/feat_services/models/equipment_model.dart';

void main() {
  group('EquipmentModel Unit Tests', () {
    test('fromRecord parses RecordModel correctly', () {
      final recordData = {
        'id': 'eq_123456789',
        'collectionId': 'col_equipments',
        'collectionName': 'equipments',
        'created': '2026-01-01 10:00:00.000Z',
        'updated': '2026-01-01 11:00:00.000Z',
        'user': 'user_987654',
        'type': 'لپ‌تاپ',
        'title': 'لپ‌تاپ ایسوس زنبک',
        'identifier': 'SN123456789',
        'details': 'رنگ خاکستری، نیازمند تعویض کیبورد',
      };

      final record = RecordModel.fromJson(recordData);
      final equipment = EquipmentModel.fromRecord(record);

      expect(equipment.id, 'eq_123456789');
      expect(equipment.user, 'user_987654');
      expect(equipment.type, 'لپ‌تاپ');
      expect(equipment.title, 'لپ‌تاپ ایسوس زنبک');
      expect(equipment.identifier, 'SN123456789');
      expect(equipment.details, 'رنگ خاکستری، نیازمند تعویض کیبورد');
      expect(equipment.created, DateTime.parse('2026-01-01 10:00:00.000Z'));
      expect(equipment.updated, DateTime.parse('2026-01-01 11:00:00.000Z'));
    });

    test('toJson and fromJson convert model correctly', () {
      final now = DateTime.now();
      final equipment = EquipmentModel(
        id: 'eq_999',
        user: 'user_111',
        type: 'موبایل',
        title: 'آیفون ۱۳',
        identifier: 'IMEI987654321',
        details: 'سلامت باتری ۸۵٪',
        created: now,
        updated: now,
      );

      final json = equipment.toJson();
      final converted = EquipmentModel.fromJson(json);

      expect(converted.id, 'eq_999');
      expect(converted.user, 'user_111');
      expect(converted.type, 'موبایل');
      expect(converted.title, 'آیفون ۱۳');
      expect(converted.identifier, 'IMEI987654321');
      expect(converted.details, 'سلامت باتری ۸۵٪');
    });
  });
}
