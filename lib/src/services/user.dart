import 'package:eazi_ride/src/models/user.dart';
import 'package:eazi_ride/src/services/user_dao.dart';
import 'package:get/get.dart';

class UserService extends GetxController {
  late UserDao _userDao;

  @override
  void onInit() {
    super.onInit();
    _userDao = UserDao();
  }

  Future signup(User user) async {
    await _userDao.save(user);
  }
}