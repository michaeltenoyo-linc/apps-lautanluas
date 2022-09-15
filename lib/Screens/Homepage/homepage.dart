import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ltl_bulk/Screens/Global/widgets/widgets.dart';
import 'package:ltl_bulk/Shared/colors.dart';
import 'package:ltl_bulk/Shared/fonts.dart';

class Homepage extends StatelessWidget {
  const Homepage({
    super.key,
    required this.openDrawer,
  });

  final VoidCallback openDrawer;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: DashboardAppBar(
        size: size,
        openDrawer: openDrawer,
        title: 'Home',
      ),
      backgroundColor: Colors.transparent,
    );
  }
}
