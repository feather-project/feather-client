import 'package:flutter/material.dart';

import 'package:window_manager/window_manager.dart';

import 'package:feather_client/utils/utils.dart';

class CustomPage extends StatefulWidget {
  final String name;
  final Widget? sideBar;
  final Color? color;
  final List<Widget> content;
  final bool scrollabled;

  const CustomPage({
    super.key,
    this.color,
    required this.content,
    this.sideBar,
    this.scrollabled = true,
    required this.name,
  });

  @override
  State<CustomPage> createState() => _CustomPageState();
}

class _CustomPageState extends State<CustomPage> {
  @override
  void initState() {
    super.initState();

    WindowManager.instance.setTitle("${ConfigUtils.kProject} - ${widget.name}");
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
