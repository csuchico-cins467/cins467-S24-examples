import 'dart:io';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class CounterStorage {
  CounterStorage();

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }

  Future<int> readCounter() async {
    try {
      final file = await _localFile;
      // Read the file
      String contents = await file.readAsString();
      Map<String, dynamic> counter = json.decode(contents);
      return counter['counter'] as int;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      await writeCounter(0);
    }
    return 0;
  }

  Future<void> writeCounter(int counter) async {
    try {
      final file = await _localFile;
      String jsonCounter = json.encode({'counter': counter});
      await file.writeAsString(jsonCounter);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
