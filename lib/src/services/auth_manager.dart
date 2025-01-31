import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthManager extends GetxService {
  late RxBool loggedIn;
  late GetStorage storage;
  Rx<Map?> userObs = Rxn<Map>();

  AuthManager init() {
    return this;
  }

  @override
  void onInit() {
    super.onInit();
    storage = GetStorage();
    loggedIn = false.obs;
  }

  void logout() async {
    loggedIn.value = false;
    userObs.value = null;
    await storage.remove('authToken');
    await storage.remove('user');
  }

  Future login(Map<String, dynamic> userMap) async {
    await storage.write('user', userMap);
  }

  dynamic get user {
    final user = storage.read('user');
    return user;
  }

  void validateUser() {
    if (user != null) {
      loggedIn.value = true;
    }
  }
}