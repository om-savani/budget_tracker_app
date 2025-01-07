import 'package:budget_tracker_app/controller/spending_controller.dart';
import 'package:budget_tracker_app/helper/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

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
    return GetBuilder<SpendingController>(builder: (ctx) {
      return Form(
        key: spendKey,
        child: Column(
          children: [
            const Text('Spending'),
            const SizedBox(height: 10),
            TextFormField(
              controller: amountController,
              validator: (value) => value!.isEmpty ? "Required..." : null,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Amount',
                hintText: 'Enter an amount',
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide(
                    color: Colors.deepPurple,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide(
                    color: Colors.red,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: descriptionController,
              validator: (value) => value!.isEmpty ? "Required..." : null,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Description',
                hintText: 'Enter a description',
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide(
                    color: Colors.deepPurple,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide(
                    color: Colors.red,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text("Mode : "),
                const SizedBox(width: 5),
                DropdownButton<String>(
                  value: controller.mode,
                  hint: const Text("Select Mode"),
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
            const SizedBox(height: 10),
            Row(
              children: [
                const Text("Date: "),
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
                  icon: const Icon(Icons.calendar_month),
                ),
                if (controller.date != null)
                  Text(
                    controller.date.toString().substring(0, 10),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: FutureBuilder(
                future: DBHelper.dbHelper.getAllData(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<CategoryModel> allCategoryData = snapshot.data ?? [];
                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 5),
                      itemCount: allCategoryData.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            controller.setSpendingIndex(
                                index: index, id: allCategoryData[index].id);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: controller.spendingIndex == index
                                      ? Colors.deepPurple
                                      : Colors.transparent,
                                ),
                                image: DecorationImage(
                                  image: MemoryImage(
                                    allCategoryData[index].image,
                                  ),
                                )),
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
            FloatingActionButton.extended(
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
                      date: controller.date.toString().substring(0, 10),
                      categoryId: controller.categoryId,
                    ),
                  );
                } else {
                  Get.snackbar(
                    "Required",
                    "all field are required....",
                    backgroundColor: Colors.red.shade300,
                  );
                }
                amountController.clear();
                descriptionController.clear();
                controller.resetValues();
              },
              label: const Text('Add'),
            )
          ],
        ),
      );
    });
  }
}
