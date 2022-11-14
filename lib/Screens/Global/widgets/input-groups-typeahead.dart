import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ltl_bulk/Models/warehouse.dart';

class InputWarehouseTypeAhead extends StatefulWidget {
  const InputWarehouseTypeAhead({
    Key? key,
    required this.name,
  }) : super(key: key);

  final TextEditingController name;

  @override
  State<InputWarehouseTypeAhead> createState() =>
      _InputWarehouseTypeAheadState();
}

class _InputWarehouseTypeAheadState extends State<InputWarehouseTypeAhead> {
  WarehouseSearchService _searchService = WarehouseSearchService();
  List<ModelWarehouse> search = <ModelWarehouse>[];

  @override
  void initState() {
    getDocs();
    super.initState();
  }

  Future getDocs() async {
    search = (await _searchService.getSearch()).map((item) {
      return ModelWarehouse(
          id: item.id,
          name: item.get('name'),
          address: item.get('address'),
          enabled: item.get('enabled'),
          group: item.get('group'));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return TypeAheadFormField<ModelWarehouse?>(
      hideSuggestionsOnKeyboardHide: true,
      debounceDuration: Duration(milliseconds: 500),
      textFieldConfiguration: TextFieldConfiguration(
        controller: widget.name,
        decoration: InputDecoration(
          prefixIcon: Icon(FontAwesomeIcons.warehouse),
          border: OutlineInputBorder(),
          hintText: 'Warehouse',
        ),
      ),
      suggestionsCallback: (pattern) {
        return search.where(
          (doc) => doc.name.toLowerCase().contains(pattern.toLowerCase()),
        );
      },
      itemBuilder: (context, ModelWarehouse? suggestion) {
        final warehouse = suggestion!;

        return ListTile(
          title: Text(warehouse.name),
        );
      },
      onSuggestionSelected: (ModelWarehouse? suggestion) {
        final warehouse = suggestion!;

        widget.name.text = warehouse.name;
      },
      validator: (value) =>
          value != null && value.isEmpty ? 'Please select a warehouse' : null,
    );
  }
}
