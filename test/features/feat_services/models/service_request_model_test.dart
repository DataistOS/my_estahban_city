// test/features/feat_services/models/service_request_model_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:my_estahban_city/features/feat_services/models/service_request_model.dart';

void main() {
  group('ServiceRequestModel Unit Tests', () {
    test('fromRecord parses RecordModel with list images correctly', () {
      final recordData = {
        'id': 'req_123456',
        'collectionId': 'col_service_requests',
        'collectionName': 'service_requests',
        'created': '2026-01-01 10:00:00.000Z',
        'updated': '2026-01-01 11:00:00.000Z',
        'user': 'user_001',
        'service': 'srv_002',
        'equipment': 'eq_003',
        'issue_description': 'دستگاه روشن نمی‌شود',
        'images': ['img1.png', 'img2.png'],
        'status': 'in_progress',
        'payment_id': 'pay_999',
      };

      final record = RecordModel.fromJson(recordData);
      final request = ServiceRequestModel.fromRecord(record);

      expect(request.id, 'req_123456');
      expect(request.user, 'user_001');
      expect(request.service, 'srv_002');
      expect(request.equipment, 'eq_003');
      expect(request.issueDescription, 'دستگاه روشن نمی‌شود');
      expect(request.images, ['img1.png', 'img2.png']);
      expect(request.status, 'in_progress');
      expect(request.paymentId, 'pay_999');
      expect(request.created, DateTime.parse('2026-01-01 10:00:00.000Z'));
      expect(request.updated, DateTime.parse('2026-01-01 11:00:00.000Z'));
    });

    test('fromRecord parses single String image correctly', () {
      final recordData = {
        'id': 'req_789012',
        'collectionId': 'col_service_requests',
        'collectionName': 'service_requests',
        'created': '2026-01-01 10:00:00.000Z',
        'updated': '2026-01-01 11:00:00.000Z',
        'user': 'user_002',
        'service': 'srv_001',
        'equipment': 'eq_001',
        'issue_description': 'صفحه نمایش شکسته است',
        'images': 'single_img.png',
        'status': 'pending',
      };

      final record = RecordModel.fromJson(recordData);
      final request = ServiceRequestModel.fromRecord(record);

      expect(request.images, ['single_img.png']);
      expect(request.status, 'pending');
    });

    test('toJson and fromJson convert ServiceRequestModel correctly', () {
      final now = DateTime.now();
      final request = ServiceRequestModel(
        id: 'req_555',
        user: 'user_111',
        service: 'srv_222',
        equipment: 'eq_333',
        issueDescription: 'تست توضیحات مشکلا',
        images: ['img_a.jpg', 'img_b.jpg'],
        status: 'completed',
        paymentId: 'pay_123',
        created: now,
        updated: now,
      );

      final json = request.toJson();
      final converted = ServiceRequestModel.fromJson(json);

      expect(converted.id, 'req_555');
      expect(converted.user, 'user_111');
      expect(converted.service, 'srv_222');
      expect(converted.equipment, 'eq_333');
      expect(converted.issueDescription, 'تست توضیحات مشکلا');
      expect(converted.images, ['img_a.jpg', 'img_b.jpg']);
      expect(converted.status, 'completed');
      expect(converted.paymentId, 'pay_123');
    });
  });
}
