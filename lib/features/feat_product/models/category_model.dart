import 'package:pocketbase/pocketbase.dart';
import 'package:my_estahban_city/services/pocketbase_instance.dart';

class CategoryModel {
  final String id;
  final String name;
  final String? icon;
  final String? parentCategory;
  final DateTime created;
  final DateTime updated;

  CategoryModel({
    required this.id,
    required this.name,
    this.icon,
    this.parentCategory,
    required this.created,
    required this.updated,
  });

  factory CategoryModel.fromRecord(RecordModel record) {
    String? iconUrl;
    if (record.data['icon'] != null && record.data['icon'].isNotEmpty) {
      iconUrl = pocketBaseInstance
          .getFileUrl(record, record.data['icon'])
          .toString();
    }

    return CategoryModel(
      id: record.id,
      name: record.data['name'],
      icon: iconUrl,
      parentCategory: record.data['parent_category'],
      created: DateTime.parse(record.created),
      updated: DateTime.parse(record.updated),
    );
  }

  Map<String, dynamic> toRecord() {
    return {'name': name, 'parent_category': parentCategory};
  }
}
