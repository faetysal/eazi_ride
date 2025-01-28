import 'package:eazi_ride/src/models/user.dart';
import 'package:eazi_ride/src/services/app_db.dart';
import 'package:sembast/sembast_io.dart';

class UserDao {
  static const String userStoreName = 'users';
  final _store = intMapStoreFactory.store(userStoreName);
  Future<Database> get _db async => await AppDB().db;

  Future save(User user) async {
    // 1 sec delay to simulate network
    await Future.delayed(const Duration(seconds: 1));
    await _store.add(await _db, user.toMap());
  }

  Future<List<User>> find() async {
    final snapshot = await _store.find(await _db);
    return snapshot.map((snapshot) {
      final user = User.fromMap(snapshot.value);
      user.id = snapshot.key;

      return user;
    }).toList();
  }

}