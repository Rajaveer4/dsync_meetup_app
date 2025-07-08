import 'package:flutter/material.dart';

class DatePicker extends StatelessWidget {
  final DateTime initialDate;
  final Function(DateTime) onDateSelected;

  const DatePicker({
    super.key,
    required this.initialDate,
    required this.onDateSelected,
  });

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate, // ✅ now customizable
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      onDateSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _selectDate(context),
      child: const Text('Select Date'),
    );
  }
}
