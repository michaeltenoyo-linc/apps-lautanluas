import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ltl_bulk/Shared/colors.dart';
import 'package:sweetalertv2/sweetalertv2.dart';

class ModelConsignee {
  final String id;
  final String name;
  final bool enabled;

  ModelConsignee({
    required this.id,
    required this.name,
    this.enabled = true,
  });
}

//CRUD
Future createConsignee({required ModelConsignee data}) async {
  try {
    final docConsignee =
        FirebaseFirestore.instance.collection('consignees').doc();

    final json = {
      'name': data.name,
      'enabled': data.enabled,
    };

    await docConsignee.set(json);
    return true;
  } catch (e) {
    print(e.toString());
    return false;
  }
}

Future updateConsignee({required ModelConsignee data}) async {
  try {
    final docConsignee =
        FirebaseFirestore.instance.collection('consignees').doc(data.id);

    final json = {
      'name': data.name,
    };

    await docConsignee.update(json);

    return true;
  } catch (e) {
    print(e.toString());
    return false;
  }
}

Future toggleConsigneeEnabled({required ModelConsignee data}) async {
  try {
    final docConsignee =
        FirebaseFirestore.instance.collection('consignees').doc(data.id);

    final json = {
      'enabled': data.enabled == true ? false : true,
    };

    await docConsignee.update(json);

    return true;
  } catch (e) {
    print(e.toString());
    return false;
  }
}

Future deleteConsignee({required ModelConsignee data}) async {
  try {
    final docConsignee =
        FirebaseFirestore.instance.collection('consignees').doc(data.id);

    await docConsignee.delete();
    return true;
  } catch (e) {
    print(e.toString());
    return false;
  }
}
//END CRUD

//BUILD DATATABLE FROM FIREBASE STREAM READ
ModelConsignee _fromFirestore(DocumentSnapshot snapshot) {
  return ModelConsignee(
      id: snapshot.id, name: snapshot['name'], enabled: snapshot['enabled']);
}

Widget streamConsigneeFirestoreDatatable(BuildContext context) {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection('consignees').snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return LinearProgressIndicator();

      return DataTable(
        columns: [
          DataColumn(label: Text('Firestore ID')),
          DataColumn(label: Text('Consignee')),
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
  final consignee = _fromFirestore(data);

  return DataRow(cells: [
    DataCell(Text(consignee.id)),
    DataCell(Text(consignee.name)),
    DataCell(Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        consignee.enabled == true
            ? ElevatedButton(
                style:
                    ElevatedButton.styleFrom(backgroundColor: kColorsGreen500),
                child: Icon(FontAwesomeIcons.check),
                onPressed: () async {
                  await toggleConsigneeEnabled(data: consignee);
                },
              )
            : ElevatedButton(
                style:
                    ElevatedButton.styleFrom(backgroundColor: kColorsGrey800),
                child: Icon(FontAwesomeIcons.ban),
                onPressed: () async {
                  await toggleConsigneeEnabled(data: consignee);
                },
              ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: kColorsAmber500),
          child: Icon(FontAwesomeIcons.penToSquare),
          onPressed: () async {
            final _formUpdate = GlobalKey<FormState>();
            final TextEditingController id = TextEditingController();
            final TextEditingController name = TextEditingController();

            //initial value
            id.text = consignee.id;
            name.text = consignee.name;

            showDialog(
                context: context,
                builder: (BuildContext ctx) {
                  return AlertDialog(
                    scrollable: true,
                    title: Text('Edit consignee'),
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
                            labelText: 'Consignee ID',
                            hintText: "Please input consignee's id",
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
                            labelText: 'Consignee Name',
                            hintText: "Please input consignee's name",
                            icon: Icon(FontAwesomeIcons.userGroup),
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
                                    final consignee = ModelConsignee(
                                      id: id.text,
                                      name: name.text,
                                    );

                                    bool result =
                                        await updateConsignee(data: consignee);

                                    id.clear();
                                    name.clear();

                                    if (result) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                            'Success! Update consignee has been saved.'),
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
                subtitle: "Do you want to delete this consignee ?",
                style: SweetAlertV2Style.confirm,
                showCancelButton: true, onPress: (bool isConfirm) {
              if (isConfirm) {
                new Future.delayed(new Duration(seconds: 0), () async {
                  await deleteConsignee(data: consignee);
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