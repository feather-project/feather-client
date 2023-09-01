import 'dart:convert';

import 'package:feather_client/miscellaneous/notifiers/logs.dart';
import 'package:feather_client/models/model/file.dart';
import 'package:feather_client/views/views.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'package:feather_client/components/components.dart';
import 'package:feather_client/models/model/config.dart';
import 'package:feather_client/utils/utils.dart';
import 'package:feather_client/components/custom/browser_sidebar.dart';

import 'package:feather_client/miscellaneous/notifiers/connection.dart';
import 'package:feather_client/miscellaneous/notifiers/view.dart';

import 'dashboard.dart';

class BrowserPage extends StatefulWidget {
  final ConfigModel config;

  const BrowserPage({super.key, required this.config});

  @override
  State<BrowserPage> createState() => _BrowserPageState();
}

class _BrowserPageState extends State<BrowserPage> {
  late final notify = Provider.of<ConnectionNotifier>(context, listen: false);
  late final view = Provider.of<ViewNotifier>(context);
  late final logs = Provider.of<LogsNotifier>(context, listen: false);

  bool socketLost = false;
  String? socketError;
  String? socketReason;

  List<FileModel> models = [];

  @override
  void initState() {
    super.initState();

    notify.connection?.listen(
      onReceivedCallback,
      onError: onErrorCallback,
      onDone: onDoneCallback,
    );

    fetchFiles();
  }

  @override
  Widget build(BuildContext context) {
    return PageComponent(
      name: 'Browser',
      sideBar: socketLost ? null : _buildSidebar(),
      content: socketLost ? _buildErrorContent() : [_buildContent()],
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

  Widget _buildSidebar() {
    return BrowserSidebar(
      name: widget.config.name!,
      files: [
        for (final model in models) ...[
          _buildSidebarItem(model),
        ],
      ],
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(280, 10, 20, 10),
      child: view.current,
    );
  }

  SidebarItem _buildSidebarItem(FileModel model) {
    return SidebarItem(
      title: Text(
        model.id,
        style: StyleUtils.regularLightStyle,
      ),
      leading: const Icon(
        FontAwesomeIcons.fileContract,
        color: ThemeUtils.kText,
        size: 20,
      ),
      onTap: () => {
        logs.setCurrent(model: model),
        view.setCurrent(view: const LogsView()),
      },
    );
  }

  void onReceivedCallback(String line) {
    if (line.toLowerCase().contains('heartbeat')) return;

    try {
      final payload = jsonDecode(line);

      switch (payload['event']) {
        case 'disconnect':
          {
            setState(() {
              socketError = payload['error'] as String?;
              socketReason = payload['reason'] as String?;
            });
            break;
          }
        case 'list':
          {
            setState(() {
              models = List<String>.from(payload['files'] as List)
                  .map((e) => FileModel(e))
                  .toList();
            });
          }
      }
    } catch (e) {
      print('$e');
    }
  }

  void onErrorCallback(dynamic error) {
    print('$error');
  }

  void onDoneCallback() {
    print('Connection done');
    setState(() => socketLost = true);
  }

  void listenTo(String fileId) {
    notify.send({
      'fileId': fileId,
      'request': 'listen',
    }.toString());
  }

  void fetchFiles() {
    notify.send({
      'request': 'list',
    }.toString());
  }
}
