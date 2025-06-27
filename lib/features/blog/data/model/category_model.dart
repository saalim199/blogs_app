import 'dart:convert';

import 'package:blogs_app/features/blog/domain/entity/category.dart';

class CategoryModel extends Category {
  CategoryModel({required super.id, required super.name, required super.description, required super.createdAt});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      createdAt: DateTime.parse(map['createdAt'] ?? ''),
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryModel.fromJson(String source) => CategoryModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
