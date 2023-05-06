import 'package:cloud_lock/db/sqlite.dart';

class Cache {

  static const String tableName = "`cache`";
  static const String keyField = "`key`";
  static const String valueField = "`value`";
  static const String sql = "CREATE TABLE IF NOT EXISTS $tableName ("
      "  $keyField varchar(64) NOT NULL PRIMARY KEY,"
      "  $valueField varchar(255) NOT NULL"
      ")";

  Cache() {
    _initAsync().then((_) {
      print("Initialization complete.");
    });
  }

  Future<void> _initAsync() async {
    (await Sqlite.instance.database).rawQuery(sql);
  }

  Future<int> set(String key, String value) async {
    final db = await Sqlite.instance.database;
    return await db.rawInsert("REPLACE INTO cache ($keyField, $valueField) VALUES (?, ?)",
      [key, value]);
  }

  Future<int> del(String key) async {
    final db = await Sqlite.instance.database;
    return await db.delete(tableName, where: "$keyField = ?", whereArgs: [key]);
  }

  Future<String?> get(String key) async {
    final db = await Sqlite.instance.database;
    var result = await db.rawQuery('SELECT $valueField FROM $tableName WHERE $keyField = ?', [key]);
    if (result.isNotEmpty) {
      return result.first['value'].toString();
    } else {
      return null;
    }
  }

  Future<void> displayAll() async {
    final db = await Sqlite.instance.database;
    (await db.rawQuery("SELECT * FROM $tableName"))
    .toList().forEach((element) {
      var tmpKey = element['key'];
      var tmpValue = element['value'];
      print("Key: $tmpKey, Value: $tmpValue");
    });
  }
}