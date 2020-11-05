import 'package:uuid/uuid.dart';

final uuid = Uuid();

String generateUniqueId() {
  return uuid.v1();
}
