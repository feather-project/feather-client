import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:feather_client/utils/utils.dart';

import 'button.dart';

class FormComponent extends StatefulWidget {
  final List<Widget> components;
  final Widget child;
  final EdgeInsets padding;
  final Color? color;
  final BorderRadius? borderRadius;
  final void Function() onValidate;
  final void Function()? onPress;
  final bool canInteract;

  const FormComponent({
    super.key,
    required this.components,
    this.child = const Icon(FontAwesomeIcons.paperPlane),
    this.padding = const EdgeInsets.all(16.0),
    this.color = ThemeUtils.kAccent,
    required this.onValidate,
    this.onPress,
    this.canInteract = true,
    this.borderRadius,
  });

  @override
  State<FormComponent> createState() => _FormComponentState();
}

class _FormComponentState extends State<FormComponent> {
  final key = GlobalKey<FormState>();
  late bool interactable = widget.canInteract;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: key,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ...widget.components,
          ButtonComponent(
            color: widget.color,
            hover: ThemeUtils.kFadeAccent,
            clickable: interactable,
            padding: widget.padding,
            content: widget.child,
            borderRadius: widget.borderRadius,
            onPressed: () {
              widget.onPress?.call();
              setState(() => interactable = false);
              if (key.currentState!.validate()) {
                widget.onValidate();
              }
              Future.delayed(const Duration(seconds: 2), () {
                if (!mounted) return;
                setState(() => interactable = true);
              });
            },
          ),
        ],
      ),
    );
  }
}
