import 'package:feather_client/views/view/connect.dart';
import 'package:flutter/material.dart';

class ViewNotifier extends ChangeNotifier {
  Widget widget = const ConnectView();

  void set(Widget widget) {
    if (this.widget == widget) return;
    if (this.widget.key == widget.key) return;

    this.widget = widget;
    _notify();
  }

  void _notify() {
    print("ViewNotifier: Notified listeners.");
    notifyListeners();
  }
}
