import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'package:feather_client/components/components.dart';
import 'package:feather_client/utils/utils.dart';
import 'package:feather_client/pages/pages.dart';
import 'package:feather_client/models/models.dart';

import 'package:feather_client/miscellaneous/notifiers/connection.dart';

class ConnectionPage extends StatefulWidget {
  final ConfigModel model;

  const ConnectionPage({
    super.key,
    required this.model,
  });

  @override
  State<ConnectionPage> createState() => _ConnectionPageState();
}

class _ConnectionPageState extends State<ConnectionPage> {
  late final notify = Provider.of<ConnectionNotifier>(context, listen: false);
  bool? isConnected;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback(
      (timeStamp) => _connectToDeployment(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageComponent(
      name: 'Manager',
      content: [
        if (isConnected == null) ...[
          ..._buildWaitingConnection(),
        ] else if (isConnected!) ...[
          ..._buildSuccessConnection(),
        ] else ...[
          ..._buildFailedConnection(),
        ],
      ],
    );
  }

  List<Widget> _buildWaitingConnection() {
    return [
      const CircularProgressIndicator(),
      BoxComponent.smallHeight,
      const Text(
        "Etablishing connection with remote server...",
        style: StyleUtils.regularLightStyle,
      )
    ];
  }

  List<Widget> _buildFailedConnection() {
    return [
      const Text(
        "An error occured while etablishing the connection...",
        style: StyleUtils.regularLightStyle,
      ),
      BoxComponent.smallHeight,
      Text(
        "'${widget.model.uri}'",
        style: StyleUtils.mediumLightStyle,
      ),
      BoxComponent.mediumHeight,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Make sure of the followings",
            style: StyleUtils.mediumLightStyle,
          ),
          BoxComponent.customHeight(5),
          const Text(
            "- Provided uri matches the actual endpoint of your server.",
            style: StyleUtils.mediumLightStyle,
          ),
          BoxComponent.customHeight(2),
          const Text(
            "- Specified port is opened and serves the public internet.",
            style: StyleUtils.mediumLightStyle,
          ),
        ],
      ),
      BoxComponent.mediumHeight,
      const Text(
        "Have a look at our documentation to verify your installation.",
        style: StyleUtils.mediumLightStyle,
      ),
      BoxComponent.smallHeight,
      ButtonComponent(
        hover: ThemeUtils.kSecondaryButton,
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        content: const Text(
          "Visit our Docs",
          style: StyleUtils.mediumLightStyle,
        ),
        onPressed: () {
          launchUrlString('${EnvUtils.kWebsite}/docs');
        },
      ),
      BoxComponent.mediumHeight,
      const Text(
        "If the problem perssist, please open an issue so we can investigate.",
        style: StyleUtils.mediumLightStyle,
      ),
      BoxComponent.smallHeight,
      ButtonComponent(
        hover: ThemeUtils.kSecondaryButton,
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        content: const Text(
          "Open an issue",
          style: StyleUtils.mediumLightStyle,
        ),
        onPressed: () {
          launchUrlString(
            'https://github.com/feather-project/feather-client/issues',
          );
        },
      ),
      BoxComponent.mediumHeight,
      ButtonComponent(
        hover: ThemeUtils.kSecondaryButton,
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        content: const Text(
          "Return back to dashboard",
          style: StyleUtils.mediumLightStyle,
        ),
        onPressed: () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const DashboardPage(),
          ));
        },
      ),
    ];
  }

  List<Widget> _buildSuccessConnection() {
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const BrowserPage(),
      ));
    });

    return [
      const CircularProgressIndicator(),
      BoxComponent.smallHeight,
      const Text(
        "Redirection in progress...",
        style: StyleUtils.regularLightStyle,
      ),
    ];
  }

  Future<void> _connectToDeployment() async {
    notify.set(ConnectionModel(
      Constants.kUuid,
      widget.model.uri!,
    ));

    final success = await notify.connect();

    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() => isConnected = success);
    });
  }
}
