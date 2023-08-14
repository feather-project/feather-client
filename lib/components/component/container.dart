import 'package:flutter/material.dart';

import 'package:feather_client/utils/utils.dart';

class ContainerComponent extends StatelessWidget {
  final double? width, height;
  final EdgeInsets padding;
  final BorderRadiusGeometry? borderRadius;
  final Border? border;
  final BoxShape shape;
  final Widget? content;
  final Color? color;

  const ContainerComponent({
    super.key,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(6.0),
    this.borderRadius,
    this.border,
    this.shape = BoxShape.rectangle,
    this.content,
    this.color = ThemeUtils.kBackground,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          shape: shape,
          borderRadius: borderRadius,
          border: border,
        ),
        child: Padding(padding: padding, child: content),
      ),
    );
  }
}
