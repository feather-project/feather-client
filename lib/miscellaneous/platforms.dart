import 'dart:io';

class Platforms {
  static const String _root = "Feather";
  static const String _folder = "Viewer";

  static Directory getInstallDirectory() {
    switch (Platform.operatingSystem) {
      case 'windows':
        return Directory(
          '${Platform.environment['APPDATA']}\\$_root\\$_folder',
        );
      case 'macos':
        return Directory(
          '${Platform.environment['HOME']}/Library/Application Support/$_root/$_folder',
        );
      case 'linux':
        return Directory(
          '${Platform.environment['HOME']}/.local/share/$_root/$_folder',
        );
      default:
        return Directory(
          '${Platform.environment['HOME']}/$_root/$_folder',
        );
    }
  }
}
