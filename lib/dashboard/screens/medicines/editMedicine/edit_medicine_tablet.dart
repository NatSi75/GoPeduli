import 'package:flutter/material.dart';
import 'package:gopeduli/dashboard/repository/medicine_model.dart';

class EditMedicineTablet extends StatelessWidget {
  const EditMedicineTablet({super.key, required this.medicine});

  final MedicineModel medicine;

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [],
          ),
        ),
      ),
    );
  }
}
