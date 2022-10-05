import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../Models/truck.dart';

class InputTruckTypeAhead extends StatefulWidget {
  const InputTruckTypeAhead({
    Key? key,
    required this.nopol,
  }) : super(key: key);

  final TextEditingController nopol;

  @override
  State<InputTruckTypeAhead> createState() => _InputTruckTypeAheadState();
}

class _InputTruckTypeAheadState extends State<InputTruckTypeAhead> {
  TruckSearchService _searchService = TruckSearchService();
  List<ModelTruck> search = <ModelTruck>[];

  @override
  void initState() {
    getDocs();
    super.initState();
  }

  Future getDocs() async {
    search = (await _searchService.getSearch()).map((item) {
      return ModelTruck(
        nopol: item.id,
        type: item.get('type'),
        enabled: item.get('enabled'),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return TypeAheadFormField<ModelTruck?>(
      hideSuggestionsOnKeyboardHide: true,
      debounceDuration: Duration(milliseconds: 500),
      textFieldConfiguration: TextFieldConfiguration(
        controller: widget.nopol,
        decoration: InputDecoration(
          prefixIcon: Icon(FontAwesomeIcons.truck),
          border: OutlineInputBorder(),
          hintText: 'Truck',
        ),
      ),
      suggestionsCallback: (pattern) {
        return search.where(
          (doc) => doc.nopol.toLowerCase().contains(pattern.toLowerCase()),
        );
      },
      itemBuilder: (context, ModelTruck? suggestion) {
        final truck = suggestion!;

        return ListTile(
          title: Text(truck.nopol),
        );
      },
      onSuggestionSelected: (ModelTruck? suggestion) {
        final truck = suggestion!;

        widget.nopol.text = truck.nopol;
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
