import 'package:http/http.dart' as http;

class ConnectionModel {
  final client = http.Client();
  http.StreamedResponse? channel;

  final String uri;
  final String uuid;

  ConnectionModel(this.uuid, this.uri);

  Future<http.StreamedResponse?> connect() async {
    try {
      final url = "$uri/connect?uuid=$uuid";
      final request = http.Request('GET', Uri.parse(url));
      channel = await client.send(request);
    } catch (e) {
      channel = null;
    }

    return channel;
  }
}
