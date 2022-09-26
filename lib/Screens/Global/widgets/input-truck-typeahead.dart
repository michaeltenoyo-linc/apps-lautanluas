import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../Models/truck.dart';

class InputTruckTypeAhead extends StatelessWidget {
  const InputTruckTypeAhead({
    Key? key,
    required this.nopol,
  }) : super(key: key);

  final TextEditingController nopol;

  @override
  Widget build(BuildContext context) {
    return TypeAheadFormField<ModelTruck?>(
      hideSuggestionsOnKeyboardHide: true,
      debounceDuration: Duration(milliseconds: 500),
      textFieldConfiguration: TextFieldConfiguration(
        controller: nopol,
        decoration: InputDecoration(
          prefixIcon: Icon(FontAwesomeIcons.truck),
          border: OutlineInputBorder(),
          hintText: 'Truck',
        ),
      ),
      suggestionsCallback: TruckFakerData.getSuggestions,
      itemBuilder: (context, ModelTruck? suggestion) {
        final truck = suggestion!;

        return ListTile(
          title: Text(truck.nopol),
        );
      },
      onSuggestionSelected: (ModelTruck? suggestion) {
        final truck = suggestion!;

        nopol.text = truck.nopol;
      },
      validator: (value) =>
          value != null && value.isEmpty ? 'Please select a truck' : null,
    );
  }
}

bool isCurrentTimeBetween(List<TimeOfDay> openingTimeRange) {
  TimeOfDay now = TimeOfDay.now();
  return now.hour >= openingTimeRange[0].hour &&
      now.minute >= openingTimeRange[0].minute &&
      now.hour <= openingTimeRange[1].hour &&
      now.minute <= openingTimeRange[1].minute;
}
