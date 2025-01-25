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

  Future login(Map<String, dynamic> res) async {
    final Map<String, dynamic> user = res['data'];
    final String authToken = res['access_token'];
    await storage.write('user', user);
    await storage.write('authToken', authToken);
    loggedIn.value = true;
    userObs.value = user;
  }

  void updateUser(Map<String, dynamic> data) async {
    final Map<String, dynamic> newData = {
      ...user,
      ...data
    };
    await storage.write('user', newData);
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

  String get userInitials {
    final fname = userNames.first;
    final lname = userNames.last;
    
    return '${fname.substring(0,1)}${lname.substring(0,1)}'.toUpperCase();
  }

  String get userFullName {
    final String fname = userNames.first;
    final String lname = userNames.last;
    
    return '${fname.capitalizeFirst} ${lname.capitalizeFirst}';
  }

  List<String> get userNames {
    final String names = user['name'];
    final String fname = names.trim().split(' ').first;
    final String lname = names.trim().split(' ').last;
    
    return [fname.capitalizeFirst!, lname.capitalizeFirst!];
  }
}