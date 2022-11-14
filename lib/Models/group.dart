import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ltl_bulk/Shared/colors.dart';
import 'package:sweetalertv2/sweetalertv2.dart';

class ModelGroup {
  final String name;
  final String description;
  final bool enabled;

  ModelGroup({
    required this.name,
    required this.description,
    this.enabled = true,
  });
}

//READ
class GroupFakerData {
  static final faker = Faker();
  static final List<ModelGroup> groups = List.generate(
      50,
      (index) => ModelGroup(
            name: faker.company.name(),
            description: faker.lorem.sentence(),
          ));

  static List<ModelGroup> getSuggestions(String query) =>
      List.of(groups).where((group) {
        final groupLower = group.name.toLowerCase();
        final queryLower = query.toLowerCase();

        return groupLower.contains(queryLower);
      }).toList();

  static List<ModelGroup> getAllData() => List.of(groups).toList();
}

class GroupSearchService {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String ref = 'groups';

  Future<List<DocumentSnapshot>> getSearch() async =>
      await _firestore.collection(ref).get().then((snaps) {
        return snaps.docs;
      });
}

//CRUD
Future createGroup({required ModelGroup data}) async {
  try {
    final docGroup =
        FirebaseFirestore.instance.collection('groups').doc(data.name);

    final json = {
      'description': data.description,
      'enabled': data.enabled,
    };

    await docGroup.set(json);
    return true;
  } catch (e) {
    print(e.toString());
    return false;
  }
}

Future updateGroup({required ModelGroup data}) async {
  try {
    final docGroup =
        FirebaseFirestore.instance.collection('groups').doc(data.name);

    final json = {
      'description': data.description,
    };

    await docGroup.update(json);

    return true;
  } catch (e) {
    print(e.toString());
    return false;
  }
}

Future toggleGroupEnabled({required ModelGroup data}) async {
  try {
    final docGroup =
        FirebaseFirestore.instance.collection('groups').doc(data.name);

    final json = {
      'enabled': data.enabled == true ? false : true,
    };

    await docGroup.update(json);

    return true;
  } catch (e) {
    print(e.toString());
    return false;
  }
}

Future deleteGroup({required ModelGroup data}) async {
  try {
    final docGroup =
        FirebaseFirestore.instance.collection('groups').doc(data.name);

    await docGroup.delete();
    return true;
  } catch (e) {
    print(e.toString());
    return false;
  }
}
//END CRUD

//BUILD DATATABLE FROM FIREBASE STREAM READ
ModelGroup _fromFirestore(DocumentSnapshot snapshot) {
  return ModelGroup(
      name: snapshot.id,
      description: snapshot['description'],
      enabled: snapshot['enabled']);
}

Widget streamGroupFirestoreDatatable(BuildContext context) {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection('groups').snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return LinearProgressIndicator();

      return DataTable(
        columns: [
          DataColumn(label: Text('Name')),
          DataColumn(label: Text('Description')),
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
  final group = _fromFirestore(data);

  return DataRow(cells: [
    DataCell(Text(group.name)),
    DataCell(Text(group.description)),
    DataCell(Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        group.enabled == true
            ? ElevatedButton(
                style:
                    ElevatedButton.styleFrom(backgroundColor: kColorsGreen500),
                child: Icon(FontAwesomeIcons.check),
                onPressed: () async {
                  await toggleGroupEnabled(data: group);
                },
              )
            : ElevatedButton(
                style:
                    ElevatedButton.styleFrom(backgroundColor: kColorsGrey800),
                child: Icon(FontAwesomeIcons.ban),
                onPressed: () async {
                  await toggleGroupEnabled(data: group);
                },
              ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: kColorsAmber500),
          child: Icon(FontAwesomeIcons.penToSquare),
          onPressed: () async {
            final _formUpdate = GlobalKey<FormState>();
            final TextEditingController name = TextEditingController();
            final TextEditingController description = TextEditingController();

            //initial value
            name.text = group.name;
            description.text = group.description;

            showDialog(
                context: context,
                builder: (BuildContext ctx) {
                  return AlertDialog(
                    scrollable: true,
                    title: Text('Edit Group'),
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
                          controller: name,
                          decoration: InputDecoration(
                            labelText: 'Group Name',
                            hintText: "Please input group's name",
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
                          controller: description,
                          decoration: InputDecoration(
                            labelText: 'Group Description',
                            hintText: "Please input group's description",
                            icon: Icon(FontAwesomeIcons.alignJustify),
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
                                    final group = ModelGroup(
                                      name: name.text,
                                      description: description.text,
                                    );

                                    bool result =
                                        await updateGroup(data: group);

                                    name.clear();
                                    description.clear();

                                    if (result) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                            'Success! Updated group has been saved.'),
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
                subtitle: "Do you want to delete this group ?",
                style: SweetAlertV2Style.confirm,
                showCancelButton: true, onPress: (bool isConfirm) {
              if (isConfirm) {
                new Future.delayed(new Duration(seconds: 0), () async {
                  await deleteGroup(data: group);
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