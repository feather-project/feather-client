import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:feather_client/miscellaneous/platforms.dart';
import 'package:feather_client/miscellaneous/notifiers/config.dart';
import 'package:feather_client/components/components.dart';
import 'package:feather_client/utils/utils.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  late final config = Provider.of<ConfigNotifier>(context, listen: false);

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
              const Text("Viewer settings", style: StyleUtils.highLightStyle),
              BoxComponent.mediumHeight,
              const Text(
                "This action will delete all the stored configurations.",
                style: StyleUtils.mediumLightStyle,
              ),
              BoxComponent.smallHeight,
              ButtonComponent(
                color: ThemeUtils.kSecondaryButton,
                hover: ThemeUtils.kAccent,
                content: const Text(
                  "Delete cache",
                  style: StyleUtils.regularLightStyle,
                ),
                onPressed: () {
                  final dir = Platforms.getInstallDirectory();
                  final files = dir.listSync();

                  for (final file in files) {
                    file.deleteSync(recursive: true);
                  }

                  showDialog(
                    context: context,
                    builder: (context) => _buildSuccessDialog(),
                  );

                  config.clear();
                },
              ),
              BoxComponent.mediumHeight,
              const Text(
                "Open the directory where configurations are stored.",
                style: StyleUtils.mediumLightStyle,
              ),
              BoxComponent.smallHeight,
              ButtonComponent(
                color: ThemeUtils.kSecondaryButton,
                hover: ThemeUtils.kAccent,
                content: const Text(
                  "Open cache",
                  style: StyleUtils.regularLightStyle,
                ),
                onPressed: () {
                  final path = Platforms.getInstallDirectory().path;

                  if (Platform.isWindows) {
                    Process.run('explorer', [path]);
                  } else if (Platform.isMacOS) {
                    Process.run('open', [path]);
                  } else if (Platform.isLinux) {
                    Process.run('xdg-open', [path]);
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  AlertDialog _buildSuccessDialog() {
    return AlertDialog(
      backgroundColor: ThemeUtils.kBackground,
      actionsPadding: const EdgeInsets.fromLTRB(0, 0, 25, 25),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      title: const Text(
        "Successfully cleared cache",
        style: StyleUtils.highLightStyle,
      ),
      content: const Text(
        "No more actions required, you can safely close this window.",
        style: StyleUtils.regularLightStyle,
      ),
      actions: [
        ButtonComponent(
          hover: ThemeUtils.kAccent,
          padding: const EdgeInsets.fromLTRB(10, 6, 10, 6),
          content: const Text(
            "Close",
            style: StyleUtils.regularLightStyle,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
