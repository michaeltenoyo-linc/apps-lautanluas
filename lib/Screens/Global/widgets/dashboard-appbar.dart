import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ltl_bulk/Screens/Global/widgets/widgets.dart';
import 'package:ltl_bulk/Shared/colors.dart';
import 'package:ltl_bulk/Shared/fonts.dart';

class DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DashboardAppBar({
    Key? key,
    required this.size,
    required this.openDrawer,
    required this.title,
  }) : super(key: key);

  final Size size;
  final VoidCallback openDrawer;
  final String title;

  @override
  Size get preferredSize => Size.fromHeight(size.height * 0.1);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      toolbarHeight: size.height * 0.1,
      backgroundColor: Colors.transparent,
      leading: DrawerSidebarButton(
        onClick: openDrawer,
        color: kLightColor,
      ),
      title: Text(
        this.title,
        style: kTextLight2Xl,
      ),
      centerTitle: true,
      actions: [
        SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 15.0, 10.0, 0),
            child: Container(
              width: size.width * 0.3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Hi, Account',
                    style: kTextLightBoldXl,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'test.account@gmail.com',
                    style: kTextLightBase,
                  ),
                ],
              ),
            ),
          ),
        ),
        Hero(
          tag: 'account',
          child: IconButton(
            icon: Icon(
              FontAwesomeIcons.user,
            ),
            onPressed: () {},
          ),
        )
      ],
    );
  }
}
