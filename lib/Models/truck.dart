import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ltl_bulk/Shared/colors.dart';
import 'package:sweetalertv2/sweetalertv2.dart';

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

//Suggestion Dummy Data
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

Future updateTruck({required ModelTruck data}) async {
  try {
    final docTruck =
        FirebaseFirestore.instance.collection('trucks').doc(data.nopol);

    final json = {
      'type': data.type,
    };

    await docTruck.update(json);

    return true;
  } catch (e) {
    print(e.toString());
    return false;
  }
}

Future deleteTruck({required ModelTruck data}) async {
  try {
    final docTruck =
        FirebaseFirestore.instance.collection('trucks').doc(data.nopol);

    await docTruck.delete();
    return true;
  } catch (e) {
    print(e.toString());
    return false;
  }
}
//END CRUD

//BUILD DATATABLE FROM FIREBASE STREAM READ
ModelTruck _fromFirestore(DocumentSnapshot snapshot) {
  return ModelTruck(nopol: snapshot.id, type: snapshot['type']);
}

Widget streamTruckFirestoreDatatable(BuildContext context) {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection('trucks').snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return LinearProgressIndicator();

      return DataTable(
        columns: [
          DataColumn(label: Text('Vehicle Number')),
          DataColumn(label: Text('Type')),
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
  final truck = _fromFirestore(data);
  TextEditingController type = TextEditingController();

  return DataRow(cells: [
    DataCell(Text(truck.nopol)),
    DataCell(Text(truck.type)),
    DataCell(Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        truck.enabled
            ? ElevatedButton(
                style:
                    ElevatedButton.styleFrom(backgroundColor: kColorsGreen500),
                child: Icon(FontAwesomeIcons.check),
                onPressed: () {},
              )
            : ElevatedButton(
                style:
                    ElevatedButton.styleFrom(backgroundColor: kColorsGrey800),
                child: Icon(FontAwesomeIcons.cross),
                onPressed: () {},
              ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: kColorsAmber500),
          child: Icon(FontAwesomeIcons.penToSquare),
          onPressed: () async {
            final _formUpdate = GlobalKey<FormState>();
            final TextEditingController type = TextEditingController();
            final TextEditingController nopol = TextEditingController();

            //initial value
            nopol.text = truck.nopol;
            type.text = truck.type;

            showDialog(
                context: context,
                builder: (BuildContext ctx) {
                  return AlertDialog(
                    scrollable: true,
                    title: Text('Edit Truck'),
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
                          controller: nopol,
                          decoration: InputDecoration(
                            labelText: 'Vehicle Number',
                            hintText: "Please input truck's id",
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
                          controller: type,
                          decoration: InputDecoration(
                            labelText: 'Vehicle Type',
                            hintText: "Please input truck's type",
                            icon: Icon(FontAwesomeIcons.truck),
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
                                    final truck = ModelTruck(
                                      nopol: nopol.text,
                                      type: type.text,
                                    );

                                    bool result =
                                        await updateTruck(data: truck);

                                    nopol.clear();
                                    type.clear();

                                    if (result) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                            'Success! Update truck has been saved.'),
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
                subtitle: "Do you want to delete this truck ?",
                style: SweetAlertV2Style.confirm,
                showCancelButton: true, onPress: (bool isConfirm) {
              if (isConfirm) {
                new Future.delayed(new Duration(seconds: 0), () async {
                  await deleteTruck(data: truck);
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