import 'dart:convert';

import 'package:feather_client/models/model/config.dart';
import 'package:feather_client/utils/utils.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:feather_client/components/components.dart';
import 'package:feather_client/components/custom/browser_sidebar.dart';
import 'package:feather_client/miscellaneous/notifiers/connection.dart';

import 'dashboard.dart';

class BrowserPage extends StatefulWidget {
  final ConfigModel config;

  const BrowserPage({super.key, required this.config});

  @override
  State<BrowserPage> createState() => _BrowserPageState();
}

class _BrowserPageState extends State<BrowserPage> {
  late final notify = Provider.of<ConnectionNotifier>(context, listen: false);

  bool socketLost = false;
  String? socketError;
  String? socketReason;

  @override
  void initState() {
    super.initState();

    notify.connection?.listen(
      onReceivedCallback,
      onError: onErrorCallback,
      onDone: onDoneCallback,
    );

    /*notify.send({
      'fileId': widget.config.name,
      'request': 'listen',
    }.toString());*/
  }

  @override
  Widget build(BuildContext context) {
    return PageComponent(
      name: 'Browser',
      sideBar: socketLost ? null : BrowserSidebar(name: widget.config.name!),
      content: socketLost ? _buildErrorContent() : [],
    );
  }

  List<Widget> _buildErrorContent() {
    return [
      const Text(
        "An error occured while reading from/writing to the websocket...",
        style: StyleUtils.regularLightStyle,
      ),
      BoxComponent.smallHeight,
      SizedBox(
        width: 450,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (socketReason != null) ...[
              const Text(
                "Reason:",
                style: StyleUtils.regularLightStyle,
              ),
              Text(
                socketReason!,
                style: StyleUtils.mediumLightStyle,
              ),
              BoxComponent.smallHeight,
            ],
            if (socketError != null) ...[
              const Text(
                "Error:",
                style: StyleUtils.regularLightStyle,
              ),
              Text(
                socketError!,
                style: StyleUtils.mediumLightStyle,
              ),
            ],
          ],
        ),
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
          notify.close();

          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const DashboardPage(),
          ));
        },
      ),
    ];
  }

  void onReceivedCallback(String line) {
    print(line);

    if (line.contains('reason')) {
      final payload = jsonDecode(line);

      setState(() {
        socketError = payload['error'];
        socketReason = payload['reason'];
      });
    }
  }

  void onErrorCallback(dynamic error) {
    print('$error');
  }

  void onDoneCallback() {
    print('Connection done');
    setState(() => socketLost = true);
  }
}
