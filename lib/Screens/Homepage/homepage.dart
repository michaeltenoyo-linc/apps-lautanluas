import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
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
        body: Stack(
          children: [
            Container(
              height: size.height * 0.25,
              decoration: BoxDecoration(
                color: kColorsBlue200,
                image: DecorationImage(
                  scale: 5,
                  alignment: Alignment.centerLeft,
                  image:
                      AssetImage('assets/images/backgrounds/home_banner.png'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black38,
                    BlendMode.darken,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 60.0, 20.0, 0),
              child: GridView.count(
                crossAxisCount: 4,
                crossAxisSpacing: 20,
                childAspectRatio: .85,
                mainAxisSpacing: 20,
                children: [
                  HomepageMenuBox(
                    size: size,
                    iconPath: 'assets/icons/homepage/home_truck.svg',
                    text: 'Truck',
                    onTap: () {},
                  ),
                  HomepageMenuBox(
                    size: size,
                    iconPath: 'assets/icons/homepage/home_warehouse.svg',
                    text: 'Warehouse',
                    onTap: () {},
                  ),
                  HomepageMenuBox(
                    size: size,
                    iconPath: 'assets/icons/homepage/home_consignee.svg',
                    text: 'Consignee',
                    onTap: () {},
                  ),
                  HomepageMenuBox(
                    size: size,
                    iconPath: 'assets/icons/homepage/home_report.svg',
                    text: 'Report',
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}

class HomepageMenuBox extends StatelessWidget {
  const HomepageMenuBox({
    Key? key,
    required this.size,
    required this.text,
    required this.iconPath,
    required this.onTap,
  }) : super(key: key);

  final Size size;
  final String text;
  final String iconPath;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: kLightColor,
          borderRadius: BorderRadius.circular(
            20,
          ),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 20),
              blurRadius: 20,
              spreadRadius: -23,
              color: kDarkColor,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: this.onTap,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: size.height * 0.04,
                  ),
                  child: SvgPicture.asset(
                    this.iconPath,
                    height: size.height * 0.25,
                  ),
                ),
                Text(
                  this.text,
                  style: kTextDarkBold5Xl,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
