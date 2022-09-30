import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ltl_bulk/Screens/Global/widgets/widgets.dart';
import 'package:ltl_bulk/Shared/colors.dart';
import 'package:ltl_bulk/Shared/fonts.dart';
import 'package:ltl_bulk/Models/truck.dart';
import 'package:sweetalertv2/sweetalertv2.dart';

class Truck extends StatefulWidget {
  const Truck({
    super.key,
    required this.openDrawer,
  });

  final VoidCallback openDrawer;

  @override
  State<Truck> createState() => _TruckState();
}

class _TruckState extends State<Truck> {
  int? sortColumnIndex;
  bool isAscending = false;
  //Dummy Data
  List<ModelTruck> trucks = TruckFakerData.getAllData();

  final _formTruck = GlobalKey<FormState>();
  final TextEditingController nopol = TextEditingController();
  final TextEditingController type = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: DashboardAppBar(
        size: size,
        openDrawer: widget.openDrawer,
        title: 'Truck',
      ),
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: size.height * 0.05),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Container(
                  color: kLightColor,
                  padding: EdgeInsets.all(25.0),
                  child: SingleChildScrollView(child: buildDataTable()),
                ),
              ),
            ),
          ),
          Positioned(
            right: size.width * 0.05,
            bottom: size.height * 0.05,
            child: Container(
              width: size.width * 0.08,
              height: size.width * 0.08,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(shape: CircleBorder()),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          scrollable: true,
                          title: Text('New Truck'),
                          content: Form(
                            key: _formTruck,
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
                                    if (_formTruck.currentState!.validate()) {
                                      SweetAlertV2.show(context,
                                          subtitle: "Do you want to logout ?",
                                          style: SweetAlertV2Style.confirm,
                                          showCancelButton: true,
                                          onPress: (bool isConfirm) {
                                        if (isConfirm) {
                                          new Future.delayed(
                                              new Duration(seconds: 0),
                                              () async {
                                            //async function
                                            final truck = ModelTruck(
                                              nopol: nopol.text,
                                              type: type.text,
                                            );

                                            bool result =
                                                await createTruck(data: truck);

                                            nopol.clear();
                                            type.clear();

                                            if (result) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                content: Text(
                                                    'Success! New truck has been saved.'),
                                                duration: Duration(
                                                    milliseconds: 2000),
                                              ));
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                content: Text(
                                                    'Error! Please try again...'),
                                                duration: Duration(
                                                    milliseconds: 2000),
                                              ));
                                            }

                                            Navigator.pop(context);
                                          });
                                        }
                                        return true;
                                      });
                                    }
                                  },
                                  child: Text('Create')),
                            ]),
                          ),
                        );
                      });
                },
                child: Icon(FontAwesomeIcons.plus),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildDataTable() {
    final columns = ['Vehicle Number', 'Type'];

    return DataTable(
      sortAscending: isAscending,
      sortColumnIndex: sortColumnIndex,
      columns: getColumns(columns),
      rows: getRows(trucks),
    );
  }

  List<DataColumn> getColumns(List<String> columns) => columns
      .map((String col) => DataColumn(
          onSort: onSort,
          label: Text(
            col,
            style: kTextDarkBoldXl,
          )))
      .toList();

  List<DataRow> getRows(List<ModelTruck> trucks) =>
      trucks.map((ModelTruck truck) {
        final cells = [truck.nopol, truck.type];

        return DataRow(cells: getCells(cells));
      }).toList();

  List<DataCell> getCells(List<dynamic> cells) => cells
      .map((data) => DataCell(Text(
            '$data',
            style: kTextDarkBase,
          )))
      .toList();

  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      trucks.sort((truck1, truck2) =>
          compareString(ascending, '${truck1.nopol}', '${truck2.nopol}'));
    } else if (columnIndex == 1) {
      trucks.sort((truck1, truck2) =>
          compareString(ascending, '${truck1.type}', '${truck2.type}'));
    }

    setState(() {
      this.sortColumnIndex = columnIndex;
      this.isAscending = ascending;
    });
  }

  int compareString(bool ascending, String value1, String value2) =>
      ascending ? value1.compareTo(value2) : value2.compareTo(value1);
}
