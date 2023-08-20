import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'package:feather_client/pages/pages.dart';
import 'package:feather_client/components/components.dart';
import 'package:feather_client/models/models.dart';
import 'package:feather_client/utils/utils.dart';

import 'package:feather_client/miscellaneous/validations.dart';
import 'package:feather_client/miscellaneous/notifiers/config.dart';
import 'package:feather_client/miscellaneous/dialogs.dart';

class ConfigView extends StatefulWidget {
  final ConfigModel model;

  const ConfigView({
    super.key,
    required this.model,
  });

  @override
  State<ConfigView> createState() => _ConfigViewState();
}

class _ConfigViewState extends State<ConfigView> {
  late final config = Provider.of<ConfigNotifier>(context, listen: false);
  late ConfigModel model = widget.model;

  late final uri = TextEditingController(text: widget.model.uri);
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
              _buildHeader(),
              BoxComponent.mediumHeight,
              ..._buildContent(),
              BoxComponent.bigHeight,
              _buildFooter(),
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
                    model.name!,
                    style: StyleUtils.highLightStyle,
                  ),
                  BoxComponent.smallWidth,
                  if (isNameFieldHoverred) ...[
                    _buildEditButton(),
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
        _buildFavoriteButton(model.favorite),
      ],
    );
  }

  Widget _buildEditButton() {
    return IconButtonComponent(
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
              defaultValue: model.name,
              saveCbk: (value) {
                setState(
                  () => widget.model.setName(
                    value.text,
                  ),
                );
              },
            );
          },
        );
      },
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
            if (model.name != null) {
              return _saveConfig();
            }

            showDialog(
              context: context,
              builder: (context) {
                return NameEditDialog(
                  saveCbk: (value) => _saveConfig(name: value.text),
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
          onPressed: () {
            _saveConfig();

            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => ConnectionPage(model: model),
            ));
          },
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
          onPressed: () {
            config.setCurrent(model: model);
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => ConnectionPage(model: model),
            ));
          },
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
          model.setFavorite(!isFavorite);
        });
      },
    );
  }

  void _saveConfig({String? name}) {
    if (name != null) model.setName(name);
    model.setUri(uri.text);
    model.save();

    config.add(widget.model);
  }
}
