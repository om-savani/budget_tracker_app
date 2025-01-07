import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../helper/db_helper.dart';
import '../model/category_model.dart';

class CategoryController extends GetxController {
  int? categoryIndex;
  Future<List<CategoryModel>>? categoryList;

  CategoryController() {
    getCategoryData();
  }

  void changeCategoryIndex({required int index}) {
    categoryIndex = index;
    update();
  }

  void resetCategoryIndex() {
    categoryIndex = null;
    update();
  }

  Future<void> saveCategory(
      {required String name, required Uint8List image}) async {
    int? res = await DBHelper.dbHelper
        .insertCategoryData(name: name, image: image, imageId: categoryIndex!);
    if (res != null) {
      Get.snackbar('Category Added', ' $name added successfully',
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: Colors.green);
    } else {
      Get.snackbar('Error', 'Insertion failed',
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: Colors.red);
    }
    update();
  }

  void getCategoryData() async {
    categoryList = DBHelper.dbHelper.getAllData();
    update();
  }

  void searchCategory({required String search}) async {
    categoryList = DBHelper.dbHelper.searchCategory(search: search);
    update();
  }

  //update category
  Future<void> updateCategory({required CategoryModel model}) async {
    int? res = await DBHelper.dbHelper.updateCategory(model: model);
    if (res != null) {
      getCategoryData();
      Get.snackbar('Category Updated', 'Category updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: Colors.green);
    } else {
      Get.snackbar('Error', 'Update failed',
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: Colors.red);
    }
    update();
  }

  //delete category
  Future<void> deleteCategory({required int id}) async {
    int? res = await DBHelper.dbHelper.deleteCategory(id: id);
    if (res != null) {
      getCategoryData();
      Get.snackbar('Category Deleted', 'Category deleted successfully',
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: Colors.green);
    } else {
      Get.snackbar('Error', 'Deletion failed',
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: Colors.red);
    }
    update();
  }
}
