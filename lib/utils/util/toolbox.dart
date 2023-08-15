import 'package:flutter/widgets.dart';

import 'package:path/path.dart' as p;

class Toolbox {
  static const int kKB = 1024;
  static const int kMB = kKB * 1024;
  static const int kGB = kMB * 1024;

  static String kBullet = "•";

  static bool snapshotDone(dynamic snapshot) {
    return snapshot.hasData || snapshot.connectionState == ConnectionState.done;
  }

  static String formatSize(int bytes) {
    if (bytes >= kGB) {
      return '${(bytes / kGB).toStringAsFixed(2)} GB';
    } else if (bytes >= kMB) {
      return '${(bytes / kMB).toStringAsFixed(2)} MB';
    } else if (bytes >= kKB) {
      return '${(bytes / kKB).toStringAsFixed(2)} KB';
    } else {
      return '$bytes bytes';
    }
  }
}

extension StringUtils on String {
  String toCapitalized() {
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }

  String getExtension({int level = 1}) {
    return p.extension(this, level).substring(1);
  }

  bool isLongerThan(int length) {
    return this.length > length;
  }

  bool equalsAny(List<String> strings) {
    return strings.contains(this);
  }
}

extension ListUtils on List<dynamic> {
  bool containsAny(List<dynamic> values) {
    for (final v in values) {
      if (contains(v)) return true;
    }

    return false;
  }

  bool get isSingle => length <= 1;
}

extension SetUtils on Set<dynamic> {
  bool containsAny(List<dynamic> values) {
    for (final v in values) {
      if (contains(v)) return true;
    }

    return false;
  }
}

extension MapUtils<A, B> on Map<A, B> {
  Map<A, B> sort() {
    var entryList = entries.toList();

    entryList.sort((a, b) {
      final tA = (a.value as dynamic).timestamp;
      final tB = (b.value as dynamic).timestamp;
      return tB.compareTo(tA);
    });

    return Map.fromEntries(entryList);
  }
}

extension SnapshotUtils on AsyncSnapshot {
  bool get isWaiting => connectionState == ConnectionState.waiting;
  bool get isDone => connectionState == ConnectionState.done;
  bool get isActive => connectionState == ConnectionState.active;
  bool get isNone => connectionState == ConnectionState.none;

  bool get isLoading => isWaiting && !hasData;
  bool get hasError => isDone && !hasData;
}
