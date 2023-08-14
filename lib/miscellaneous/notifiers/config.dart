import 'dart:convert';
import 'dart:typed_data';

import 'package:feather_client/miscellaneous/platforms.dart';
import 'package:feather_client/models/models.dart';
import 'package:feather_client/utils/utils.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';

class ConfigNotifier extends ChangeNotifier {
  List<ConfigModel> configs = [];

  void add(ConfigModel model) {
    configs.add(model);
    _notify();
  }

  void addAll(List<ConfigModel> models) {
    configs.addAll(models);
    _notify();
  }

  void remove(ConfigModel model) {
    configs.remove(model);
    _notify();
  }

  void clear() {
    configs.clear();
    _notify();
  }

  void _notify() {
    print("Notified");
    notifyListeners();
  }

  List<ConfigModel> getConfigs() {
    return configs;
  }

  List<ConfigModel> getFavorites() {
    return configs.where((e) => e.favorite).toList();
  }

  void load() {
    for (final file in Platforms.getInstallDirectory().listSync()) {
      add(ConfigModel.fromFile(file));
    }
  }

  Future<void> export() async {
    const name = "viewer-connections.json";

    final location = await getSaveLocation(
      suggestedName: name,
    );
    if (location == null) return;

    final json = {
      "type": "Feather Viewer",
      "version": EnvUtils.kVersion,
      "connections": configs.map((e) => e.toJson()).toList()
    };

    await XFile.fromData(
      Uint8List.fromList(utf8.encode(jsonEncode(json))),
      name: name,
    ).saveTo(location.path);
  }

  Future<void> import() async {}

  void reset() {
    final List<ConfigModel> models = [];
    for (final file in Platforms.getInstallDirectory().listSync()) {
      models.add(ConfigModel.fromFile(file)
        ..setFavorite(false)
        ..save());
    }

    clear();
    addAll(models);
  }
}
