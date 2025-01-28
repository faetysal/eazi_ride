import 'package:eazi_ride/src/models/user.dart';
import 'package:eazi_ride/src/services/user_dao.dart';
import 'package:get/get.dart';
import 'package:sembast/sembast_io.dart';

class UserService extends GetxController {
  late UserDao _userDao;

  @override
  void onInit() {
    super.onInit();
    _userDao = UserDao();
  }

  Future signup(User user) async {
    // 1 sec delay to simulate network
    await Future.delayed(const Duration(seconds: 1));

    final result = await _userDao.save(user);
    return result;
  }

  Future<User?> getUserByEmail(String email) async {
    await Future.delayed(const Duration(seconds: 1));
    
    final filter = Filter.equals('email', email);
    final User? user = await _userDao.findOne([filter]);
    return user;
  }
}