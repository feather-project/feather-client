import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:feather_client/components/components.dart';
import 'package:feather_client/components/custom/browser_sidebar.dart';

import 'package:feather_client/miscellaneous/notifiers/config.dart';
import 'package:feather_client/miscellaneous/notifiers/connection.dart';

class BrowserPage extends StatefulWidget {
  const BrowserPage({super.key});

  @override
  State<BrowserPage> createState() => _BrowserPageState();
}

class _BrowserPageState extends State<BrowserPage> {
  late final notify = Provider.of<ConnectionNotifier>(context, listen: false);
  late final config = Provider.of<ConfigNotifier>(context, listen: false);

  @override
  void initState() {
    super.initState();

    notify.connection.channel!.stream.transform(utf8.decoder).listen((line) {
      print('Received: $line');
    }, onError: (error) {
      print('Error: $error');
    }, onDone: () {
      print('Connection closed.');
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageComponent(
      name: 'Browser',
      sideBar: BrowserSidebar(name: ''),
      content: [],
    );
  }
}
