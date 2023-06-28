import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Sqlite {
  static const _databaseName = "cache.db";
  static const _databaseVersion = 1;

  static const String tableName = "`cache`";
  static const String keyField = "`key`";
  static const String valueField = "`value`";
  static const String sql = "CREATE TABLE IF NOT EXISTS $tableName ("
      "  $keyField varchar(64) NOT NULL PRIMARY KEY,"
      "  $valueField varchar(255) NOT NULL"
      ")";
  static const String initHost = "INSERT INTO $tableName ($keyField, $valueField) "
      "VALUES ('host', 'http://10.4.61.194:8089')";

  // make this a singleton class
  Sqlite._privateConstructor();
  static final Sqlite instance = Sqlite._privateConstructor();

  // only have a single app-wide reference to the database
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute(sql);
    await db.execute(initHost);
  }
}
