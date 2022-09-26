import 'package:faker/faker.dart';
import 'package:flutter/material.dart';

class ModelWarehouse {
  final String id;
  final String name;
  final String address;

  ModelWarehouse({
    required this.id,
    required this.name,
    required this.address,
  });
}

//Dummy Data
class WarehouseFakerData {
  static final faker = Faker();
  static final List<ModelWarehouse> warehouses = List.generate(
      50,
      (index) => ModelWarehouse(
            id: faker.randomGenerator.integer(1000).toString(),
            name: faker.company.name(),
            address: faker.company.position(),
          ));

  static List<ModelWarehouse> getSuggestions(String query) =>
      List.of(warehouses).where((warehouse) {
        final warehouseLower = warehouse.name.toLowerCase();
        final queryLower = query.toLowerCase();

        return warehouseLower.contains(queryLower);
      }).toList();
}
