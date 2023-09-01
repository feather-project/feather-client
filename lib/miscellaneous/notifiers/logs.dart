import 'package:flutter/material.dart';

import 'package:feather_client/models/model/file.dart';

class LogsNotifier extends ChangeNotifier {
  FileModel? current;

  void setCurrent({FileModel? model}) {
    if (current == model) return;
    current = model;
    _notify();
  }

  void _notify() {
    print("LogsNotifier: Notified listeners.");
    notifyListeners();
  }
}
