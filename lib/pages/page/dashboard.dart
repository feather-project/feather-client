import 'package:feather_client/miscellaneous/notifiers/view.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:feather_client/miscellaneous/notifiers/config.dart';
import 'package:feather_client/components/components.dart';
import 'package:feather_client/models/models.dart';
import 'package:feather_client/utils/utils.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late final configNotify = Provider.of<ConfigNotifier>(context);
  late final viewNotify = Provider.of<ViewNotifier>(context);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) => configNotify.load(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageComponent(
      name: "Home",
      sideBar: _buildSidebar(),
      content: [
        _buildContent(),
      ],
    );
  }

  Widget _buildSidebar() {
    return SidebarComponent(
      saved: [
        for (final model in configNotify.getConfigs()) ...[
          _buildSidebarItem(model),
        ],
      ],
      favorites: [
        for (final model in configNotify.getFavorites()) ...[
          _buildSidebarItem(model),
        ],
      ],
      exportCbk: () => configNotify.export(),
      importCbk: () => configNotify.import(),
      clearCbk: () => configNotify.clearFavorites(),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(280, 10, 20, 10),
      child: viewNotify.widget,
    );
  }

  SidebarItem _buildSidebarItem(ConfigModel model) {
    return SidebarItem(
      title: Text(
        model.name!,
        style: StyleUtils.regularLightStyle,
      ),
      leading: const Icon(
        FontAwesomeIcons.chartGantt,
        color: ThemeUtils.kText,
        size: 20,
      ),
      onPress: () {},
    );
  }
}
