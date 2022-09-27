import 'package:faker/faker.dart';
import 'package:flutter/material.dart';

class ModelTruck {
  final String nopol;
  final String type;

  ModelTruck({
    required this.nopol,
    required this.type,
  });
}

//Dummy Data
class TruckFakerData {
  static final faker = Faker();
  static final List<ModelTruck> trucks = List.generate(
      50,
      (index) => ModelTruck(
            nopol: faker.vehicle.vin(),
            type: faker.vehicle.model(),
          ));

  static List<ModelTruck> getSuggestions(String query) =>
      List.of(trucks).where((truck) {
        final truckLower = truck.nopol.toLowerCase();
        final queryLower = query.toLowerCase();

        return truckLower.contains(queryLower);
      }).toList();

  static List<ModelTruck> getAllData() => List.of(trucks).toList();
}
