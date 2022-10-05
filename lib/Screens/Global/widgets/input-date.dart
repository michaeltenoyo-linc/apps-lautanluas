import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InputDate extends StatelessWidget {
  const InputDate({
    Key? key,
    required this.date,
    required this.context,
    required this.onChanged,
    required this.label,
    this.validatorLabel = 'Please enter date',
  }) : super(key: key);

  final TextEditingController date;
  final BuildContext context;
  final Function(String value) onChanged;
  final String label;
  final String validatorLabel;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: date, //editing controller of this TextField
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validatorLabel;
        }
        return null;
      },
      decoration: InputDecoration(
        icon: Icon(Icons.calendar_today), //icon of text field
        labelText: label, //label text of field
      ),
      readOnly: true, //set it true, so that user will not able to edit text
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(
              2000), //DateTime.now() - not to allow to choose before today.
          lastDate: DateTime(2101),
        );

        if (pickedDate != null) {
          String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
          onChanged(formattedDate);
        } else {
          print("Date is not selected");
        }
      },
    );
  }
}
