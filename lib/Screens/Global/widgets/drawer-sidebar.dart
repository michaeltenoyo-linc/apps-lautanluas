import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ltl_bulk/Shared/colors.dart';
import 'package:ltl_bulk/Shared/fonts.dart';

class DrawerSidebar extends StatelessWidget {
  const DrawerSidebar({
    super.key,
    required this.onSelectedItem,
  });

  final ValueChanged<DrawerItem> onSelectedItem;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 32, 16, 32),
      child: SingleChildScrollView(
        child: Column(
          children: [
            buildDrawerItems(context),
          ],
        ),
      ),
    );
  }

  Widget buildDrawerItems(BuildContext context) => Column(
        children: DrawerItems.menus
            .map(
              (item) => ListTile(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                leading: Icon(
                  item.icon,
                  color: kLightColor,
                ),
                title: Text(
                  item.title,
                  style: kTextLightXl,
                ),
                onTap: () => onSelectedItem(item),
              ),
            )
            .toList(),
      );
}

//Object Classes
class DrawerItem {
  final String title;
  final IconData icon;

  const DrawerItem({
    required this.title,
    required this.icon,
  });
}

class DrawerItems {
  static const home = DrawerItem(title: 'Home', icon: FontAwesomeIcons.house);
  static const truck = DrawerItem(title: 'Truck', icon: FontAwesomeIcons.truck);
  static const warehouse =
      DrawerItem(title: 'Warehouse', icon: FontAwesomeIcons.warehouse);
  static const consignee =
      DrawerItem(title: 'Consignee', icon: FontAwesomeIcons.userTie);
  static const report =
      DrawerItem(title: 'Report', icon: FontAwesomeIcons.chartPie);
  static const load = DrawerItem(title: 'Load', icon: FontAwesomeIcons.ship);
  static const logout =
      DrawerItem(title: 'Logout', icon: FontAwesomeIcons.rightFromBracket);

  static final List<DrawerItem> menus = [
    home,
    truck,
    warehouse,
    load,
    consignee,
    report,
    logout
  ];
}
