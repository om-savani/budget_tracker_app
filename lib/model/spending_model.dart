class SpendingModel {
  int id;
  num amount;
  String date;
  String description;
  String mode;
  int categoryId;

  SpendingModel(
      {required this.id,
      required this.amount,
      required this.date,
      required this.description,
      required this.mode,
      required this.categoryId});

  factory SpendingModel.fromMap(Map<String, dynamic> map) {
    return SpendingModel(
      id: map['spending_id'],
      amount: map['spending_amount'],
      date: map['spending_date'],
      description: map['spending_desc'],
      mode: map['spending_mode'],
      categoryId: map['spending_category_id'],
    );
  }
}
