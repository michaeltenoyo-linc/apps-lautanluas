import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:ltl_bulk/Shared/colors.dart';
import 'package:ltl_bulk/Shared/fonts.dart';

class InputDropdown extends StatelessWidget {
  const InputDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final DropdownKeyValue? value;
  final List<DropdownKeyValue> items;
  final dynamic Function(DropdownKeyValue?) onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: kDarkColor,
          width: 1,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<DropdownKeyValue>(
          hint: Text('Shift'),
          value: this.value,
          isExpanded: true,
          items: items.map(buildMenuItem).toList(),
          onChanged: ((e) => {this.onChanged(e)}),
        ),
      ),
    );
  }

  DropdownMenuItem<DropdownKeyValue> buildMenuItem(item) =>
      DropdownMenuItem<DropdownKeyValue>(
        child: Text(
          item.value,
          style: kTextDarkXl,
        ),
        value: item,
      );
}

class DropdownKeyValue {
  const DropdownKeyValue(this.key, this.value);

  final String value;
  final String key;
}
