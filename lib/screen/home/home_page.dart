import 'package:budget_tracker_app/components/all_category_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/category_component.dart';
import '../../components/home_component.dart';
import '../../components/spend_component.dart';
import '../../controller/navigation_controller.dart';

class HomePage extends StatelessWidget {
  final NavigationController controller = Get.put(NavigationController());
  final PageController pageController = PageController();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Home'),
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: (index) {
          controller.changeIndex(index);
        },
        children: const [
          HomeComponent(),
          SpendComponent(),
          AllCategoryComponent(),
          CategoryComponent(),
        ],
      ),
      bottomNavigationBar: Obx(() {
        return BottomNavigationBar(
          unselectedItemColor: Colors.white,
          selectedItemColor: const Color(0xff5dafaa),
          backgroundColor: Colors.black,
          type: BottomNavigationBarType.values[0],
          currentIndex: controller.currentIndex.value,
          onTap: (index) {
            controller.changeIndex(index);
            pageController.jumpToPage(index);
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.attach_money),
              label: 'Spend',
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.category), label: 'All Category'),
            BottomNavigationBarItem(
              icon: Icon(Icons.category),
              label: 'Category',
            ),
          ],
        );
      }),
    );
  }
}
