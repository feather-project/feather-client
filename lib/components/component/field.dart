import 'package:flutter/material.dart';

import 'package:feather_client/miscellaneous/validations.dart';
import 'package:feather_client/utils/utils.dart';

class FieldComponent extends StatefulWidget {
  final double width, height;
  final bool isRequired, isSecure;
  final String? hintText;
  final String errorText;
  final Widget? leading;
  final ValidationType validation;
  final Color color;
  final TextEditingController controller;

  const FieldComponent({
    super.key,
    this.width = 430,
    this.height = 60,
    this.isRequired = true,
    this.isSecure = false,
    this.hintText,
    this.errorText = "Ce champ ne peut être vide!",
    required this.validation,
    this.leading,
    this.color = ThemeUtils.kSecondaryButton,
    required this.controller,
  });

  @override
  State<FieldComponent> createState() => FieldComponentState();
}

class FieldComponentState extends State<FieldComponent> {
  bool isHovered = false;

  String? errorText;
  late bool obscureText = widget.isSecure;
  late bool isEnlarged = widget.height > 60;

  @override
  Widget build(BuildContext context) {
    final boxDecoration = BoxDecoration(
      color: widget.color,
      shape: BoxShape.rectangle,
      borderRadius: const BorderRadius.all(Radius.circular(5)),
    );

    final Widget content = Stack(
      alignment: Alignment.topLeft,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
            18,
            isEnlarged ? 5 : widget.height / 12,
            18,
            0,
          ),
          child: TextFormField(
            controller: widget.controller,
            obscureText: obscureText,
            validator: (value) {
              String? error;
              try {
                if (widget.isRequired) {
                  error = validateField();
                } else {
                  error = value != null && value.isNotEmpty
                      ? validateField()
                      : null;
                }
                return error;
              } finally {
                setState(() => errorText = error);
              }
            },
            maxLines: isEnlarged ? widget.height ~/ 25 : 1,
            style: StyleUtils.regularDarkStyle,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding:
                  isEnlarged ? const EdgeInsets.only(top: 6) : EdgeInsets.zero,
              hintText: widget.hintText,
              hintStyle: StyleUtils.regularFadeDarkStyle,
              labelStyle: StyleUtils.regularDarkStyle,
              errorStyle: const TextStyle(color: Colors.transparent),
              alignLabelWithHint: true,
            ),
          ),
        ),
        if (widget.isSecure) ...[
          Positioned(
            top: 10,
            right: 10,
            child: IconButton(
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              focusColor: Colors.transparent,
              splashColor: Colors.transparent,
              icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
              onPressed: () {
                setState(() => obscureText = !obscureText);
              },
            ),
          ),
        ],
        if (errorText != null) ...[
          Positioned(
            left: 10,
            top: widget.height - 20,
            child: Text(
              errorText!,
              style: StyleUtils.errorStyle,
            ),
          ),
        ],
      ],
    );

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: MouseRegion(
        onEnter: (e) => setState(() => isHovered = true),
        onExit: (e) => setState(() => isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: boxDecoration,
          child: content,
        ),
      ),
    );
  }

  String? validateField() {
    return widget.validation.matchesPattern(widget.controller.text);
  }
}
