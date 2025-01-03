import 'package:flutter/services.dart';

class CategoryModel {
  int id;
  String name;
  Uint8List image;

  CategoryModel({required this.id, required this.name, required this.image});

  factory CategoryModel.fromMap({required Map<String, dynamic> map}) {
    return CategoryModel(
      id: map['category_id'],
      name: map['category_name'],
      image: map['category_image'],
    );
  }
}
