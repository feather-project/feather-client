import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'package:feather_client/utils/utils.dart';
import 'package:feather_client/pages/pages.dart';
import 'package:feather_client/components/components.dart';
import 'package:feather_client/miscellaneous/notifiers/connection.dart';

class BrowserSidebar extends StatefulWidget {
  final String name;
  final List<Widget> files;

  const BrowserSidebar({
    super.key,
    required this.name,
    required this.files,
  });

  @override
  State<BrowserSidebar> createState() => _BrowserSidebarState();
}

class _BrowserSidebarState extends State<BrowserSidebar> {
  @override
  Widget build(BuildContext context) {
    return DrawerComponent(
      header: _buildHeader(),
      [
        BoxComponent.smallHeight,
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.files.length,
                  separatorBuilder: (context, index) {
                    return BoxComponent.smallHeight;
                  },
                  itemBuilder: (context, index) {
                    return widget.files[index];
                  },
                ),
              ],
            ),
          ),
        ),
      ],
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
              Provider.of<ConnectionNotifier>(context, listen: false).close();

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
