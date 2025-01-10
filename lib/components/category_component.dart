import 'dart:ui';

import 'package:budget_tracker_app/controller/category_controller.dart';
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
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/background/app_background.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                color: Colors.black.withOpacity(0.3),
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Select Category',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xff646464).withOpacity(0.6),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: categoryController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a category';
                              }
                              return null;
                            },
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'Category',
                              hintText: 'Enter a Category',
                              labelStyle: const TextStyle(color: Colors.white),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.deepPurple),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.red),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            height: 200,
                            child: GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
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
                                        controller.changeCategoryIndex(
                                            index: index);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(
                                                categoryImages[index]),
                                            fit: BoxFit.cover,
                                          ),
                                          border: Border.all(
                                            color: controller.categoryIndex ==
                                                    index
                                                ? Colors.white
                                                : Colors.transparent,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
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
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 12,
                            ),
                          ),
                          child: const Text(
                            "Add",
                            style: TextStyle(
                                fontSize: 16, color: Color(0xffA10F0F)),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
