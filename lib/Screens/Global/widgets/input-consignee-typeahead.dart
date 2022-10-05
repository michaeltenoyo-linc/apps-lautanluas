import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ltl_bulk/Models/consignee.dart';

class InputConsigneeTypeAhead extends StatefulWidget {
  const InputConsigneeTypeAhead({
    Key? key,
    required this.name,
  }) : super(key: key);

  final TextEditingController name;

  @override
  State<InputConsigneeTypeAhead> createState() =>
      _InputConsigneeTypeAheadState();
}

class _InputConsigneeTypeAheadState extends State<InputConsigneeTypeAhead> {
  ConsigneeSearchService _searchService = ConsigneeSearchService();
  List<ModelConsignee> search = <ModelConsignee>[];

  @override
  void initState() {
    getDocs();
    super.initState();
  }

  Future getDocs() async {
    search = (await _searchService.getSearch()).map((item) {
      return ModelConsignee(
        id: item.id,
        name: item.get('name'),
        enabled: item.get('enabled'),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return TypeAheadFormField<ModelConsignee?>(
      hideSuggestionsOnKeyboardHide: true,
      debounceDuration: Duration(milliseconds: 500),
      textFieldConfiguration: TextFieldConfiguration(
        controller: widget.name,
        decoration: InputDecoration(
          prefixIcon: Icon(FontAwesomeIcons.userGroup),
          border: OutlineInputBorder(),
          hintText: 'Consignee',
        ),
      ),
      suggestionsCallback: (pattern) {
        return search.where(
          (doc) => doc.name.toLowerCase().contains(pattern.toLowerCase()),
        );
      },
      itemBuilder: (context, ModelConsignee? suggestion) {
        final consignee = suggestion!;

        return ListTile(
          title: Text(consignee.name),
        );
      },
      onSuggestionSelected: (ModelConsignee? suggestion) {
        final consignee = suggestion!;

        widget.name.text = consignee.name;
      },
      validator: (value) =>
          value != null && value.isEmpty ? 'Please select a consignee' : null,
    );
  }
}
