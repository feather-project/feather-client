import 'package:feather_client/views/view/create.dart';
import 'package:flutter/material.dart';

class ViewNotifier extends ChangeNotifier {
  Widget? current = const CreateView();

  void setCurrent({Widget? view}) {
    if (current?.key == view?.key) return;
    current = view;
    _notify();
  }

  bool isSame(Key key) {
    return current?.key == key;
  }

  void _notify() {
    print("ViewNotifier: Notified listeners.");
    notifyListeners();
  }
}
