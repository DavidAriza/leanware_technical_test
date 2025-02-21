import 'dart:math';

import 'package:flutter/foundation.dart';

String generateUid() {
  int timestamp = DateTime.now().millisecondsSinceEpoch;
  int randomPart = Random().nextInt(99);
  if (kIsWeb) {
    timestamp = int.parse(timestamp.toString().substring(0, 5));
    return timestamp.toString();
  }
  return '$timestamp$randomPart';
}
