import 'package:path/path.dart';
import 'dart:io' as io;
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
class DBGuides {
  Database? _db;
  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDb();
    return _db!;
  }

  initDb() async {
    io.Directory dd = await getApplicationDocumentsDirectory();
    String path = join(dd.path, "dbguides.db");
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE guides(id INTEGER PRIMARY KEY AUTOINCREMENT,url TEXT, startDate TEXT,endDate TEXT, name TEXT, icon TEXT)");
    print("Create table");
  }

  void insetdata(String url, startDate, endDate, name, icon) async {
    final insertdb = await db;
    insertdb.insert("guides", {
      "url": url,
      "startDate": startDate,
      "endDate": endDate,
      "name": name,
      "icon": icon
    });
  }

  Future<void> close() async {
    await _db!.close();
  }
}