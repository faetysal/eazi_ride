import 'package:sembast/sembast_io.dart';

class UserDB {
  UserDB._();

  static final UserDB _instance = UserDB._();
  Database? _db;
  String? _dbName;

  factory UserDB(String name) {
    _instance._dbName ??= name;
    return _instance;
  }

  Future<Database> get db async {
    _db ??= await _openDB();

    return _db!;
  }

  Future<Database> _openDB() async {
    const String dbDir = '/Users/fataisalami/Projects/Flutter/eazi_ride';
    final dbPath = '$dbDir/$_dbName';

    DatabaseFactory dbFactory = databaseFactoryIo;
    Database db = await dbFactory.openDatabase(dbPath);

    return db;
  }
}