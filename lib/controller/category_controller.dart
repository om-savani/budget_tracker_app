import 'package:get/get.dart';

class CategoryController extends GetxController {
  int? categoryIndex;

  void changeCategoryIndex({required int index}) {
    categoryIndex = index;
    update();
  }
}
