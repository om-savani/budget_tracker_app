import 'package:budget_tracker_app/controller/category_controller.dart';
import 'package:budget_tracker_app/helper/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

List<String> categoryImages = [
  "assets/images/category/utilities.png",
  "assets/images/category/rent.png",
  "assets/images/category/bill.png",
  "assets/images/category/savings.png",
  "assets/images/category/education.png",
  "assets/images/category/cash.png",
  "assets/images/category/communication.png",
  "assets/images/category/deposit.png",
  "assets/images/category/food.png",
  "assets/images/category/gift.png",
  "assets/images/category/health.png",
  "assets/images/category/movie.png",
  "assets/images/category/rupee.png",
  "assets/images/category/salary.png",
  "assets/images/category/shopping.png",
  "assets/images/category/transport.png",
  "assets/images/category/wallet.png",
  "assets/images/category/withdraw.png",
  "assets/images/category/other.png",
];

GlobalKey<FormState> formKey = GlobalKey<FormState>();
TextEditingController categoryController = TextEditingController();

class CategoryComponent extends StatelessWidget {
  const CategoryComponent({super.key});

  @override
  Widget build(BuildContext context) {
    CategoryController controller = Get.put(CategoryController());
    return Form(
      key: formKey,
      child: Column(
        children: [
          const Text(
            'Select Category',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: categoryController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a category';
              }
              return null;
            },
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: 'Category',
              hintText: 'Enter a category',
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Colors.deepPurple,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Colors.redAccent,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Colors.redAccent,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: categoryImages.length,
              itemBuilder: (context, index) {
                return GetBuilder<CategoryController>(
                  builder: (controller) {
                    return GestureDetector(
                      onTap: () {
                        controller.changeCategoryIndex(index: index);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(categoryImages[index]),
                            fit: BoxFit.cover,
                          ),
                          border: Border.all(
                            color: controller.categoryIndex == index
                                ? Colors.deepPurple
                                : Colors.transparent,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton.extended(
                backgroundColor: const Color(0xffb1f2ee),
                onPressed: () async {
                  if (formKey.currentState!.validate() &&
                      controller.categoryIndex != null) {
                    String name = categoryController.text;
                    String imagePath =
                        categoryImages[controller.categoryIndex!];
                    ByteData data = await rootBundle.load(imagePath);
                    Uint8List image = data.buffer.asUint8List();
                    controller.saveCategory(name: name, image: image);
                  } else {
                    Get.snackbar('Error', 'Please enter a category',
                        snackPosition: SnackPosition.BOTTOM,
                        colorText: Colors.white,
                        backgroundColor: Colors.red);
                  }
                  categoryController.clear();
                  controller.resetCategoryIndex();
                },
                label:
                    const Text('Done', style: TextStyle(color: Colors.black)),
                icon: const Icon(
                  Icons.done,
                  color: Colors.black,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
