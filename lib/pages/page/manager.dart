import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:feather_client/components/components.dart';
import 'package:feather_client/utils/utils.dart';
import 'package:feather_client/models/models.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ManagerPage extends StatefulWidget {
  final ConfigModel config;

  const ManagerPage({
    super.key,
    required this.config,
  });

  @override
  State<ManagerPage> createState() => _ManagerPageState();
}

class _ManagerPageState extends State<ManagerPage> {
  @override
  Widget build(BuildContext context) {
    return PageComponent(
      name: 'Manager',
      content: [
        FutureBuilder(
          future: _connect(),
          builder: (context, snapshot) {
            if (snapshot.isLoading) {
              return _buildWaitingConnection();
            } else if (snapshot.hasError) {
              return _buildFailedConnection();
            } else {
              return _buildSuccessConnection();
            }
          },
        ),
      ],
    );
  }

  Widget _buildWaitingConnection() {
    return Column(
      children: [
        const CircularProgressIndicator(),
        BoxComponent.smallHeight,
        const Text(
          "Etablishing connection with remote server...",
          style: StyleUtils.regularLightStyle,
        )
      ],
    );
  }

  Widget _buildFailedConnection() {
    return Column(
      children: [
        const Text(
          "An error occured while etablishing the connection...",
          style: StyleUtils.regularLightStyle,
        ),
        BoxComponent.smallHeight,
        Text(
          "'${widget.config.uri}'",
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
      ],
    );
  }

  Widget _buildSuccessConnection() {
    return Column(
      children: [],
    );
  }

  Future<bool> _connect() async {
    final uuid = '123456';
    final id = '789';

    final uri = "${widget.config.uri!}/connect?uuid=$uuid&id=$id";
    final request = http.Request('GET', Uri.parse(uri));

    final client = http.Client();
    final channel = await client.send(request);

    channel.stream.transform(utf8.decoder).listen((line) {
      print('Received: $line');
    }, onError: (error) {
      print('Error: $error');
    }, onDone: () {
      print('Connection closed.');
    });

    return channel.statusCode == 200 ? true : false;
  }
}
