import 'package:uuid/uuid.dart';

class IdUtil {
  static int generateIntId() {
    var uuid = const Uuid();
    String uuidString = uuid.v1().substring(0, 4);
    int integerId = int.parse(uuidString.replaceAll('-', ''), radix: 16);
    return integerId;
  }
}
