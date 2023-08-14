import 'package:feather_client/views/view/connect.dart';
import 'package:flutter/material.dart';

class ViewNotifier extends ChangeNotifier {
  Widget widget = const ConnectView();

  void set(Widget widget) {
    this.widget = widget;
    _notify();
  }

  void _notify() {
    print("ViewNotifier: Notified listeners.");
    notifyListeners();
  }
}
