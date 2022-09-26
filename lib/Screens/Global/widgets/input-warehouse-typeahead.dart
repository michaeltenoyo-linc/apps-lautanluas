import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ltl_bulk/Models/warehouse.dart';

class InputWarehouseTypeAhead extends StatelessWidget {
  const InputWarehouseTypeAhead({
    Key? key,
    required this.name,
  }) : super(key: key);

  final TextEditingController name;

  @override
  Widget build(BuildContext context) {
    return TypeAheadFormField<ModelWarehouse?>(
      hideSuggestionsOnKeyboardHide: true,
      debounceDuration: Duration(milliseconds: 500),
      textFieldConfiguration: TextFieldConfiguration(
        controller: name,
        decoration: InputDecoration(
          prefixIcon: Icon(FontAwesomeIcons.warehouse),
          border: OutlineInputBorder(),
          hintText: 'Warehouse',
        ),
      ),
      suggestionsCallback: WarehouseFakerData.getSuggestions,
      itemBuilder: (context, ModelWarehouse? suggestion) {
        final warehouse = suggestion!;

        return ListTile(
          title: Text(warehouse.name),
        );
      },
      onSuggestionSelected: (ModelWarehouse? suggestion) {
        final warehouse = suggestion!;

        name.text = warehouse.name;
      },
      validator: (value) =>
          value != null && value.isEmpty ? 'Please select a warehouse' : null,
    );
  }
}
