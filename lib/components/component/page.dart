import 'package:flutter/material.dart';

import 'package:window_manager/window_manager.dart';

import 'package:feather_client/utils/utils.dart';

class PageComponent extends StatefulWidget {
  final String name;
  final Widget? sideBar;
  final Color? color;
  final List<Widget> content;
  final bool scrollabled;

  const PageComponent({
    super.key,
    required this.name,
    required this.content,
    this.color,
    this.sideBar,
    this.scrollabled = true,
  });

  @override
  State<PageComponent> createState() => _PageComponentState();
}

class _PageComponentState extends State<PageComponent> {
  @override
  void initState() {
    super.initState();
    WindowManager.instance.setTitle("${EnvUtils.kProject} - ${widget.name}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.color,
      body: widget.sideBar == null
          ? Center(
              child: _buildLayout(),
            )
          : Stack(
              children: [
                _buildLayout(),
                widget.sideBar!,
              ],
            ),
    );
  }

  Widget _buildLayout() {
    if (widget.scrollabled) {
      return SingleChildScrollView(
        child: Column(children: widget.content),
      );
    } else {
      return Column(children: widget.content);
    }
  }
}
