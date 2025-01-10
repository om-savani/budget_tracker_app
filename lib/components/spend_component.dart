import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:budget_tracker_app/controller/spending_controller.dart';

import '../helper/db_helper.dart';
import '../model/category_model.dart';
import '../model/spending_model.dart';

TextEditingController amountController = TextEditingController();
TextEditingController descriptionController = TextEditingController();
GlobalKey<FormState> spendKey = GlobalKey<FormState>();

class SpendComponent extends StatelessWidget {
  const SpendComponent({super.key});

  @override
  Widget build(BuildContext context) {
    SpendingController controller = Get.put(SpendingController());
    return Scaffold(
      body: GetBuilder<SpendingController>(builder: (ctx) {
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
            Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Form(
                    key: spendKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Title
                        const Text(
                          'Expense',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
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
                                controller: amountController,
                                validator: (value) =>
                                    value!.isEmpty ? "Required..." : null,
                                keyboardType: TextInputType.number,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  labelText: 'Amount',
                                  hintText: 'Enter an amount',
                                  labelStyle:
                                      const TextStyle(color: Colors.white),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.deepPurple),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.red),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: descriptionController,
                                validator: (value) =>
                                    value!.isEmpty ? "Required..." : null,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  labelText: 'Description',
                                  hintText: 'Enter a description',
                                  labelStyle:
                                      const TextStyle(color: Colors.white),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.deepPurple),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.red),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
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
                                    onChanged: (value) =>
                                        controller.setMode(spendMode: value),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
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
                                  if (controller.date != null)
                                    Text(
                                      controller.date
                                          .toString()
                                          .substring(0, 10),
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                height: 100,
                                child: FutureBuilder(
                                  future: DBHelper.dbHelper.getAllData(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      List<CategoryModel> allCategoryData =
                                          snapshot.data ?? [];
                                      return GridView.builder(
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 5,
                                        ),
                                        itemCount: allCategoryData.length,
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: () {
                                              controller.setSpendingIndex(
                                                index: index,
                                                id: allCategoryData[index].id,
                                              );
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: controller
                                                              .spendingIndex ==
                                                          index
                                                      ? Colors.white
                                                      : Colors.transparent,
                                                ),
                                                image: DecorationImage(
                                                  image: MemoryImage(
                                                      allCategoryData[index]
                                                          .image),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    } else {
                                      return const CircularProgressIndicator();
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        ElevatedButton(
                          onPressed: () {
                            if (spendKey.currentState!.validate() &&
                                controller.mode != null &&
                                controller.date != null &&
                                controller.spendingIndex != null) {
                              controller.addSpendingData(
                                model: SpendingModel(
                                  id: 0,
                                  description: descriptionController.text,
                                  amount: num.parse(amountController.text),
                                  mode: controller.mode!,
                                  date: controller.date
                                      .toString()
                                      .substring(0, 10),
                                  categoryId: controller.categoryId,
                                ),
                              );
                              amountController.clear();
                              descriptionController.clear();
                              controller.resetValues();
                            } else {
                              Get.snackbar(
                                "Required",
                                "all field are required....",
                                backgroundColor: Colors.red.shade300,
                              );
                            }
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
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
