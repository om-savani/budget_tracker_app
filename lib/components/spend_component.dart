import 'package:flutter/material.dart';

class SpendComponent extends StatelessWidget {
  const SpendComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Spend Component',
        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
      ),
    );
  }
}
