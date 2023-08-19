import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:provider/provider.dart';

import 'package:feather_client/miscellaneous/dialogs.dart';
import 'package:feather_client/miscellaneous/notifiers/config.dart';
import 'package:feather_client/miscellaneous/validations.dart';
import 'package:feather_client/components/components.dart';
import 'package:feather_client/models/models.dart';
import 'package:feather_client/utils/utils.dart';

class CreateView extends StatefulWidget {
  const CreateView({super.key});

  @override
  State<CreateView> createState() => _CreateViewState();
}

class _CreateViewState extends State<CreateView> {
  late final configNotify = Provider.of<ConfigNotifier>(context, listen: false);
  ConfigModel config = ConfigModel();

  final uri = TextEditingController(text: "http://localhost:10542/");
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
            children: [
              _buildHeader(),
              BoxComponent.mediumHeight,
              ..._buildContent(),
              BoxComponent.bigHeight,
              _buildFooter(),
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

  Widget _buildHeader() {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MouseRegion(
              child: Row(
                children: [
                  Text(
                    config.name ?? "New config",
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
                              defaultValue: config.name,
                              saveCbk: (value) {
                                setState(
                                  () => config.setName(value.text),
                                );
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
        _buildFavoriteButton(config.favorite),
      ],
    );
  }

  List<Widget> _buildContent() {
    return [
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
    ];
  }

  Widget _buildFooter() {
    return Row(
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
            if (config.name != null) {
              return _saveConfig();
            }

            showDialog(
              context: context,
              builder: (context) {
                return NameEditDialog(
                  saveCbk: (value) {
                    setState(() => config.setName(value.text));
                    _saveConfig();
                  },
                );
              },
            );
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
    );
  }

  Widget _buildFavoriteButton(bool isFavorite) {
    return ButtonComponent(
      hover: ThemeUtils.kAccent,
      content: Column(
        children: [
          Icon(
            FontAwesomeIcons.solidStar,
            color: isFavorite ? Colors.yellow.shade700 : ThemeUtils.kText,
          ),
          BoxComponent.customHeight(6),
          const Text(
            "FAVORITE",
            style: StyleUtils.mediumLightStyle,
          )
        ],
      ),
      onPressed: () {
        setState(() {
          config.setFavorite(!isFavorite);
        });
      },
    );
  }

  void _saveConfig() {
    config.setUri(uri.text);
    config.save();

    configNotify.add(config);

    setState(
      () => {
        config = ConfigModel(),
        uri.text = "http://localhost:10542/",
      },
    );
  }
}
