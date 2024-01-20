//! LOG EXTENSION - THIS HELPS TO CALL A .log() ON ANY OBJECT
import 'package:flutter/foundation.dart';

extension Log on Object {
  void log() {
    if (kDebugMode) {
      print(toString());
    }
  }
}