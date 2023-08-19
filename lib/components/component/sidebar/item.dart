import 'package:flutter/material.dart';

import 'package:feather_client/utils/utils.dart';

class SidebarItem extends StatelessWidget {
  final Widget title;
  final Widget? leading;
  final Widget? trailing;

  final void Function()? onTap;
  final bool selected;

  const SidebarItem({
    super.key,
    required this.title,
    this.leading,
    this.trailing,
    required this.onTap,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(highlightColor: Colors.transparent),
      child: ListTile(
        title: title,
        leading: leading,
        trailing: trailing,
        onTap: onTap,
        selected: selected,
        selectedTileColor: ThemeUtils.kBackground,
        splashColor: Colors.transparent,
        minLeadingWidth: 10,
      ),
    );
  }
}
