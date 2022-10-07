import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ltl_bulk/Screens/Global/widgets/input-dropdown.dart';
import 'package:sweetalertv2/sweetalertv2.dart';

import '../Shared/colors.dart';

class ModelWarehouse {
  final String id;
  final String name;
  final String address;
  final bool enabled;

  ModelWarehouse({
    required this.id,
    required this.name,
    required this.address,
    this.enabled = true,
  });
}

//Serach Data
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

class WarehouseSearchService {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String ref = 'warehouses';

  Future<List<DocumentSnapshot>> getSearch() async =>
      await _firestore.collection(ref).get().then((snaps) {
        return snaps.docs;
      });
}

//CRUD
Future createWarehouse({required ModelWarehouse data}) async {
  try {
    final docWarehouse =
        FirebaseFirestore.instance.collection('warehouses').doc();

    final json = {
      'name': data.name,
      'address': data.address,
      'enabled': data.enabled,
    };

    await docWarehouse.set(json);
    return true;
  } catch (e) {
    print(e.toString());
    return false;
  }
}

Future updateWarehouse({required ModelWarehouse data}) async {
  try {
    final docWarehouse =
        FirebaseFirestore.instance.collection('warehouses').doc(data.id);

    final json = {
      'name': data.name,
      'address': data.address,
    };

    await docWarehouse.update(json);

    return true;
  } catch (e) {
    print(e.toString());
    return false;
  }
}

Future toggleWarehouseEnabled({required ModelWarehouse data}) async {
  try {
    final docWarehouse =
        FirebaseFirestore.instance.collection('warehouses').doc(data.id);

    final json = {
      'enabled': data.enabled == true ? false : true,
    };

    await docWarehouse.update(json);

    return true;
  } catch (e) {
    print(e.toString());
    return false;
  }
}

Future deleteWarehouse({required ModelWarehouse data}) async {
  try {
    final docWarehouse =
        FirebaseFirestore.instance.collection('warehouses').doc(data.id);

    await docWarehouse.delete();
    return true;
  } catch (e) {
    print(e.toString());
    return false;
  }
}
//END CRUD

//BUILD DATATABLE FROM FIREBASE STREAM READ
ModelWarehouse _fromFirestore(DocumentSnapshot snapshot) {
  return ModelWarehouse(
      id: snapshot.id,
      name: snapshot['name'],
      address: snapshot['address'],
      enabled: snapshot['enabled']);
}

Widget streamWarehouseFirestoreDatatable(BuildContext context) {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection('warehouses').snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return LinearProgressIndicator();

      return DataTable(
        columns: [
          DataColumn(label: Text('Warehouse Name')),
          DataColumn(label: Text('Address')),
          DataColumn(label: Text('')),
        ],
        rows: _buildList(context, snapshot.data!.docs),
      );
    },
  );
}

List<DataRow> _buildList(
    BuildContext context, List<DocumentSnapshot> snapshot) {
  return snapshot.map((data) => _buildListItem(context, data)).toList();
}

DataRow _buildListItem(BuildContext context, DocumentSnapshot data) {
  final warehouse = _fromFirestore(data);

  return DataRow(cells: [
    DataCell(Text(warehouse.name)),
    DataCell(Text(warehouse.address)),
    DataCell(Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        warehouse.enabled
            ? ElevatedButton(
                style:
                    ElevatedButton.styleFrom(backgroundColor: kColorsGreen500),
                child: Icon(FontAwesomeIcons.check),
                onPressed: () async {
                  await toggleWarehouseEnabled(data: warehouse);
                },
              )
            : ElevatedButton(
                style:
                    ElevatedButton.styleFrom(backgroundColor: kColorsGrey800),
                child: Icon(FontAwesomeIcons.cross),
                onPressed: () async {
                  await toggleWarehouseEnabled(data: warehouse);
                },
              ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: kColorsAmber500),
          child: Icon(FontAwesomeIcons.penToSquare),
          onPressed: () async {
            final _formUpdate = GlobalKey<FormState>();
            final TextEditingController id = TextEditingController();
            final TextEditingController name = TextEditingController();
            final TextEditingController address = TextEditingController();

            //initial value
            id.text = warehouse.id;
            name.text = warehouse.name;
            address.text = warehouse.address;

            showDialog(
                context: context,
                builder: (BuildContext ctx) {
                  return AlertDialog(
                    scrollable: true,
                    title: Text('Edit Warehouse'),
                    content: Form(
                      key: _formUpdate,
                      child: Column(children: [
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the right value.';
                            }
                            return null;
                          },
                          controller: id,
                          decoration: InputDecoration(
                            labelText: 'Warehouse ID',
                            hintText: "Please input warehouse's name",
                            icon: Icon(FontAwesomeIcons.barcode),
                          ),
                          readOnly: true,
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the right value.';
                            }
                            return null;
                          },
                          controller: name,
                          decoration: InputDecoration(
                            labelText: 'Warehouse Name',
                            hintText: "Please input warehouse's name",
                            icon: Icon(FontAwesomeIcons.warehouse),
                          ),
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the right value.';
                            }
                            return null;
                          },
                          controller: address,
                          decoration: InputDecoration(
                            labelText: 'Location Address',
                            hintText: "Please input warehouse's address",
                            icon: Icon(FontAwesomeIcons.locationDot),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (_formUpdate.currentState!.validate()) {
                              SweetAlertV2.show(context,
                                  subtitle: "Do you want to save update ?",
                                  style: SweetAlertV2Style.confirm,
                                  showCancelButton: true,
                                  onPress: (bool isConfirm) {
                                if (isConfirm) {
                                  new Future.delayed(new Duration(seconds: 0),
                                      () async {
                                    //async function
                                    final warehouse = ModelWarehouse(
                                      id: id.text,
                                      name: name.text,
                                      address: address.text,
                                    );

                                    bool result =
                                        await updateWarehouse(data: warehouse);

                                    name.clear();
                                    address.clear();

                                    if (result) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                            'Success! Update warehouse has been saved.'),
                                        duration: Duration(milliseconds: 2000),
                                      ));
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content:
                                            Text('Error! Please try again...'),
                                        duration: Duration(milliseconds: 2000),
                                      ));
                                    }

                                    Navigator.pop(context);
                                  });
                                }
                                return true;
                              });
                            }
                          },
                          child: Text('Update'),
                        ),
                      ]),
                    ),
                  );
                });
          },
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: kColorsRed500),
          child: Icon(FontAwesomeIcons.trash),
          onPressed: () {
            SweetAlertV2.show(context,
                subtitle: "Do you want to delete this warehouse ?",
                style: SweetAlertV2Style.confirm,
                showCancelButton: true, onPress: (bool isConfirm) {
              if (isConfirm) {
                new Future.delayed(new Duration(seconds: 0), () async {
                  await deleteWarehouse(data: warehouse);
                });
              }

              return true;
            });
          },
        ),
      ],
    ))
  ]);
}
//END BUILD FIREBASE DATATABLE