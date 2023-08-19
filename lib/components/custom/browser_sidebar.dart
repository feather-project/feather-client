import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:feather_client/utils/utils.dart';
import 'package:feather_client/components/components.dart';

class BrowserSidebar extends StatefulWidget {
  final String name;

  const BrowserSidebar({super.key, required this.name});

  @override
  State<BrowserSidebar> createState() => _BrowserSidebarState();
}

class _BrowserSidebarState extends State<BrowserSidebar> {
  @override
  Widget build(BuildContext context) {
    return DrawerComponent(
      header: _buildHeader(),
      [],
    );
  }

  Widget _buildHeader() {
    return ContainerComponent(
      height: 60,
      color: ThemeUtils.kAccent,
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/app_icon.png',
            scale: 5,
          ),
          BoxComponent.smallWidth,
          Expanded(
            child: Text(
              widget.name,
              style: StyleUtils.regularLightStyle,
            ),
          ),
          IconButtonComponent(
            widget: const Icon(
              FontAwesomeIcons.gear,
              color: ThemeUtils.kText,
              size: 20,
            ),
            onPressed: () {},
          ),
          BoxComponent.mediumWidth,
        ],
      ),
    );
  }
}
