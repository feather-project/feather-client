import 'dart:async';

import 'package:flutter/material.dart';

import 'package:feather_client/components/components.dart';
import 'package:feather_client/utils/utils.dart';

class SidebarComponent extends StatefulWidget {
  final List<Widget> items;
  final List<Widget> labels;

  const SidebarComponent({
    super.key,
    required this.items,
    required this.labels,
  });

  @override
  State<SidebarComponent> createState() => _SidebarComponentState();
}

class _SidebarComponentState extends State<SidebarComponent> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [],
      ),
    );
  }
}

class SidebarItem extends StatelessWidget {
  final Text title;
  final Widget leading;
  final Icon? trailing;
  final void Function()? onPress;
  final bool isCollapsed;
  final bool isSelected;
  final Color? color;

  const SidebarItem({
    super.key,
    required this.title,
    required this.leading,
    this.trailing,
    required this.onPress,
    this.isCollapsed = true,
    this.isSelected = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Placeholder();
  }
}

class NestedSidebarItem extends StatefulWidget {
  final SidebarItem untoggle;
  final SidebarItem toggle;
  final List<Widget> items;

  const NestedSidebarItem({
    super.key,
    required this.untoggle,
    required this.toggle,
    required this.items,
  });

  @override
  State<NestedSidebarItem> createState() => _NestedSidebarItemState();
}

class _NestedSidebarItemState extends State<NestedSidebarItem> {
  bool _isToggled = false;

  @override
  Widget build(BuildContext context) {
    final current = _isToggled ? widget.toggle : widget.untoggle;
    final isSelected = current.isSelected;

    return Column(
      children: [],
    );
  }
}
