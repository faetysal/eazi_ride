import 'package:eazi_ride/src/models/user.dart';
import 'package:eazi_ride/src/services/app_db.dart';
import 'package:sembast/sembast_io.dart';

class UserDao {
  static const String userStoreName = 'users';
  final _store = intMapStoreFactory.store(userStoreName);
  Future<Database> get _db async => await AppDB().db;

  Future save(User user) async {
    final id = await _store.add(await _db, user.toMap());
    return id;
  }

  Future<List<User>> find() async {
    final snapshot = await _store.find(await _db);
    return snapshot.map((snapshot) {
      final user = User.fromMap(snapshot.value);
      user.id = snapshot.key;

      return user;
    }).toList();
  }

  Future<User?> findOne(List<Filter> filters) async {
    final finder = Finder(filter: Filter.and(filters));
    final record = await _store.findFirst(await _db, finder: finder);

    if (record == null) {
      return null;
    }

    final user = User.fromMap(record.value);
    user.id = record.key;

    return user;
  }

}