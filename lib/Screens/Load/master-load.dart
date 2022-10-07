import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ltl_bulk/Models/load.dart';
import 'package:ltl_bulk/Models/warehouse.dart';
import 'package:ltl_bulk/Screens/Auth/widgets/welcome-background.dart';
import 'package:ltl_bulk/Screens/Global/widgets/widgets.dart';
import 'package:ltl_bulk/Shared/colors.dart';
import 'package:ltl_bulk/Shared/fonts.dart';
import 'package:ltl_bulk/Models/truck.dart';
import 'package:sweetalertv2/sweetalertv2.dart';

class MasterLoad extends StatefulWidget {
  const MasterLoad({
    super.key,
    required this.openDrawer,
  });

  final VoidCallback openDrawer;

  @override
  State<MasterLoad> createState() => _MasterLoadState();
}

class _MasterLoadState extends State<MasterLoad> {
  bool firstLoad = true;
  int? sortColumnIndex;
  bool isAscending = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: DashboardAppBar(
        size: size,
        openDrawer: widget.openDrawer,
        title: 'Loads',
      ),
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          WelcomeBackground(
              assetUrl: 'assets/images/backgrounds/load-master.png'),
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                color: kLightColor,
                height: size.height * 0.7,
                width: size.width * 0.8,
                padding: EdgeInsets.all(25.0),
                child: LoadDatatable(size: size),
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
                  Navigator.pushNamed(context, 'load/create');
                },
                child: Icon(FontAwesomeIcons.plus),
              ),
            ),
          )
        ],
      ),
    );
  }
}
