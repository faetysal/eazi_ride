import 'package:sembast/sembast_io.dart';

class AppDB {
  AppDB._();

  static final AppDB _instance = AppDB._();
  Database? _db;
  final String _dbName = 'app.db';

  factory AppDB() {
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