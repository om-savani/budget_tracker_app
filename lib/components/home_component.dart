import 'dart:developer';

import 'package:budget_tracker_app/components/category_component.dart';
import 'package:budget_tracker_app/components/spend_component.dart';
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
        Container(
          decoration: const BoxDecoration(
            color: Colors.black,
            image: DecorationImage(
              image: AssetImage("assets/images/background/app_background.png"),
              fit: BoxFit.cover, // Adjusts the image to fill the screen
            ),
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
                                  color: Colors.transparent,
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
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Dismissible(
                                      key: Key(data.id.toString()),
                                      direction: DismissDirection.endToStart,
                                      background: Container(
                                        color: Colors.red,
                                        alignment: Alignment.centerRight,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: const Icon(
                                          Icons.delete,
                                          color: Colors.white,
                                        ),
                                      ),
                                      onDismissed: (direction) async {
                                        List<SpendingModel> spendingList =
                                            await controller.spendingList ?? [];
                                        spendingList.removeWhere(
                                            (item) => item.id == data.id);
                                        controller.update();

                                        controller.deleteSpendingData(
                                            id: data.id);
                                      },
                                      child: ListTile(
                                        onTap: () {
                                          Get.bottomSheet(
                                            Container(
                                              height: 200,
                                              width: double.infinity,
                                              margin: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                gradient: const LinearGradient(
                                                  colors: [
                                                    Color(
                                                        0xFF000000), // Dark red
                                                    // Color(0xFFFFFFFF), //
                                                    Color(
                                                        0xff500202), // Bright red
                                                  ],
                                                  begin: Alignment.centerLeft,
                                                  end: Alignment.centerRight,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              padding: const EdgeInsets.all(16),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    data.description,
                                                    style: const TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    "₹ ${data.amount}",
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Text(
                                                        "DATE : ",
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      Text(
                                                        data.date,
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    children: [
                                                      FutureBuilder(
                                                        future: DBHelper
                                                            .dbHelper
                                                            .getSpendingById(
                                                                id: data
                                                                    .categoryId),
                                                        builder: (context,
                                                            snapshot) {
                                                          if (snapshot
                                                              .hasData) {
                                                            return Container(
                                                              height: 50,
                                                              width: 50,
                                                              decoration:
                                                                  BoxDecoration(
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .white),
                                                                shape: BoxShape
                                                                    .circle,
                                                                image:
                                                                    DecorationImage(
                                                                  image: MemoryImage(
                                                                      snapshot
                                                                          .data!
                                                                          .image),
                                                                  fit: BoxFit
                                                                      .cover,
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
                                                      const SizedBox(
                                                        width: 20,
                                                      ),
                                                      const Spacer(),
                                                      IconButton(
                                                          onPressed: () {
                                                            amountController
                                                                .clear();
                                                            descriptionController
                                                                .clear();
                                                            controller
                                                                .resetValues();
                                                            Get.dialog(
                                                              AlertDialog(
                                                                title: const Text(
                                                                    "Update Spending"),
                                                                content:
                                                                    Container(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          16),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: const Color(
                                                                            0xff646464)
                                                                        .withOpacity(
                                                                            0.6),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            15),
                                                                  ),
                                                                  child: Form(
                                                                    key:
                                                                        spendKey,
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        // Amount Input
                                                                        TextFormField(
                                                                          controller:
                                                                              amountController,
                                                                          validator: (value) => value!.isEmpty
                                                                              ? "Required..."
                                                                              : null,
                                                                          keyboardType:
                                                                              TextInputType.number,
                                                                          style:
                                                                              const TextStyle(color: Colors.white),
                                                                          decoration:
                                                                              InputDecoration(
                                                                            labelText:
                                                                                'Amount',
                                                                            hintText:
                                                                                'Enter an amount',
                                                                            labelStyle:
                                                                                const TextStyle(color: Colors.white),
                                                                            border:
                                                                                OutlineInputBorder(
                                                                              borderRadius: BorderRadius.circular(10),
                                                                            ),
                                                                            focusedBorder:
                                                                                OutlineInputBorder(
                                                                              borderSide: const BorderSide(color: Colors.deepPurple),
                                                                              borderRadius: BorderRadius.circular(10),
                                                                            ),
                                                                            errorBorder:
                                                                                OutlineInputBorder(
                                                                              borderSide: const BorderSide(color: Colors.red),
                                                                              borderRadius: BorderRadius.circular(10),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                            height:
                                                                                16),

                                                                        // Description Input
                                                                        TextFormField(
                                                                          controller:
                                                                              descriptionController,
                                                                          validator: (value) => value!.isEmpty
                                                                              ? "Required..."
                                                                              : null,
                                                                          style:
                                                                              const TextStyle(color: Colors.white),
                                                                          decoration:
                                                                              InputDecoration(
                                                                            labelText:
                                                                                'Description',
                                                                            hintText:
                                                                                'Enter a description',
                                                                            labelStyle:
                                                                                const TextStyle(color: Colors.white),
                                                                            border:
                                                                                OutlineInputBorder(
                                                                              borderRadius: BorderRadius.circular(10),
                                                                            ),
                                                                            focusedBorder:
                                                                                OutlineInputBorder(
                                                                              borderSide: const BorderSide(color: Colors.deepPurple),
                                                                              borderRadius: BorderRadius.circular(10),
                                                                            ),
                                                                            errorBorder:
                                                                                OutlineInputBorder(
                                                                              borderSide: const BorderSide(color: Colors.red),
                                                                              borderRadius: BorderRadius.circular(10),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                            height:
                                                                                16),

                                                                        // Mode Dropdown
                                                                        Row(
                                                                          children: [
                                                                            const Text(
                                                                              "Mode:",
                                                                              style: TextStyle(color: Colors.white),
                                                                            ),
                                                                            const SizedBox(width: 8),
                                                                            DropdownButton<String>(
                                                                              dropdownColor: const Color(0xff646464),
                                                                              value: controller.mode,
                                                                              style: const TextStyle(color: Colors.white),
                                                                              hint: const Text(
                                                                                "Select Mode",
                                                                                style: TextStyle(color: Colors.white),
                                                                              ),
                                                                              items: const [
                                                                                DropdownMenuItem<String>(
                                                                                  value: "Cash",
                                                                                  child: Text("Cash"),
                                                                                ),
                                                                                DropdownMenuItem<String>(
                                                                                  value: "Card",
                                                                                  child: Text("Card"),
                                                                                ),
                                                                                DropdownMenuItem<String>(
                                                                                  value: "Digital",
                                                                                  child: Text("Digital"),
                                                                                ),
                                                                              ],
                                                                              onChanged: (value) => controller.setMode(spendMode: value),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        const SizedBox(
                                                                            height:
                                                                                16),

                                                                        // Date Picker
                                                                        Row(
                                                                          children: [
                                                                            const Text("Date: ",
                                                                                style: TextStyle(color: Colors.white)),
                                                                            const SizedBox(width: 5),
                                                                            IconButton(
                                                                              onPressed: () async {
                                                                                DateTime? date = await showDatePicker(
                                                                                  context: context,
                                                                                  firstDate: DateTime(2000),
                                                                                  lastDate: DateTime(2026),
                                                                                  initialDate: DateTime.now(),
                                                                                );
                                                                                if (date != null) {
                                                                                  controller.setDate(spendDate: date);
                                                                                }
                                                                              },
                                                                              icon: const Icon(
                                                                                Icons.calendar_month,
                                                                                color: Colors.white,
                                                                              ),
                                                                            ),
                                                                            if (controller.date !=
                                                                                null)
                                                                              Text(
                                                                                controller.date.toString().substring(0, 10),
                                                                                style: const TextStyle(color: Colors.white),
                                                                              ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                                actions: [
                                                                  TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      log("mode: ${controller.mode}");
                                                                      log("date: ${controller.date}");

                                                                      if (spendKey
                                                                              .currentState!
                                                                              .validate() &&
                                                                          controller.mode !=
                                                                              null &&
                                                                          controller.date !=
                                                                              null) {
                                                                        controller
                                                                            .updateSpendingData(
                                                                          model:
                                                                              SpendingModel(
                                                                            id: data.id,
                                                                            description:
                                                                                descriptionController.text,
                                                                            amount:
                                                                                num.parse(amountController.text),
                                                                            mode:
                                                                                controller.mode!,
                                                                            date:
                                                                                controller.date.toString().substring(0, 10),
                                                                            categoryId:
                                                                                data.categoryId,
                                                                          ),
                                                                        );
                                                                        amountController
                                                                            .clear();
                                                                        descriptionController
                                                                            .clear();
                                                                        controller
                                                                            .resetValues();
                                                                        Navigator.pop(
                                                                            context);
                                                                      } else {
                                                                        Get.snackbar(
                                                                          "Required",
                                                                          "all field are required....",
                                                                          backgroundColor: Colors
                                                                              .red
                                                                              .shade300,
                                                                        );
                                                                      }
                                                                    },
                                                                    child:
                                                                        const Text(
                                                                            "Ok"),
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                          icon: const Icon(
                                                            Icons.edit,
                                                            color: Colors.white,
                                                          )),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        },
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
                                            color: Colors.white,
                                          ),
                                        ),
                                        subtitle: Text(
                                          data.date.toString(),
                                          style: const TextStyle(
                                            color: Colors.white70,
                                          ),
                                        ),
                                        trailing: Text(
                                          "₹${data.amount.toString()}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),
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
