import 'package:eazi_ride/src/views/login.dart';
import 'package:eazi_ride/src/views/test.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'services/auth_manager.dart';
import 'views/home.dart';
import 'views/onboarding.dart';
import 'views/signup.dart';

class Init extends StatelessWidget {
  Init({super.key});

  final AuthManager _authManager = Get.find();

  Future<void> _init() async {
    // GetStorage().erase();
    _authManager.validateUser();
  }
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _init(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildStatus();
        } else {
          if (snapshot.hasError) {
            return _buildStatus(msg: snapshot.error.toString());
          } else {
            return const RedirectToView();
          }
        }
      }
    );
  }

  Scaffold _buildStatus({String? msg}) {
    return Scaffold(
      body: Center(
        child: msg != null 
          ? Text(msg)
          : const CircularProgressIndicator.adaptive()
      ),
    );
  }
}

class RedirectToView extends StatelessWidget {
  const RedirectToView({super.key});

  @override
  Widget build(BuildContext context) {
    AuthManager authManager = Get.find();

    return Navigator(
      key: Get.nestedKey(0),
      onGenerateRoute: (settings) {
        Widget page = authManager.loggedIn.value ? Home() : const Onboarding();

        return GetPageRoute(page: () => page);
      },
    );
  }
}