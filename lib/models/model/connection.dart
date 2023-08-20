import 'dart:async';

import 'package:web_socket_channel/web_socket_channel.dart';

class ConnectionModel {
  WebSocketChannel? channel;
  StreamSubscription? stream;

  final String uri;
  final String clientId;

  ConnectionModel(this.clientId, this.uri);

  Future<bool> connect() async {
    try {
      final url = "$uri?clientId=$clientId";
      channel = WebSocketChannel.connect(Uri.parse(url));
    } catch (e) {
      channel = null;
    }
    return channel != null;
  }

  void close() {
    channel?.sink.close();
    stream?.cancel();
  }

  void listen(
    void Function(String) onReceived, {
    void Function(dynamic)? onError,
    void Function()? onDone,
  }) {
    stream = channel!.stream.listen((message) {
      onReceived(message);
    }, onError: (error) {
      onError?.call(error);
    }, onDone: () {
      onDone?.call();
    });
  }

  void send(String message) {
    channel?.sink.add(message);
  }
}
