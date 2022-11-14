import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ltl_bulk/Models/warehouse.dart';
import 'package:ltl_bulk/Screens/Auth/widgets/welcome-background.dart';
import 'package:ltl_bulk/Screens/Global/widgets/widgets.dart';
import 'package:ltl_bulk/Shared/colors.dart';
import 'package:ltl_bulk/Shared/fonts.dart';
import 'package:sweetalertv2/sweetalertv2.dart';

class Warehouse extends StatefulWidget {
  const Warehouse({
    super.key,
    required this.openDrawer,
  });

  final VoidCallback openDrawer;

  @override
  State<Warehouse> createState() => _WarehouseState();
}

class _WarehouseState extends State<Warehouse> {
  final _formWarehouse = GlobalKey<FormState>();
  final TextEditingController name = TextEditingController();
  final TextEditingController address = TextEditingController();

  final List<DropdownKeyValue> itemsGroup = <DropdownKeyValue>[
    DropdownKeyValue('surabaya', 'Surabaya'),
    DropdownKeyValue('jakarta', 'Jakarta'),
  ];

  late DropdownKeyValue? groupValue;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    this.groupValue = itemsGroup[0];
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: DashboardAppBar(
        size: size,
        openDrawer: widget.openDrawer,
        title: 'Warehouse',
      ),
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          WelcomeBackground(
              assetUrl: 'assets/images/backgrounds/warehouse-master.png'),
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
                        child: streamWarehouseFirestoreDatatable(context)),
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
                          title: Text('New Warehouse'),
                          content: Form(
                            key: _formWarehouse,
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
                                  labelText: 'Warehouse Name',
                                  hintText: "Please input warehouse name",
                                  icon: Icon(FontAwesomeIcons.warehouse),
                                ),
                              ),
                              InputDropdown(
                                value: groupValue,
                                items: itemsGroup,
                                onChanged: (value) => setState(() {
                                  this.groupValue = value;
                                }),
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
                                  hintText: "Please input warehouse's location",
                                  icon: Icon(FontAwesomeIcons.locationDot),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    if (_formWarehouse.currentState!
                                        .validate()) {
                                      SweetAlertV2.show(context,
                                          subtitle:
                                              "Do you want to save new warehouse ?",
                                          style: SweetAlertV2Style.confirm,
                                          showCancelButton: true,
                                          onPress: (bool isConfirm) {
                                        if (isConfirm) {
                                          new Future.delayed(
                                              new Duration(seconds: 0),
                                              () async {
                                            //async function
                                            final warehouse = ModelWarehouse(
                                              name: name.text,
                                              address: address.text,
                                              group: groupValue!.key,
                                              id: 'auto',
                                            );

                                            bool result = await createWarehouse(
                                                data: warehouse);

                                            name.clear();
                                            address.clear();

                                            if (result) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                content: Text(
                                                    'Success! New warehouse has been saved.'),
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
          ),
        ],
      ),
    );
  }
}
