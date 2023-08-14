import 'package:flutter/material.dart';

class TipComponent extends StatelessWidget {
  final String tip;
  final Duration waitDuration;
  final Widget child;

  const TipComponent({
    super.key,
    required this.tip,
    required this.child,
    this.waitDuration = const Duration(seconds: 1),
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tip,
      waitDuration: waitDuration,
      child: child,
    );
  }
}
