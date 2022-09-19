import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ltl_bulk/Screens/Global/widgets/widgets.dart';
import 'package:ltl_bulk/Screens/Homepage/widgets/widgets.dart';
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
              child: Column(
                children: [
                  Flexible(
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
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: Container(
                width: size.width,
                height: size.height * 0.2,
                child: Stack(
                  children: [
                    CustomPaint(
                      size: Size(size.width, size.height * 0.2),
                      painter: HomepageFooterPainter(),
                    ),
                    Center(
                      heightFactor: 0.2,
                      child: Container(
                        width: size.width * 0.15,
                        height: size.width * 0.15,
                        child: RawMaterialButton(
                          fillColor: kColorsBlue700,
                          onPressed: () {},
                          shape: CircleBorder(),
                          elevation: 0.0,
                          child: Icon(
                            Icons.directions_boat_filled_rounded,
                            color: kLightColor,
                            size: size.width * 0.06,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: size.width,
                      height: size.height * 0.2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              FontAwesomeIcons.truck,
                              size: size.width * 0.035,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              FontAwesomeIcons.warehouse,
                              size: size.width * 0.035,
                            ),
                          ),
                          Container(
                            width: size.width * 0.2,
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              FontAwesomeIcons.userTie,
                              size: size.width * 0.035,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              FontAwesomeIcons.chartColumn,
                              size: size.width * 0.035,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ));
  }
}

class HomepageFooterPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    Path path = Path()..moveTo(0, 20);
    //Left Quadratic
    path.quadraticBezierTo(size.width * 0.2, 0, size.width * 0.35, 0);
    path.quadraticBezierTo(size.width * 0.43, 0, size.width * 0.43, 20);
    path.arcToPoint(
      Offset(size.width * 0.57, 20),
      radius: Radius.circular(10.0),
      clockwise: false,
    );
    //Right Quadratic
    path.quadraticBezierTo(size.width * 0.57, 0, size.width * 0.62, 0);
    path.quadraticBezierTo(size.width * 0.8, 0, size.width, 20);
    //Under Base
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    //Canvas Draw
    canvas.drawShadow(path, Colors.black, 5, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
