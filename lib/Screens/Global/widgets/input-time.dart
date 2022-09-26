import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InputTime extends StatelessWidget {
  const InputTime({
    Key? key,
    required this.time,
    required this.label,
    required this.context,
    required this.onChanged,
  }) : super(key: key);

  final TextEditingController time;
  final String label;
  final BuildContext context;
  final Function(String value) onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: time, //editing controller of this TextField
      decoration: InputDecoration(
        icon: Icon(Icons.timer), //icon of text field
        labelText: label, //label text of field
      ),
      readOnly: true, //set it true, so that user will not able to edit text
      onTap: () async {
        TimeOfDay? pickedTime = await showTimePicker(
          initialTime: TimeOfDay.now(),
          context: context, //context of current state
        );

        if (pickedTime != null) {
          DateTime parsedTime =
              DateFormat.jm().parse(pickedTime.format(context).toString());
          String formattedTime = DateFormat('HH:mm:ss').format(parsedTime);
          onChanged(formattedTime);
        } else {
          print("Time is not selected");
        }
      },
    );
  }
}
