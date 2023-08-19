import 'package:feather_client/views/view/create.dart';
import 'package:flutter/material.dart';

class ViewNotifier extends ChangeNotifier {
  Widget widget = const CreateView();

  void set(Widget widget) {
    if (this.widget.key == widget.key) return;
    this.widget = widget;
    _notify();
  }

  bool isSame(Key key) {
    return widget.key == key;
  }

  void _notify() {
    print("ViewNotifier: Notified listeners.");
    notifyListeners();
  }
}
