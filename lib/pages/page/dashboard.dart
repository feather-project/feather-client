import 'package:feather_client/miscellaneous/notifiers/view.dart';
import 'package:feather_client/views/views.dart';
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
  late final config = Provider.of<ConfigNotifier>(context);
  late final view = Provider.of<ViewNotifier>(context);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) => config.load(),
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
    return DashboardSidebar(
      saved: [
        for (final model in config.getConfigs()) ...[
          _buildSidebarItem(model),
        ],
      ],
      favorites: [
        for (final model in config.getFavorites()) ...[
          _buildSidebarItem(model),
        ],
      ],
      exportCbk: () => config.export(),
      importCbk: () => config.import(),
      clearCbk: () => config.clearFavorites(),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(280, 10, 20, 10),
      child: view.current,
    );
  }

  SidebarItem _buildSidebarItem(ConfigModel model) {
    final configName = model.name!;

    return SidebarItem(
      title: Text(
        configName,
        style: StyleUtils.regularLightStyle,
      ),
      leading: const Icon(
        FontAwesomeIcons.chartGantt,
        color: ThemeUtils.kText,
        size: 20,
      ),
      selected: view.isSame(Key(configName)),
      onTap: () => {
        config.setCurrent(model: model),
        view.setCurrent(view: ConfigView(key: Key(configName), model: model)),
      },
    );
  }
}
