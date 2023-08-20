import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class ConnectionModel {
  final client = http.Client();
  http.StreamedResponse? channel;
  StreamSubscription? stream;

  final String uri;
  final String uuid;

  ConnectionModel(this.uuid, this.uri);

  Future<bool> connect() async {
    try {
      final url = "$uri/connect?uuid=$uuid";
      final request = http.Request('GET', Uri.parse(url));
      channel = await client.send(request);
    } catch (e) {
      channel = null;
    }
    return channel != null;
  }

  void close() {
    stream?.cancel();
    client.close();

    channel = null;
    stream = null;
  }

  void listen(
    void Function(String) onReceived, {
    void Function(dynamic)? onError,
    void Function()? onDone,
  }) {
    stream = channel!.stream.transform(utf8.decoder).listen((line) {
      onReceived(line);
    }, onError: (error) {
      onError?.call(error);
    }, onDone: () {
      onDone?.call();
    });
  }
}
