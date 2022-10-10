import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InputDateTime extends StatelessWidget {
  const InputDateTime({
    Key? key,
    required this.time,
    required this.label,
    required this.context,
    required this.onChanged,
    this.validatorLabel = 'Please enter correct datetime',
  }) : super(key: key);

  final TextEditingController time;
  final String label;
  final BuildContext context;
  final Function(String value) onChanged;
  final String validatorLabel;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: time, //editing controller of this TextField
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validatorLabel;
        }
        return null;
      },
      decoration: InputDecoration(
        icon: Icon(Icons.timer), //icon of text field
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

        TimeOfDay? pickedTime = await showTimePicker(
          initialTime: TimeOfDay.now(),
          context: context, //context of current state
        );

        if (pickedTime != null && pickedDate != null) {
          DateTime datetime = DateTime(pickedDate.year, pickedDate.month,
              pickedDate.day, pickedTime.hour, pickedTime.minute);
          String formattedTime =
              DateFormat('yyyy-MM-dd HH:mm').format(datetime);
          onChanged(formattedTime);
        } else {
          print("Date or Time is not selected");
        }
      },
    );
  }
}
