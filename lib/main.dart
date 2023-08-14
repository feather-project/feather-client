import 'package:feather_client/miscellaneous/notifiers/config.dart';
import 'package:feather_client/miscellaneous/notifiers/view.dart';
import 'package:feather_client/miscellaneous/platforms.dart';
import 'package:flutter/material.dart';

import 'package:feather_client/pages/pages.dart';
import 'package:feather_client/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

void main() {
  runApp(const Client());
  WindowManager.instance.setMinimumSize(const Size(1200, 650));
}

class Client extends StatelessWidget {
  const Client({super.key});

  @override
  Widget build(BuildContext context) {
    Platforms.getInstallDirectory().createSync(recursive: true);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ConfigNotifier>(
          create: (_) => ConfigNotifier(),
        ),
        ChangeNotifierProvider<ViewNotifier>(
          create: (_) => ViewNotifier(),
        ),
      ],
      child: MaterialApp(
        title: "${EnvUtils.kProject} - ${EnvUtils.kName}",
        home: const DashboardPage(),
        theme: ThemeData(
          scaffoldBackgroundColor: ThemeUtils.kBackground,
        ),
      ),
    );
  }
}
