import 'package:budget_tracker_app/components/category_component.dart';
import 'package:budget_tracker_app/controller/category_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../model/category_model.dart';

class HomeComponent extends StatelessWidget {
  const HomeComponent({super.key});

  @override
  Widget build(BuildContext context) {
    CategoryController controller = Get.put(CategoryController());
    controller.getCategoryData();
    return Column(
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
                              child: ListTile(
                                leading: CircleAvatar(
                                  radius: 26,
                                  backgroundImage: MemoryImage(data.image),
                                ),
                                title: Text(data.name),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        categoryController.text = data.name;

                                        controller.resetCategoryIndex();

                                        Get.bottomSheet(
                                          Container(
                                            width: double.infinity,
                                            padding: const EdgeInsets.all(16),
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(20),
                                                topRight: Radius.circular(20),
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
                                                    decoration: InputDecoration(
                                                      labelText: "Category",
                                                      hintText:
                                                          "Enter category...",
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12),
                                                              borderSide:
                                                                  const BorderSide(
                                                                color:
                                                                    Colors.grey,
                                                              )),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12),
                                                              borderSide:
                                                                  const BorderSide(
                                                                color: Colors
                                                                    .deepPurpleAccent,
                                                              )),
                                                      errorBorder:
                                                          OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12),
                                                              borderSide:
                                                                  const BorderSide(
                                                                color: Colors
                                                                    .redAccent,
                                                              )),
                                                      focusedErrorBorder:
                                                          OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
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
                                                    child: GridView.builder(
                                                      gridDelegate:
                                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                                        crossAxisCount: 5,
                                                      ),
                                                      itemCount:
                                                          categoryImages.length,
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
                                                          child: Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .all(3),
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12),
                                                              border:
                                                                  Border.all(
                                                                color: (controller
                                                                            .categoryIndex !=
                                                                        null)
                                                                    ? (controller.categoryIndex ==
                                                                            index)
                                                                        ? Colors
                                                                            .grey
                                                                        : Colors
                                                                            .transparent
                                                                    : (index ==
                                                                            data
                                                                                .imageId)
                                                                        ? Colors
                                                                            .grey
                                                                        : Colors
                                                                            .transparent,
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
                                                  FloatingActionButton.extended(
                                                    onPressed: () async {
                                                      if (formKey.currentState!
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

                                                        ByteData byteData =
                                                            await rootBundle
                                                                .load(
                                                                    assetPath);

                                                        Uint8List image =
                                                            byteData.buffer
                                                                .asUint8List();

                                                        CategoryModel model =
                                                            CategoryModel(
                                                          id: data.id,
                                                          name: name,
                                                          image: image,
                                                          imageId: controller
                                                              .categoryIndex!,
                                                        );

                                                        controller
                                                            .updateCategory(
                                                                model: model);

                                                        Navigator.pop(context);
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
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        controller.deleteCategory(
                                            id: allCategoryData[index].id);
                                      },
                                    ),
                                  ],
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
    );
  }
}
