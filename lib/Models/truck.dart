import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';

class ModelTruck {
  final String nopol;
  final String type;
  final bool enabled;

  ModelTruck({
    required this.nopol,
    required this.type,
    this.enabled = true,
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

//CRUD
Future createTruck({required ModelTruck data}) async {
  try {
    final docTruck =
        FirebaseFirestore.instance.collection('trucks').doc(data.nopol);

    final json = {
      'type': data.type,
      'enabled': data.enabled,
    };

    await docTruck.set(json);
    return true;
  } catch (e) {
    print(e.toString());
    return false;
  }
}
