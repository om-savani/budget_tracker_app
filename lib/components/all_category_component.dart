import 'dart:ui';

import 'package:budget_tracker_app/components/category_component.dart';
import 'package:budget_tracker_app/controller/category_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../model/category_model.dart';

class AllCategoryComponent extends StatelessWidget {
  const AllCategoryComponent({super.key});

  @override
  Widget build(BuildContext context) {
    CategoryController controller = Get.put(CategoryController());
    controller.getCategoryData();
    return Stack(
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
        Column(
          children: [
            SearchBar(
              hintText: 'Search',
              leading: const Icon(CupertinoIcons.search),
              onChanged: (value) {
                controller.searchCategory(search: value);
              },
            ),
            const SizedBox(height: 10),
            Expanded(
              child: GetBuilder<CategoryController>(builder: (context) {
                return FutureBuilder(
                  future: controller.categoryList,
                  builder: (context, snapShot) {
                    if (snapShot.hasError) {
                      return Center(
                        child: Text("ERROR : ${snapShot.error}"),
                      );
                    } else if (snapShot.hasData) {
                      List<CategoryModel> allCategoryData = snapShot.data ?? [];

                      return allCategoryData.isNotEmpty
                          ? ListView.builder(
                              itemCount: allCategoryData.length,
                              itemBuilder: (context, index) {
                                CategoryModel data = allCategoryData[index];
                                return Card(
                                  color: Colors.transparent,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFF000000),
                                          Color(0xffD66B6B),
                                        ],
                                        begin: Alignment.centerRight,
                                        end: Alignment.centerLeft,
                                        transform: GradientRotation(0),
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: ListTile(
                                      onTap: () {
                                        Get.defaultDialog(
                                          title: 'Delete Category',
                                          middleText: 'Are you sure?',
                                          onConfirm: () {
                                            controller.deleteCategory(
                                                id: allCategoryData[index].id);
                                            Get.back();
                                          },
                                          onCancel: () {
                                            Get.back();
                                          },
                                        );
                                      },
                                      leading: Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                            image: DecorationImage(
                                              image: MemoryImage(data.image),
                                              fit: BoxFit.cover,
                                            ),
                                            border: Border.all(
                                              color: Colors.white,
                                            )),
                                      ),
                                      title: Text(
                                        data.name,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              categoryController.text =
                                                  data.name;

                                              controller.resetCategoryIndex();

                                              Get.bottomSheet(
                                                Container(
                                                  width: double.infinity,
                                                  padding:
                                                      const EdgeInsets.all(16),
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(20),
                                                      topRight:
                                                          Radius.circular(20),
                                                    ),
                                                  ),
                                                  child: Form(
                                                    key: formKey,
                                                    child: Column(
                                                      children: [
                                                        const Text(
                                                          "Update Category",
                                                          style: TextStyle(
                                                            fontSize: 25,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        TextFormField(
                                                          controller:
                                                              categoryController,
                                                          validator: (val) =>
                                                              val!.isEmpty
                                                                  ? "Required..."
                                                                  : null,
                                                          decoration:
                                                              InputDecoration(
                                                            labelText:
                                                                "Category",
                                                            hintText:
                                                                "Enter category...",
                                                            enabledBorder:
                                                                OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            12),
                                                                    borderSide:
                                                                        const BorderSide(
                                                                      color: Colors
                                                                          .grey,
                                                                    )),
                                                            focusedBorder:
                                                                OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            12),
                                                                    borderSide:
                                                                        const BorderSide(
                                                                      color: Colors
                                                                          .deepPurpleAccent,
                                                                    )),
                                                            errorBorder:
                                                                OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            12),
                                                                    borderSide:
                                                                        const BorderSide(
                                                                      color: Colors
                                                                          .redAccent,
                                                                    )),
                                                            focusedErrorBorder:
                                                                OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            12),
                                                                    borderSide:
                                                                        const BorderSide(
                                                                      color: Colors
                                                                          .redAccent,
                                                                    )),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        Expanded(
                                                          child:
                                                              GridView.builder(
                                                            gridDelegate:
                                                                const SliverGridDelegateWithFixedCrossAxisCount(
                                                              crossAxisCount: 5,
                                                            ),
                                                            itemCount:
                                                                categoryImages
                                                                    .length,
                                                            itemBuilder: (context,
                                                                    index) =>
                                                                GetBuilder<
                                                                        CategoryController>(
                                                                    builder:
                                                                        (context) {
                                                              return GestureDetector(
                                                                onTap: () {
                                                                  controller
                                                                      .changeCategoryIndex(
                                                                          index:
                                                                              index);
                                                                },
                                                                child:
                                                                    Container(
                                                                  margin:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          3),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            12),
                                                                    border:
                                                                        Border
                                                                            .all(
                                                                      color: (controller.categoryIndex !=
                                                                              null)
                                                                          ? (controller.categoryIndex == index)
                                                                              ? Colors.grey
                                                                              : Colors.transparent
                                                                          : (index == data.imageId)
                                                                              ? Colors.grey
                                                                              : Colors.transparent,
                                                                    ),
                                                                    image:
                                                                        DecorationImage(
                                                                      image:
                                                                          AssetImage(
                                                                        categoryImages[
                                                                            index],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            }),
                                                          ),
                                                        ),
                                                        FloatingActionButton
                                                            .extended(
                                                          onPressed: () async {
                                                            if (formKey
                                                                    .currentState!
                                                                    .validate() &&
                                                                controller
                                                                        .categoryIndex !=
                                                                    null) {
                                                              String name =
                                                                  categoryController
                                                                      .text;

                                                              String assetPath =
                                                                  categoryImages[
                                                                      controller
                                                                          .categoryIndex!];

                                                              ByteData
                                                                  byteData =
                                                                  await rootBundle
                                                                      .load(
                                                                          assetPath);

                                                              Uint8List image =
                                                                  byteData
                                                                      .buffer
                                                                      .asUint8List();

                                                              CategoryModel
                                                                  model =
                                                                  CategoryModel(
                                                                id: data.id,
                                                                name: name,
                                                                image: image,
                                                                imageId: controller
                                                                    .categoryIndex!,
                                                              );

                                                              controller
                                                                  .updateCategory(
                                                                      model:
                                                                          model);

                                                              Navigator.pop(
                                                                  context);
                                                            }
                                                          },
                                                          label: const Text(
                                                            "Update Category",
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                            icon: const Icon(
                                              Icons.edit,
                                              color: Colors.green,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )
                          : const Center(
                              child: Text("No Category Available"),
                            );
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ],
    );
  }
}
