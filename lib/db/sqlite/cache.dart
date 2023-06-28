import 'package:cloud_lock/db/sqlite.dart';

class Cache {

  static const String tableName = Sqlite.tableName;
  static const String keyField = Sqlite.keyField;
  static const String valueField = Sqlite.valueField;

  Future<int> set(String key, String value) async {
    final db = await Sqlite.instance.database;
    return await db.rawInsert("REPLACE INTO cache ($keyField, $valueField) VALUES (?, ?)",
      [key, value]);
  }

  Future<int> del(String key) async {
    final db = await Sqlite.instance.database;
    return await db.delete(tableName, where: "$keyField = ?", whereArgs: [key]);
  }

  Future<String> get(String key) async {
    final db = await Sqlite.instance.database;
    var result = await db.rawQuery('SELECT $valueField FROM $tableName WHERE $keyField = ?', [key]);
    if (result.isNotEmpty) {
      return result.first['value'].toString();
    } else {
      return '';
    }
  }
}