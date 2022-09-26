import 'package:faker/faker.dart';
import 'package:flutter/material.dart';

class ModelLoad {
  final String id;
  final String nopol;
  final double weight_empty;
  final double weight_full;
  final double net_weight;
  final String warehouse;
  final String carrier;
  final int palka;
  final double weight;
  final DateTime date;
  final int shift;
  final TimeOfDay truck_in;
  final TimeOfDay truck_out;
  final String grabber;
  final String crane;
  final String note;

  ModelLoad({
    required this.id,
    required this.nopol,
    required this.weight_empty,
    required this.weight_full,
    required this.net_weight,
    required this.warehouse,
    required this.carrier,
    required this.palka,
    required this.weight,
    required this.date,
    required this.shift,
    required this.truck_in,
    required this.truck_out,
    required this.grabber,
    required this.crane,
    required this.note,
  });
}

//Dummy Data
class LoadFakerData {
  static final faker = Faker();
  static final List<ModelLoad> loads = List.generate(
      50,
      (index) => ModelLoad(
            id: faker.vehicle.vin(),
            nopol: faker.vehicle.vin(),
            weight_empty:
                faker.randomGenerator.integer(15000, min: 10000).toDouble(),
            weight_full:
                faker.randomGenerator.integer(50000, min: 45000).toDouble(),
            net_weight:
                faker.randomGenerator.integer(40000, min: 35000).toDouble(),
            warehouse: faker.company.name(),
            carrier: faker.vehicle.model(),
            palka: faker.randomGenerator.integer(5, min: 1),
            weight: faker.randomGenerator.integer(40000, min: 35000).toDouble(),
            date: faker.date.dateTime(),
            shift: faker.randomGenerator.integer(3, min: 1),
            truck_in: TimeOfDay.fromDateTime(faker.date.dateTime()),
            truck_out: TimeOfDay.fromDateTime(faker.date.dateTime()),
            grabber: 'ltl-ves 01',
            crane: 'kapal',
            note: 'None',
          ));
}
