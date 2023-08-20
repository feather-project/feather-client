import 'package:flutter/material.dart';

import 'package:feather_client/models/models.dart';

class ConnectionNotifier extends ChangeNotifier {
  ConnectionModel? connection;

  void set(ConnectionModel model) {
    connection = model;
    _notify();
  }

  Future<bool?> connect() async {
    return connection?.connect();
  }

  void close() {
    connection?.close();
    connection = null;

    _notify();
    print("ez");
  }

  void listen(
    void Function(String) onReceived, {
    void Function(dynamic)? onError,
    void Function()? onDone,
  }) {
    connection?.listen(onReceived, onError: onError, onDone: onDone);
  }

  void _notify() {
    print("ConnectionProvider: Notified listeners.");
    notifyListeners();
  }
}
