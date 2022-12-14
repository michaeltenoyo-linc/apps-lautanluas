import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:ltl_bulk/Screens/Consignee/consignee.dart';
import 'package:ltl_bulk/Screens/Global/widgets/widgets.dart';
import 'package:ltl_bulk/Screens/Group/group.dart';
import 'package:ltl_bulk/Screens/Homepage/homepage-screens.dart';
import 'package:ltl_bulk/Screens/Load/load-screens.dart';
import 'package:ltl_bulk/Screens/Truck/truck-screens.dart';
import 'package:ltl_bulk/Screens/Warehouse/warehouse-screens.dart';
import 'package:ltl_bulk/Services/firebase-auth.dart';
import 'package:ltl_bulk/Shared/colors.dart';
import 'package:sweetalertv2/sweetalertv2.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  //Offset between drawer and main screens
  late double xOffset;
  late double yOffset;
  late double scaleFactor;
  late bool isDrawerOpen;
  late bool isHomepage;
  DrawerItem item = DrawerItems.home;

  @override
  void initState() {
    super.initState();
    closeDrawer();
  }

  //Open Drawer Function to minimize main screen
  void openDrawer() => setState(() {
        xOffset = 300;
        yOffset = 100;
        scaleFactor = 0.7;
        isDrawerOpen = true;
      });

  //Open Drawer Function to minimize main screen
  void closeDrawer() => setState(() {
        xOffset = 0;
        yOffset = 0;
        scaleFactor = 1;
        isDrawerOpen = false;
      });

  void navigation(path) => setState(() {
        isHomepage = false;
        switch (path) {
          case 'truck':
            this.item = DrawerItems.truck;
            break;
          case 'warehouse':
            this.item = DrawerItems.warehouse;
            break;
          case 'consignee':
            this.item = DrawerItems.consignee;
            break;
          case 'report':
            this.item = DrawerItems.report;
            break;
          case 'load':
            this.item = DrawerItems.load;
            break;
          case 'group':
            this.item = DrawerItems.group;
            break;
          default:
            isHomepage = true;
            this.item = DrawerItems.home;
        }
      });

  @override
  Widget build(BuildContext context) {
    final _auth = AuthService();
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              width: xOffset,
              child: DrawerSidebar(
                onSelectedItem: (item) async {
                  switch (item) {
                    case DrawerItems.logout:
                      SweetAlertV2.show(context,
                          subtitle: "Do you want to logout ?",
                          style: SweetAlertV2Style.confirm,
                          showCancelButton: true, onPress: (bool isConfirm) {
                        if (isConfirm) {
                          new Future.delayed(new Duration(seconds: 0),
                              () async {
                            await _auth.signOut();
                          });
                        }

                        return true;
                      });

                      break;
                    default:
                      isHomepage = item == DrawerItems.home ? true : false;
                      setState(() => this.item = item);
                      closeDrawer();
                  }
                },
              ),
            ),
            buildPage(),
          ],
        ),
      ),
    );
  }

  Widget buildPage() {
    return WillPopScope(
      onWillPop: () async {
        if (isDrawerOpen) {
          closeDrawer();
          return false;
        } else if (!isHomepage) {
          navigation('home');
          return false;
        } else {
          return true;
        }
      },
      child: GestureDetector(
        onTap: closeDrawer,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 250),
          transform: Matrix4.translationValues(xOffset, yOffset, 0)
            ..scale(scaleFactor),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(isDrawerOpen ? 20 : 0),
            child: Container(
              child: getDrawerPage(),
              color: isDrawerOpen ? Colors.white12 : kPrimaryColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget getDrawerPage() {
    switch (item) {
      case DrawerItems.truck:
        return Truck(openDrawer: openDrawer);
        break;
      case DrawerItems.warehouse:
        return Warehouse(openDrawer: openDrawer);
        break;
      case DrawerItems.consignee:
        return Consignee(openDrawer: openDrawer);
        break;
      case DrawerItems.load:
        return MasterLoad(openDrawer: openDrawer);
        break;
      case DrawerItems.group:
        return Group(openDrawer: openDrawer);
      case DrawerItems.home:
      default:
        return Homepage(
          openDrawer: openDrawer,
          dashboardNavigation: navigation,
        );
    }
  }
}
