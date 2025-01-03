import 'package:budget_tracker_app/controller/category_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/category_model.dart';

class HomeComponent extends StatelessWidget {
  const HomeComponent({super.key});

  @override
  Widget build(BuildContext context) {
    CategoryController controller = Get.put(CategoryController());
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
                            return Card(
                              child: ListTile(
                                leading: CircleAvatar(
                                  radius: 26,
                                  backgroundImage:
                                      MemoryImage(allCategoryData[index].image),
                                ),
                                title: Text(allCategoryData[index].name),
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
