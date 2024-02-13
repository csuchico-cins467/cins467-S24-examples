import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

const String tableCount = 'tableCount';
const String columnId = '_id';
const String columnCount = 'count';

class CountObject {
  late int id;
  late int count;

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      columnCount: count,
    };
    // ignore: unnecessary_null_comparison
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  CountObject();

  CountObject.fromMap(Map<dynamic, dynamic> map) {
    id = map[columnId];
    count = map[columnCount];
  }
}

class CounterStorage {
  Database? _db;

  void initDB() async {
    _db = await open('counter.db');
  }

  CounterStorage() {
    initDB();
  }

  Future open(String path) async {
    _db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
create table $tableCount (
  $columnId integer primary key autoincrement,
  $columnCount integer not null)
''');
    });
  }

  Future<CountObject> insert(CountObject co) async {
    co.id = await _db!.insert(tableCount, co.toMap());
    return co;
  }

  Future<CountObject> getCount(int id) async {
    List<Map> maps = await _db!.query(tableCount,
        columns: [columnId, columnCount],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return CountObject.fromMap(maps.first);
    }
    CountObject co = CountObject();
    co.count = 0;
    co.id = id;
    co = await insert(co);
    return co;
  }

  Future<int> update(CountObject co) async {
    return await _db!.update(tableCount, co.toMap(),
        where: '$columnId = ?', whereArgs: [co.id]);
  }

  Future close() async => _db!.close();

  Future<int> readCounter() async {
    try {
      if (_db == null) {
        await open('counter.db');
      }
      CountObject co = await getCount(1);
      // await close();
      return co.count;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return 0;
  }

  Future<void> writeCounter(int counter) async {
    try {
      // await open('counter.db');
      // Copilot Code
      // CountObject co = await getCount(1);
      // co.count = counter;
      // await update(co);
      if (_db == null) {
        await open('counter.db');
      }
      // Original Code
      CountObject co = CountObject();
      co.count = counter;
      co.id = 1;
      await update(co);
      // await close();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
