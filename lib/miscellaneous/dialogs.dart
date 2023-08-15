import 'package:flutter/material.dart';

import 'package:feather_client/miscellaneous/validations.dart';
import 'package:feather_client/components/components.dart';
import 'package:feather_client/utils/utils.dart';

class NameEditDialog extends StatefulWidget {
  final String? defaultValue;
  final void Function(TextEditingValue value) saveCbk;

  const NameEditDialog({
    super.key,
    required this.saveCbk,
    this.defaultValue,
  });

  @override
  State<NameEditDialog> createState() => _NameEditDialogState();
}

class _NameEditDialogState extends State<NameEditDialog> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.defaultValue);
    controller.addListener(() {
      setState(() => controller.value = controller.value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: ThemeUtils.kBackground,
      actionsPadding: const EdgeInsets.fromLTRB(0, 0, 25, 25),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      title: const Text(
        "Choose a name for the config",
        style: StyleUtils.highLightStyle,
      ),
      content: StatefulBuilder(
        builder: (context, setState) {
          return SizedBox(
            height: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Name", style: StyleUtils.mediumLightStyle),
                BoxComponent.smallHeight,
                FieldComponent(
                  validation: ValidationType.all,
                  controller: controller,
                ),
              ],
            ),
          );
        },
      ),
      actions: [
        ButtonComponent(
          hover: ThemeUtils.kAccent,
          padding: const EdgeInsets.fromLTRB(10, 6, 10, 6),
          content: const Text(
            "Cancel",
            style: StyleUtils.regularLightStyle,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ButtonComponent(
          hover: ThemeUtils.kAccent,
          padding: const EdgeInsets.fromLTRB(10, 6, 10, 6),
          clickable: controller.text.isNotEmpty,
          content: const Text(
            "Confirm",
            style: StyleUtils.regularLightStyle,
          ),
          onPressed: () {
            Navigator.of(context).pop();
            widget.saveCbk(controller.value);
          },
        ),
      ],
    );
  }
}
