import 'log.dart';

class FileModel {
  final String id;
  List<LogModel> logs;

  FileModel(
    this.id, {
    this.logs = const [],
  });
}
