import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ltl_bulk/Models/group.dart';
import 'package:ltl_bulk/Screens/Auth/widgets/welcome-background.dart';
import 'package:ltl_bulk/Screens/Global/widgets/widgets.dart';
import 'package:ltl_bulk/Shared/colors.dart';
import 'package:ltl_bulk/Shared/fonts.dart';
import 'package:ltl_bulk/Models/group.dart';
import 'package:sweetalertv2/sweetalertv2.dart';

class Group extends StatefulWidget {
  const Group({
    super.key,
    required this.openDrawer,
  });

  final VoidCallback openDrawer;

  @override
  State<Group> createState() => _GroupState();
}

class _GroupState extends State<Group> {
  int? sortColumnIndex;
  bool isAscending = false;
  //Dummy Data
  List<ModelGroup> groups = GroupFakerData.getAllData();

  final _formGroup = GlobalKey<FormState>();
  final TextEditingController name = TextEditingController();
  final TextEditingController description = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: DashboardAppBar(
        size: size,
        openDrawer: widget.openDrawer,
        title: 'Group',
      ),
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          WelcomeBackground(
              assetUrl: 'assets/images/backgrounds/group-master.png'),
          Center(
            child: Container(
              height: size.height * 0.8,
              width: size.width * 0.7,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: size.height * 0.05),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Container(
                    color: kLightColor,
                    padding: EdgeInsets.all(25.0),
                    child: SingleChildScrollView(
                        child: streamGroupFirestoreDatatable(context)),
                  ),
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
                          title: Text('New Group'),
                          content: Form(
                            key: _formGroup,
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
                                  icon: Icon(FontAwesomeIcons.peopleGroup),
                                ),
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
                                    if (_formGroup.currentState!.validate()) {
                                      SweetAlertV2.show(context,
                                          subtitle:
                                              "Do you want to save new group ?",
                                          style: SweetAlertV2Style.confirm,
                                          showCancelButton: true,
                                          onPress: (bool isConfirm) {
                                        if (isConfirm) {
                                          new Future.delayed(
                                              new Duration(seconds: 0),
                                              () async {
                                            //async function
                                            final group = ModelGroup(
                                              name: name.text,
                                              description: description.text,
                                            );

                                            bool result =
                                                await createGroup(data: group);

                                            name.clear();
                                            description.clear();

                                            if (result) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                content: Text(
                                                    'Success! New group has been saved.'),
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

  //BUILD DATATABLE FROM DUMMY STATIC DATA MODEL
  Widget buildDataTable() {
    final columns = ['Vehicle Number', 'Type'];

    return DataTable(
      sortAscending: isAscending,
      sortColumnIndex: sortColumnIndex,
      columns: getColumns(columns),
      rows: getRows(groups),
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

  List<DataRow> getRows(List<ModelGroup> groups) =>
      groups.map((ModelGroup group) {
        final cells = [group.name, group.description];

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
      groups.sort((group1, group2) =>
          compareString(ascending, '${group1.name}', '${group2.name}'));
    } else if (columnIndex == 1) {
      groups.sort((group1, group2) => compareString(
          ascending, '${group1.description}', '${group2.description}'));
    }

    setState(() {
      this.sortColumnIndex = columnIndex;
      this.isAscending = ascending;
    });
  }

  int compareString(bool ascending, String value1, String value2) =>
      ascending ? value1.compareTo(value2) : value2.compareTo(value1);

  //END BUILD DATATABLE
}
