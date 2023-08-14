import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:feather_client/miscellaneous/platforms.dart';

class ConfigModel {
  String? name;
  String? uri;
  bool favorite;

  ConfigModel({
    this.name,
    this.uri,
    this.favorite = false,
  });

  factory ConfigModel.fromJson(final Map<String, dynamic> json) {
    return ConfigModel(
      name: json['name'],
      uri: json['uri'],
      favorite: json['isFavorite'],
    );
  }

  factory ConfigModel.fromFile(final FileSystemEntity file) {
    return ConfigModel.fromJson(
      jsonDecode(File(file.path).readAsStringSync()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'uri': uri,
      'isFavorite': favorite,
    };
  }

  void save() {
    final installDir = Platforms.getInstallDirectory();
    final file = File(
      "${installDir.path}/${getUuid()}.json",
    );

    file.createSync(recursive: true);
    file.writeAsStringSync(jsonEncode(toJson()));
  }

  void setFavorite(bool condition) {
    favorite = condition;
  }

  void setName(String str) {
    name = str;
  }

  void setUri(String str) {
    uri = str;
  }

  String getUuid() {
    final bytes = utf8.encode(name!);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
