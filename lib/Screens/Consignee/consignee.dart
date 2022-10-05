import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ltl_bulk/Models/Consignee.dart';
import 'package:ltl_bulk/Screens/Auth/widgets/welcome-background.dart';
import 'package:ltl_bulk/Screens/Global/widgets/widgets.dart';
import 'package:ltl_bulk/Shared/colors.dart';
import 'package:ltl_bulk/Shared/fonts.dart';
import 'package:sweetalertv2/sweetalertv2.dart';

class Consignee extends StatefulWidget {
  const Consignee({
    super.key,
    required this.openDrawer,
  });

  final VoidCallback openDrawer;

  @override
  State<Consignee> createState() => _ConsigneeState();
}

class _ConsigneeState extends State<Consignee> {
  final _formConsignee = GlobalKey<FormState>();
  final TextEditingController name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: DashboardAppBar(
        size: size,
        openDrawer: widget.openDrawer,
        title: 'Consignee',
      ),
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          WelcomeBackground(
              assetUrl: 'assets/images/backgrounds/consignee-master.png'),
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
                        child: streamConsigneeFirestoreDatatable(context)),
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
                          title: Text('New Consignee'),
                          content: Form(
                            key: _formConsignee,
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
                                    if (_formConsignee.currentState!
                                        .validate()) {
                                      SweetAlertV2.show(context,
                                          subtitle:
                                              "Do you want to save new Consignee ?",
                                          style: SweetAlertV2Style.confirm,
                                          showCancelButton: true,
                                          onPress: (bool isConfirm) {
                                        if (isConfirm) {
                                          new Future.delayed(
                                              new Duration(seconds: 0),
                                              () async {
                                            //async function
                                            final Consignee = ModelConsignee(
                                              name: name.text,
                                              id: 'auto',
                                            );

                                            bool result = await createConsignee(
                                                data: Consignee);

                                            name.clear();

                                            if (result) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                content: Text(
                                                    'Success! New Consignee has been saved.'),
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
