import 'package:flutter/material.dart';

import 'package:feather_client/components/components.dart';
import 'package:feather_client/utils/utils.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SidebarComponent extends StatefulWidget {
  final List<Widget> saved;
  final List<Widget> favorites;

  final void Function() exportCbk;
  final void Function() importCbk;
  final void Function() clearCbk;

  const SidebarComponent({
    super.key,
    this.saved = const [],
    this.favorites = const [],
    required this.exportCbk,
    required this.importCbk,
    required this.clearCbk,
  });

  @override
  State<SidebarComponent> createState() => _SidebarComponentState();
}

class _SidebarComponentState extends State<SidebarComponent> {
  bool isHoverRecent = false;
  bool isHoverSaved = false;

  bool isActionsClicked = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      child: Drawer(
        shadowColor: Colors.transparent,
        backgroundColor: ThemeUtils.kSecondaryButton,
        child: Column(
          children: [
            _buildHeader(),
            BoxComponent.smallHeight,
            Padding(
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
                onPressed: () {},
              ),
            ),
            BoxComponent.mediumHeight,
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    MouseRegion(
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
                            if (isHoverSaved) ...[
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
                        setState(() => isHoverSaved = true);
                      },
                      onExit: (event) {
                        setState(() => isHoverSaved = false);
                      },
                    ),
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
                    MouseRegion(
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
                            if (isHoverRecent) ...[
                              ButtonComponent(
                                height: 28,
                                padding:
                                    const EdgeInsets.only(left: 8, right: 8),
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
                        setState(() => isHoverRecent = true);
                      },
                      onExit: (event) {
                        setState(() => isHoverRecent = false);
                      },
                    ),
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
        ),
      ),
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
            onPressed: () {},
          ),
          BoxComponent.mediumWidth,
        ],
      ),
    );
  }
}

class SidebarItem extends StatelessWidget {
  final Text title;
  final Widget leading;
  final void Function()? onPress;
  final bool isSelected;

  const SidebarItem({
    super.key,
    required this.title,
    required this.leading,
    required this.onPress,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return ButtonComponent(
      height: 55,
      color: isSelected ? ThemeUtils.kAccent : ThemeUtils.kPrimaryButton,
      hover: ThemeUtils.kAccent,
      borderRadius: BorderRadius.zero,
      padding: const EdgeInsets.fromLTRB(15, 5, 5, 5),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [leading, BoxComponent.smallWidth, title],
      ),
      onPressed: () {
        onPress?.call();
      },
    );
  }
}
