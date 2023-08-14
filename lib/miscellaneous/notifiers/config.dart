import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:file_selector/file_selector.dart';

import 'package:feather_client/miscellaneous/platforms.dart';
import 'package:feather_client/models/models.dart';
import 'package:feather_client/utils/utils.dart';

class ConfigNotifier extends ChangeNotifier {
  Map<String, ConfigModel> configs = {};

  void add(ConfigModel model) {
    configs[model.getUuid()] = model;
    _notify();
  }

  void addAll(List<ConfigModel> models) {
    for (final model in models) {
      configs[model.getUuid()] = model;
    }
    _notify();
  }

  void remove(String uuid) {
    configs.remove(uuid);
    _notify();
  }

  void clear() {
    configs.clear();
    _notify();
  }

  void _notify() {
    print("ConfigNotifier: Notified listeners.");
    notifyListeners();
  }

  List<ConfigModel> getConfigs() {
    return configs.values.toList();
  }

  List<ConfigModel> getFavorites() {
    return configs.values.where((e) => e.favorite).toList();
  }

  void load() {
    for (final file in Platforms.getInstallDirectory().listSync()) {
      add(ConfigModel.fromFile(file));
    }
  }

  Future<void> export() async {
    const name = "viewer-connections.json";

    final location = await getSaveLocation(suggestedName: name);
    if (location == null) return;

    final json = {
      "type": "Feather Viewer",
      "version": EnvUtils.kVersion,
      "connections": configs.values.map((e) => e.toJson()).toList()
    };

    await XFile.fromData(
      Uint8List.fromList(utf8.encode(jsonEncode(json))),
      name: name,
    ).saveTo(location.path);
  }

  Future<void> import() async {
    const extensions = XTypeGroup(
      label: 'json',
      extensions: <String>['json'],
    );

    final file = await openFile(
      acceptedTypeGroups: <XTypeGroup>[extensions],
    );
    if (file == null) return;

    final json = jsonDecode(await file.readAsString());
    final configs = json['connections'] as List<dynamic>;
    final models = configs.map((e) => ConfigModel.fromJson(e)).toList();

    for (final model in models) {
      model.save();
    }

    addAll(models);
  }

  void clearFavorites() {
    final List<ConfigModel> models = [];
    for (final file in Platforms.getInstallDirectory().listSync()) {
      models.add(ConfigModel.fromFile(file)
        ..setFavorite(false)
        ..save());
    }

    configs.clear();
    addAll(models);
  }
}
