import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  //Collection Reference
  final CollectionReference loads =
      FirebaseFirestore.instance.collection('loads');

  final CollectionReference trucks =
      FirebaseFirestore.instance.collection('trucks');
}
