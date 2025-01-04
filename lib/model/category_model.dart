import 'package:flutter/services.dart';

class CategoryModel {
  int id;
  String name;
  Uint8List image;
  int imageId;

  CategoryModel(
      {required this.id,
      required this.name,
      required this.image,
      required this.imageId});

  factory CategoryModel.fromMap({required Map<String, dynamic> map}) {
    return CategoryModel(
      id: map['category_id'],
      name: map['category_name'],
      image: map['category_image'],
      imageId: map['category_image_id'],
    );
  }
}
