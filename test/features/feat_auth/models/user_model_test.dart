// test/features/feat_auth/models/user_model_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:my_estahban_city/features/feat_auth/models/user_model.dart';
import 'package:my_estahban_city/services/pocketbase_instance.dart';

void main() {
  setUpAll(() {
    pocketBaseInstance = PocketBase('http://127.0.0.1:8090');
  });

  group('UserModel Tests', () {
    test('fromJson and toJson should work correctly', () {
      final jsonMap = {
        'id': 'user_123',
        'email': 'test@example.com',
        'name': 'کاربر تست',
        'userType': 'admin',
        'tier': 'vip',
        'phoneNumber': '09123456789',
        'address': 'استهبان، فارس',
        'nationalCode': '1234567890',
        'birthDate': '1990-01-01T00:00:00.000Z',
        'economicCode': '1111',
        'companyRegistrationNumber': '2222',
        'ceoName': 'مدیر تست',
        'avatar': 'avatar.png',
        'created': '2026-01-01T10:00:00.000Z',
        'updated': '2026-01-01T12:00:00.000Z',
      };

      final user = UserModel.fromJson(jsonMap);

      expect(user.id, 'user_123');
      expect(user.email, 'test@example.com');
      expect(user.name, 'کاربر تست');
      expect(user.tier, 'vip');
      expect(user.phoneNumber, '09123456789');

      final serialized = user.toJson();
      expect(serialized['id'], 'user_123');
      expect(serialized['email'], 'test@example.com');
    });

    test(
      'fromRecord should correctly parse a PocketBase RecordModel into UserModel',
      () {
        final record = RecordModel({
          'id': 'rec_456',
          'collectionId': 'users_col',
          'collectionName': 'users',
          'created': '2026-01-01 10:00:00.000Z',
          'updated': '2026-01-01 12:00:00.000Z',
          'email': 'record@example.com',
          'name': 'رکورد کاربر',
          'tier': 'free',
          'avatar': 'rec_avatar.png',
          'phone_number': '09998887766',
        });

        final user = UserModel.fromRecord(record);

        expect(user.id, 'rec_456');
        expect(user.email, 'record@example.com');
        expect(user.name, 'رکورد کاربر');
        expect(user.tier, 'free');
        expect(user.avatar, 'rec_avatar.png');
      },
    );
  });
}
