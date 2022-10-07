import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:sweetalertv2/sweetalertv2.dart';

import '../Screens/Global/widgets/widgets.dart';
import '../Shared/colors.dart';

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
      'consignee': data.consignee,
    };

    await docTruck.set(json);
    return true;
  } catch (e) {
    print(e.toString());
    return false;
  }
}

Future updateLoad({required ModelLoad data}) async {
  try {
    final docLoad = FirebaseFirestore.instance.collection('loads').doc(data.id);

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
      'consignee': data.consignee,
    };

    await docLoad.update(json);

    return true;
  } catch (e) {
    print(e.toString());
    return false;
  }
}

Future deleteLoad({required ModelLoad data}) async {
  try {
    final docTruck =
        FirebaseFirestore.instance.collection('loads').doc(data.id);

    await docTruck.delete();
    return true;
  } catch (e) {
    print(e.toString());
    return false;
  }
}
//END CRUD

//BUILD DATATABLE FROM FIREBASE STREAM READ
ModelLoad _fromFirestore(DocumentSnapshot snapshot) {
  return ModelLoad(
    id: snapshot.id,
    nopol: snapshot['nopol'],
    carrier: snapshot['carrier'],
    truck_in: snapshot['truck_in'].toDate(),
    truck_out: snapshot['truck_out'].toDate(),
    date: snapshot['date'].toDate(),
    weight_empty: snapshot['weight_empty'],
    weight_full: snapshot['weight_full'],
    net_weight: snapshot['net_weight'],
    warehouse: snapshot['warehouse'],
    palka: snapshot['palka'],
    shift: snapshot['shift'],
    grabber: snapshot['grabber'],
    crane: snapshot['crane'],
    note: snapshot['note'],
    consignee: snapshot['consignee'],
  );
}

Widget streamLoadFirestoreDatatable(
    BuildContext context, String warehouse, String shift, DateTime date) {
  CollectionReference ref = FirebaseFirestore.instance.collection('loads');
  if (warehouse != 'all') ref.where('warehouse', isEqualTo: warehouse);
  ref.where('shift', isEqualTo: shift);
  ref.where('date', isEqualTo: date);

  return StreamBuilder<QuerySnapshot>(
    stream: ref.orderBy('truck_in').snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return LinearProgressIndicator();

      return DataTable(
        columns: [
          DataColumn(label: Text('Entry')),
          DataColumn(label: Text('Carrier')),
          DataColumn(label: Text('Shift')),
          DataColumn(label: Text('Vehicle')),
          DataColumn(label: Text('Net Weight')),
          DataColumn(label: Text('')),
        ],
        rows: _buildList(context, snapshot.data!.docs),
      );
    },
  );
}

class LoadDatatable extends StatefulWidget {
  const LoadDatatable({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  State<LoadDatatable> createState() => _LoadDatatableState();
}

class _LoadDatatableState extends State<LoadDatatable> {
  bool firstLoad = true;
  late var ref;
  Stream? filterStream;

  TextEditingController filterDate = TextEditingController();

  late DropdownKeyValue? shiftValue;
  late DropdownKeyValue? filterWarehouse;

  final List<DropdownKeyValue> itemsShift = <DropdownKeyValue>[
    DropdownKeyValue('1', 'Shift 1 (08:00 - 16:00)'),
    DropdownKeyValue('2', 'Shift 2 (16:00 - 24:00)'),
    DropdownKeyValue('3', 'Shift 3 (00:00 - 08:00)'),
  ];

  List<DropdownKeyValue> itemsWarehouse = [
    DropdownKeyValue('all', 'All'),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //INIT VALUE
    this.shiftValue = itemsShift[0];
    this.filterWarehouse = itemsWarehouse[0];
    this.filterDate.text = DateFormat('yyyy-MM-dd').format(DateTime.now());

    //Init Datatable
    refreshDatatableReference();
  }

  void refreshDatatableReference() {
    setState(() {
      ref = FirebaseFirestore.instance.collection('loads');
      if (filterWarehouse!.key.toString() != 'all') {
        ref =
            ref.where('warehouse', isEqualTo: filterWarehouse!.key.toString());
      }

      ref = ref.where(
        'date',
        isEqualTo: DateFormat("yyyy-MM-dd").parse(filterDate.text),
      );
      ref = ref.where('shift', isEqualTo: int.parse(shiftValue!.key));
      //ref = ref.orderBy('truck_in');
      ref = ref.snapshots();
      filterStream = ref;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          height: widget.size.height * 0.1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: widget.size.width * .01,
                  ),
                  child: InputDate(
                      date: filterDate,
                      context: context,
                      onChanged: (value) {
                        this.filterDate.text = value;
                        refreshDatatableReference();
                      },
                      label: 'Load Date'),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: widget.size.width * .01,
                  ),
                  child: InputDropdown(
                    value: shiftValue,
                    items: itemsShift,
                    onChanged: (value) => setState(() {
                      this.shiftValue = value;
                      refreshDatatableReference();
                    }),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: widget.size.width * .01,
                  ),
                  child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("warehouses")
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData)
                          return Text("Loading.....");
                        else {
                          if (firstLoad) {
                            for (int i = 0;
                                i < snapshot.data!.docs.length;
                                i++) {
                              DocumentSnapshot snap = snapshot.data!.docs[i];
                              itemsWarehouse.add(DropdownKeyValue(
                                  snap.get('name'), snap.get('name')));
                            }

                            firstLoad = false;
                          }

                          return InputDropdown(
                            value: filterWarehouse,
                            items: itemsWarehouse,
                            onChanged: (value) => setState(() {
                              this.filterWarehouse = value;
                              refreshDatatableReference();
                            }),
                            hintLabel: 'Please choose warehouse',
                          );
                        }
                      }),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            width: widget.size.width * 0.8,
            child: SingleChildScrollView(
              child: StreamBuilder(
                stream: filterStream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return LinearProgressIndicator();

                  return DataTable(
                    columns: [
                      DataColumn(label: Text('Entry')),
                      DataColumn(label: Text('Carrier')),
                      DataColumn(label: Text('Shift')),
                      DataColumn(label: Text('Vehicle')),
                      DataColumn(label: Text('Net Weight')),
                      DataColumn(label: Text('')),
                    ],
                    rows: _buildList(context, snapshot.data!.docs),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

List<DataRow> _buildList(
    BuildContext context, List<DocumentSnapshot> snapshot) {
  return snapshot.map((data) => _buildListItem(context, data)).toList();
}

DataRow _buildListItem(BuildContext context, DocumentSnapshot data) {
  final load = _fromFirestore(data);

  return DataRow(cells: [
    DataCell(Text(DateFormat('HH:MM:ss').format(load.truck_in))),
    DataCell(Text(load.carrier)),
    DataCell(Text(load.shift.toString())),
    DataCell(Text(load.nopol)),
    DataCell(Text(load.net_weight.toString())),
    DataCell(
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: kColorsBlue500),
            child: Icon(FontAwesomeIcons.truckField),
            onPressed: () {},
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: kColorsRed500),
            child: Icon(FontAwesomeIcons.trash),
            onPressed: () {
              SweetAlertV2.show(context,
                  subtitle: "Do you want to delete this load ?",
                  style: SweetAlertV2Style.confirm,
                  showCancelButton: true, onPress: (bool isConfirm) {
                if (isConfirm) {
                  new Future.delayed(new Duration(seconds: 0), () async {
                    await deleteLoad(data: load);
                  });
                }

                return true;
              });
            },
          ),
        ],
      ),
    ),
  ]);
}
//END BUILD FIREBASE DATATABLE