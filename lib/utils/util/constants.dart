import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class Constants {
  static DateFormat kFrenchHourFormat = DateFormat('HH:mm');
  static DateFormat kFrenchDateFormat = DateFormat('dd/MM/yyyy');
  static DateFormat kFrenchFullFormat = DateFormat('dd/MM/yyyy à HH:mm');

  static String kUuid = const Uuid().v5(Uuid.NAMESPACE_URL, 'feather_logger');
}
