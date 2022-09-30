import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ltl_bulk/Screens/Global/widgets/widgets.dart';
import 'package:ltl_bulk/Services/firebase-auth.dart';
import 'package:ltl_bulk/Shared/colors.dart';
import 'package:ltl_bulk/Shared/fonts.dart';
import 'package:sweetalertv2/sweetalertv2.dart';

class DashboardAppBar extends StatefulWidget implements PreferredSizeWidget {
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
  State<DashboardAppBar> createState() => _DashboardAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(size.height * 0.1);
}

class _DashboardAppBarState extends State<DashboardAppBar> {
  final _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      toolbarHeight: widget.size.height * 0.1,
      backgroundColor: Colors.transparent,
      leading: DrawerSidebarButton(
        onClick: widget.openDrawer,
        color: kLightColor,
      ),
      title: Text(
        this.widget.title,
        style: kTextLight2Xl,
      ),
      centerTitle: true,
      actions: [
        SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 15.0, 10.0, 0),
            child: Container(
              width: widget.size.width * 0.3,
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
            onPressed: () {
              openDialog();
            },
          ),
        )
      ],
    );
  }

  //Popup Button
  Future openDialog() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'Account!',
            style: kTextDarkBold4Xl,
          ),
          content: Text(
            'testing.account@gmail.com',
          ),
          actions: [
            TextButton(
              onPressed: () async {
                SweetAlertV2.show(context,
                    subtitle: "Do you want to logout ?",
                    style: SweetAlertV2Style.confirm,
                    showCancelButton: true, onPress: (bool isConfirm) {
                  if (isConfirm) {
                    new Future.delayed(new Duration(seconds: 0), () async {
                      Navigator.of(context).pop();
                      await _auth.signOut();
                    });
                  }

                  return true;
                });
              },
              child: Text(
                'LOG OUT',
              ),
            )
          ],
        ),
      );
}
