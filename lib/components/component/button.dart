import 'package:flutter/material.dart';

import 'package:feather_client/utils/utils.dart';

class ButtonComponent extends StatefulWidget {
  final double? width, height;
  final EdgeInsets padding;
  final Widget? content;
  final BorderRadius? borderRadius;
  final void Function() onPressed;
  final bool clickable;
  final Color? color;
  final Color? hover;

  const ButtonComponent({
    super.key,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(8.0),
    this.content,
    this.borderRadius,
    required this.onPressed,
    this.clickable = true,
    this.color = ThemeUtils.kAccent,
    this.hover,
  });

  @override
  State<ButtonComponent> createState() => _ButtonComponentState();
}

class _ButtonComponentState extends State<ButtonComponent> {
  bool isHovered = false;
  bool isPressed = false;
  bool isAnimating = false;

  @override
  Widget build(BuildContext context) {
    final isHightened = !isHovered && !(isPressed || isAnimating);

    Decoration boxDecoration = BoxDecoration(
      color: isHightened ? widget.color : widget.hover,
      shape: BoxShape.rectangle,
      borderRadius: widget.borderRadius ?? BorderRadius.circular(5),
    );

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: MouseRegion(
        cursor: widget.clickable
            ? SystemMouseCursors.click
            : SystemMouseCursors.forbidden,
        onEnter: (e) => setState(() => isHovered = true),
        onExit: (e) => setState(() => isHovered = false),
        child: GestureDetector(
          onTap: widget.clickable ? widget.onPressed : null,
          child: Container(
            decoration: boxDecoration,
            child: Padding(
              padding: widget.padding,
              child: widget.content,
            ),
          ),
        ),
      ),
    );
  }
}

class IconButtonComponent extends StatefulWidget {
  final bool clickable;
  final String? tip;
  final Widget widget;
  final Widget? hoverWidget;
  final void Function() onPressed;

  const IconButtonComponent({
    super.key,
    this.clickable = true,
    this.tip,
    required this.widget,
    this.hoverWidget,
    required this.onPressed,
  });

  @override
  State<IconButtonComponent> createState() => _IconButtonComponentState();
}

class _IconButtonComponentState extends State<IconButtonComponent> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      waitDuration: const Duration(milliseconds: 600),
      message: widget.tip ?? '',
      child: GestureDetector(
        onTap: widget.clickable ? widget.onPressed : () {},
        child: MouseRegion(
          cursor: widget.clickable
              ? SystemMouseCursors.click
              : SystemMouseCursors.forbidden,
          onEnter: (e) => setState(() => isHovered = true),
          onExit: (e) => setState(() => isHovered = false),
          child: isHovered && widget.hoverWidget != null
              ? widget.hoverWidget
              : widget.widget,
        ),
      ),
    );
  }
}

class TextButtonComponent extends StatefulWidget {
  final Text text;
  final void Function() onPressed;
  final bool clickable;
  final Text hoverText;

  const TextButtonComponent({
    super.key,
    required this.text,
    required this.onPressed,
    this.clickable = true,
    required this.hoverText,
  });

  @override
  State<TextButtonComponent> createState() => _TextButtonComponentState();
}

class _TextButtonComponentState extends State<TextButtonComponent> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.clickable ? widget.onPressed : null,
      child: MouseRegion(
        cursor: widget.clickable
            ? SystemMouseCursors.click
            : SystemMouseCursors.forbidden,
        onEnter: (e) => setState(() => isHovered = true),
        onExit: (e) => setState(() => isHovered = false),
        child: isHovered ? widget.hoverText : widget.text,
      ),
    );
  }
}
