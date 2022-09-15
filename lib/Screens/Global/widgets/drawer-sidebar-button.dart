import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../Shared/colors.dart';

class DrawerSidebarButton extends StatelessWidget {
  const DrawerSidebarButton({
    super.key,
    required this.onClick,
    this.color = kLightColor,
  });

  final VoidCallback onClick;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onClick,
      icon: FaIcon(FontAwesomeIcons.alignLeft),
      color: color,
    );
  }
}
