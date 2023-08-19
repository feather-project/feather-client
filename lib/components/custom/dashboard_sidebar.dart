import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:feather_client/components/components.dart';
import 'package:feather_client/utils/utils.dart';
import 'package:feather_client/views/views.dart';

import 'package:feather_client/miscellaneous/notifiers/config.dart';
import 'package:feather_client/miscellaneous/notifiers/view.dart';

class DashboardSidebar extends StatefulWidget {
  final List<Widget> saved;
  final List<Widget> favorites;

  final void Function() exportCbk;
  final void Function() importCbk;
  final void Function() clearCbk;

  const DashboardSidebar({
    super.key,
    this.saved = const [],
    this.favorites = const [],
    required this.exportCbk,
    required this.importCbk,
    required this.clearCbk,
  });

  @override
  State<DashboardSidebar> createState() => _DashboardSidebarState();
}

class _DashboardSidebarState extends State<DashboardSidebar> {
  late final view = Provider.of<ViewNotifier>(context, listen: false);
  late final config = Provider.of<ConfigNotifier>(context, listen: false);

  bool showClearAction = false;
  bool showActions = false;

  @override
  Widget build(BuildContext context) {
    return DrawerComponent(
      header: _buildHeader(),
      [
        _buildNewButton(),
        BoxComponent.smallHeight,
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildSavedCategory(),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.saved.length,
                  separatorBuilder: (context, index) {
                    return BoxComponent.smallHeight;
                  },
                  itemBuilder: (context, index) {
                    return widget.saved[index];
                  },
                ),
                BoxComponent.mediumHeight,
                _buildFavoritesCategory(),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.favorites.length,
                  separatorBuilder: (context, index) {
                    return BoxComponent.smallHeight;
                  },
                  itemBuilder: (context, index) {
                    return widget.favorites[index];
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNewButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: ButtonComponent(
        hover: ThemeUtils.kAccent,
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "New connection",
              style: StyleUtils.mediumLightStyle,
            ),
            BoxComponent.smallWidth,
            const Icon(
              FontAwesomeIcons.plus,
              color: ThemeUtils.kText,
              size: 15,
            )
          ],
        ),
        onPressed: () => view.set(const CreateView()),
      ),
    );
  }

  Widget _buildSavedCategory() {
    return MouseRegion(
      child: ContainerComponent(
        height: 50,
        color: ThemeUtils.kSecondaryButton,
        padding: const EdgeInsets.fromLTRB(20, 6, 6, 6),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Icon(
              FontAwesomeIcons.solidBookmark,
              color: ThemeUtils.kText,
              size: 20,
            ),
            BoxComponent.smallWidth,
            const Expanded(
              child: Text(
                "Saved connections",
                style: StyleUtils.mediumLightStyle,
              ),
            ),
            BoxComponent.smallWidth,
            if (showActions) ...[
              PopupMenuButton(
                tooltip: "Show actions",
                splashRadius: null,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                constraints: BoxConstraints.tight(
                  const Size(200, 112.5),
                ),
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                icon: const Icon(
                  FontAwesomeIcons.ellipsis,
                  color: ThemeUtils.kText,
                  size: 15,
                ),
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem(
                      child: Row(
                        children: [
                          const Icon(
                            FontAwesomeIcons.fileImport,
                            color: ThemeUtils.kText,
                            size: 20,
                          ),
                          BoxComponent.mediumWidth,
                          const Flexible(
                            child: Text(
                              "Import saved connections",
                              style: StyleUtils.smallLightStyle,
                            ),
                          ),
                        ],
                      ),
                      onTap: () => widget.importCbk(),
                    ),
                    PopupMenuItem(
                      child: Row(
                        children: [
                          const Icon(
                            FontAwesomeIcons.fileExport,
                            color: ThemeUtils.kText,
                            size: 20,
                          ),
                          BoxComponent.mediumWidth,
                          const Flexible(
                            child: Text(
                              "Export saved connections",
                              style: StyleUtils.smallLightStyle,
                            ),
                          ),
                        ],
                      ),
                      onTap: () => widget.exportCbk(),
                    ),
                  ];
                },
              ),
              BoxComponent.smallWidth,
            ],
          ],
        ),
      ),
      onEnter: (event) {
        setState(() => showActions = true);
      },
      onExit: (event) {
        setState(() => showActions = false);
      },
    );
  }

  Widget _buildFavoritesCategory() {
    return MouseRegion(
      child: ContainerComponent(
        height: 50,
        color: ThemeUtils.kSecondaryButton,
        padding: const EdgeInsets.fromLTRB(20, 6, 6, 6),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Icon(
              FontAwesomeIcons.solidStar,
              color: ThemeUtils.kText,
              size: 20,
            ),
            BoxComponent.smallWidth,
            const Expanded(
              child: Text(
                "Favorites",
                style: StyleUtils.mediumLightStyle,
              ),
            ),
            BoxComponent.smallWidth,
            if (showClearAction) ...[
              ButtonComponent(
                height: 28,
                padding: const EdgeInsets.only(left: 8, right: 8),
                hover: ThemeUtils.kAccent,
                content: const Center(
                  child: Text(
                    'Clear All',
                    style: StyleUtils.mediumLightStyle,
                  ),
                ),
                onPressed: () => widget.clearCbk(),
              ),
              BoxComponent.smallWidth,
            ],
          ],
        ),
      ),
      onEnter: (event) {
        setState(() => showClearAction = true);
      },
      onExit: (event) {
        setState(() => showClearAction = false);
      },
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
          const Expanded(
            child: Text(
              "Viewer",
              style: StyleUtils.regularLightStyle,
            ),
          ),
          IconButtonComponent(
            widget: const Icon(
              FontAwesomeIcons.gear,
              color: ThemeUtils.kText,
              size: 20,
            ),
            onPressed: () {
              config.setCurrent();
              view.set(const SettingsView());
            },
          ),
          BoxComponent.mediumWidth,
        ],
      ),
    );
  }
}
