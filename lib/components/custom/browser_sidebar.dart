import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'package:feather_client/utils/utils.dart';
import 'package:feather_client/pages/pages.dart';
import 'package:feather_client/components/components.dart';
import 'package:feather_client/miscellaneous/notifiers/config.dart';
import 'package:feather_client/miscellaneous/notifiers/connection.dart';

class BrowserSidebar extends StatefulWidget {
  final String name;

  const BrowserSidebar({super.key, required this.name});

  @override
  State<BrowserSidebar> createState() => _BrowserSidebarState();
}

class _BrowserSidebarState extends State<BrowserSidebar> {
  late final notify = Provider.of<ConnectionNotifier>(context, listen: false);
  late final config = Provider.of<ConfigNotifier>(context, listen: false);

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
              FontAwesomeIcons.arrowRightFromBracket,
              color: ThemeUtils.kText,
              size: 20,
            ),
            onPressed: () {
              notify.connection?.close();
              config.setCurrent();
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const DashboardPage(),
              ));
            },
          ),
          BoxComponent.mediumWidth,
        ],
      ),
    );
  }
}
