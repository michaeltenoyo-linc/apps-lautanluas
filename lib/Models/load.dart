import 'package:cloud_firestore/cloud_firestore.dart';
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
  final String consignee;
  final int palka;
  final DateTime date;
  final int shift;
  final DateTime truck_in;
  final DateTime truck_out;
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
    required this.consignee,
    required this.palka,
    required this.date,
    required this.shift,
    required this.truck_in,
    required this.truck_out,
    required this.grabber,
    required this.crane,
    required this.note,
  });
}

//CRUD
Future createLoad({required ModelLoad data}) async {
  try {
    final docTruck = FirebaseFirestore.instance.collection('loads').doc();

    final json = {
      'nopol': data.nopol,
      'carrier': data.carrier,
      'truck_in': data.truck_in,
      'truck_out': data.truck_out,
      'date': data.date,
      'weight_empty': data.weight_empty,
      'weight_full': data.weight_full,
      'net_weight': data.net_weight,
      'warehouse': data.warehouse,
      'palka': data.palka,
      'shift': data.shift,
      'grabber': data.grabber,
      'crane': data.crane,
      'note': data.note,
    };

    await docTruck.set(json);
    return true;
  } catch (e) {
    print(e.toString());
    return false;
  }
}
