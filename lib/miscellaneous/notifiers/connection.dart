import 'package:flutter/material.dart';

import 'package:feather_client/models/models.dart';

class ConnectionNotifier extends ChangeNotifier {
  late ConnectionModel connection;

  void set(ConnectionModel model) {
    connection = model;
    _notify();
  }

  Future<bool> connect() async {
    return await connection.connect() != null;
  }

  void _notify() {
    print("ConnectionProvider: Notified listeners.");
    notifyListeners();
  }
}
