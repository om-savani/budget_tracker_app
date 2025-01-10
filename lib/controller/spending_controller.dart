import 'package:budget_tracker_app/helper/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/spending_model.dart';

class SpendingController extends GetxController {
  String? mode;
  DateTime? date;
  int? spendingIndex;
  int categoryId = 0;
  Future<List<SpendingModel>>? spendingList;

  SpendingController() {
    getSpendingData();
  }

  void setMode({String? spendMode}) {
    mode = spendMode;
    update();
  }

  void setDate({required DateTime spendDate}) {
    date = spendDate;
    update();
  }

  void setSpendingIndex({required int index, required int id}) {
    spendingIndex = index;
    categoryId = id;
    update();
  }

  void resetValues() {
    mode = null;
    date = null;
    spendingIndex = null;
    categoryId = 0;
    update();
  }

  Future<void> addSpendingData({required SpendingModel model}) async {
    int? result = await DBHelper.dbHelper.insertSpendingData(model: model);
    if (result != null) {
      Get.snackbar('Spending Added', 'Spending added successfully',
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

  void getSpendingData() {
    spendingList = DBHelper.dbHelper.getAllSpendingData();
    update();
  }

  void updateSpendingData({required SpendingModel model}) async {
    int? result = await DBHelper.dbHelper.updateSpending(model: model);
    if (result != null) {
      getSpendingData();
      Get.snackbar('Spending Updated', 'Spending updated successfully',
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

  Future<void> deleteSpendingData({required int id}) async {
    int? result = await DBHelper.dbHelper.deleteSpending(id: id);
    if (result != null) {
      getSpendingData();
      Get.snackbar('Spending Deleted', 'Spending deleted successfully',
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
