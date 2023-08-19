import 'package:flutter/material.dart';

import 'package:feather_client/components/components.dart';
import 'package:feather_client/utils/utils.dart';

class DrawerComponent extends StatelessWidget {
  final double width;
  final List<Widget> items;
  final Widget? header;

  const DrawerComponent(
    this.items, {
    super.key,
    this.width = 260,
    this.header,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Drawer(
        shadowColor: Colors.transparent,
        backgroundColor: ThemeUtils.kSecondaryButton,
        child: Column(
          children: [
            if (header != null) ...[
              header!,
              BoxComponent.smallHeight,
            ],
            ...items,
          ],
        ),
      ),
    );
  }
}
