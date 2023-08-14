import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'package:feather_client/miscellaneous/validations.dart';
import 'package:feather_client/components/components.dart';
import 'package:feather_client/models/models.dart';
import 'package:feather_client/utils/utils.dart';

class ConnectView extends StatefulWidget {
  const ConnectView({super.key});

  @override
  State<ConnectView> createState() => _ConnectViewState();
}

class _ConnectViewState extends State<ConnectView> {
  final uri = TextEditingController(text: "netlog://localhost:10542/");
  final name = TextEditingController();

  final connection = ConfigModel();
  bool isNameFieldHoverred = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ContainerComponent(
          height: 400,
          width: MediaQuery.of(context).size.width,
          color: ThemeUtils.kPrimaryButton,
          borderRadius: BorderRadius.circular(15),
          padding: const EdgeInsets.fromLTRB(45, 30, 45, 30),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MouseRegion(
                        child: Row(
                          children: [
                            Text(
                              name.text.isNotEmpty
                                  ? name.text
                                  : "New Connection",
                              style: StyleUtils.highLightStyle,
                            ),
                            BoxComponent.smallWidth,
                            if (isNameFieldHoverred) ...[
                              IconButtonComponent(
                                widget: const Icon(
                                  FontAwesomeIcons.pen,
                                  color: ThemeUtils.kText,
                                  size: 20,
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (_) {
                                      return NameEditDialog(
                                        defaultValue: name.text,
                                        saveCbk: (value) {
                                          setState(() => name.value = value);
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ],
                        ),
                        onEnter: (event) {
                          setState(() => isNameFieldHoverred = true);
                        },
                        onExit: (event) {
                          setState(() => isNameFieldHoverred = false);
                        },
                      ),
                      BoxComponent.smallHeight,
                      const Text(
                        "Connect to a feather's logger deployment.",
                        style: StyleUtils.mediumLightStyle,
                      ),
                    ],
                  ),
                  const Spacer(),
                  ButtonComponent(
                    hover: ThemeUtils.kAccent,
                    content: Column(
                      children: [
                        Icon(
                          FontAwesomeIcons.solidStar,
                          color: connection.favorite
                              ? Colors.yellow.shade700
                              : ThemeUtils.kText,
                        ),
                        BoxComponent.customHeight(6),
                        const Text(
                          "FAVORITE",
                          style: StyleUtils.mediumLightStyle,
                        )
                      ],
                    ),
                    onPressed: () {
                      setState(
                        () => connection.setFavorite(!connection.favorite),
                      );
                    },
                  ),
                ],
              ),
              BoxComponent.mediumHeight,
              Row(
                children: [
                  Text(
                    "URI",
                    style: StyleUtils.mediumLightStyle.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  BoxComponent.smallWidth,
                  IconButtonComponent(
                    widget: const Icon(
                      FontAwesomeIcons.circleInfo,
                      color: ThemeUtils.kText,
                      size: 20,
                    ),
                    onPressed: () {
                      launchUrlString("${EnvUtils.kWebsite}/docs");
                    },
                  ),
                ],
              ),
              BoxComponent.smallHeight,
              FieldComponent(
                height: 150,
                width: MediaQuery.of(context).size.width,
                color: ThemeUtils.kBackground,
                hintText: "http://localhost:10542/",
                validation: ValidationType.all,
                controller: uri,
              ),
              BoxComponent.bigHeight,
              Row(
                children: [
                  ButtonComponent(
                    color: ThemeUtils.kSecondaryButton,
                    hover: ThemeUtils.kAccent,
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                    content: const Text(
                      "Save",
                      style: StyleUtils.mediumLightStyle,
                    ),
                    onPressed: () {
                      if (name.text.isEmpty) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return NameEditDialog(
                              defaultValue: name.text,
                              saveCbk: (value) {
                                setState(() => name.value = value);
                                _saveConnection();
                              },
                            );
                          },
                        );
                        return;
                      }

                      _saveConnection();
                    },
                  ),
                  const Spacer(),
                  ButtonComponent(
                    color: ThemeUtils.kSecondaryButton,
                    hover: ThemeUtils.kAccent,
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                    content: const Text(
                      "Save & Connect",
                      style: StyleUtils.mediumLightStyle,
                    ),
                    onPressed: () {},
                  ),
                  BoxComponent.smallWidth,
                  ButtonComponent(
                    color: ThemeUtils.kSecondaryButton,
                    hover: ThemeUtils.kAccent,
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                    content: const Text(
                      "Connect",
                      style: StyleUtils.mediumLightStyle,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
        BoxComponent.smallHeight,
        ContainerComponent(
          height: 250,
          width: MediaQuery.of(context).size.width,
          color: ThemeUtils.kPrimaryButton,
          borderRadius: BorderRadius.circular(15),
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          content: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Placeholder for information",
                style: StyleUtils.regularLightStyle,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _saveConnection() {
    connection.setName(name.text);
    connection.setUri(uri.text);
    connection.save();
  }
}

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
        "Choose a name for the connection",
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
            "Save",
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
