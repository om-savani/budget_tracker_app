import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:budget_tracker_app/controller/spending_controller.dart';
import 'package:budget_tracker_app/helper/db_helper.dart';
import 'package:budget_tracker_app/model/spending_model.dart';

class HomeComponent extends StatelessWidget {
  const HomeComponent({super.key});

  @override
  Widget build(BuildContext context) {
    SpendingController controller = Get.put(SpendingController());
    controller.getSpendingData();

    return Stack(
      children: [
        // Background image
        Container(
          decoration: const BoxDecoration(color: Colors.black
              // image: DecorationImage(
              //   image: AssetImage("assets/images/background/app_background.png"),
              //   fit: BoxFit.cover, // Adjusts the image to fill the screen
              // ),
              ),
        ),
        // Foreground content
        Column(
          children: [
            Expanded(
              child: GetBuilder<SpendingController>(builder: (context) {
                return FutureBuilder(
                  future: controller.spendingList,
                  builder: (context, snapShot) {
                    if (snapShot.hasError) {
                      return Center(
                        child: Text("ERROR : ${snapShot.error}"),
                      );
                    } else if (snapShot.hasData) {
                      List<SpendingModel> allSpendingData = snapShot.data ?? [];

                      return allSpendingData.isNotEmpty
                          ? ListView.builder(
                              itemCount: allSpendingData.length,
                              itemBuilder: (context, index) {
                                SpendingModel data = allSpendingData[index];
                                return Card(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFF000000), // Dark red
                                          // Color(0xFFFFFFFF), //
                                          Color(0xff500202), // Bright red
                                        ],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: ListTile(
                                      leading: FutureBuilder(
                                        future: DBHelper.dbHelper
                                            .getSpendingById(
                                                id: data.categoryId),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            return Container(
                                              height: 50,
                                              width: 50,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.white),
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                  image: MemoryImage(
                                                      snapshot.data!.image),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            );
                                          } else {
                                            return const CircleAvatar(
                                              radius: 30,
                                            );
                                          }
                                        },
                                      ),
                                      title: Text(
                                        data.description,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                      subtitle: Text(
                                        data.date.toString(),
                                        style: const TextStyle(
                                            color: Colors.white70),
                                      ),
                                      trailing: Text(
                                        "₹${data.amount.toString()}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )
                          : const Center(
                              child: Text(
                                "No Category Available",
                                style: TextStyle(color: Colors.white),
                              ),
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
