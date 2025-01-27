import 'package:eazi_ride/src/components/button.dart';
import 'package:eazi_ride/src/components/input.dart';
import 'package:eazi_ride/src/components/loader.dart';
import 'package:eazi_ride/src/config.dart';
import 'package:eazi_ride/src/views/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

import 'forgot_password.dart';
import 'signup.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController controller = Get.put(LoginController());

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, kToolbarHeight + 24, 16, 40),
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text('EaziRide', style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold
                  ), textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  Expanded(
                    child: SvgPicture.asset('assets/svg/login.svg', width: double.infinity, fit: BoxFit.contain,)
                  ),
                  const SizedBox(height: 16,),
                  Container(
                    // color: Colors.yellow,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Obx(() => Form(
                      key: controller.formKey,
                      autovalidateMode: controller.validateMode.value,
                      child: Column(
                        children: [
                          ConstrainedBox(
                            constraints: const BoxConstraints(
                              minHeight: 50
                            ),
                            child: Input(
                              controller: controller.emailCtrl,
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return 'Email address cannot be empty';
                                }

                                return null;
                              },
                              placeholder: 'Email address',
                              prefixIcon: Icons.alternate_email,
                            )
                          ),
                          const SizedBox(height: 16),
                          ConstrainedBox(
                            constraints: const BoxConstraints(
                              minHeight: 50
                            ),
                            child: Input(
                              controller: controller.passwordCtrl,
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return 'Password cannot be empty';
                                }

                                return null;
                              },
                              placeholder: 'Enter password',
                              obscureText: controller.hidePassword.value,
                              prefixIcon: Icons.lock_outline,
                              suffixIcon: controller.hidePassword.value
                                ? Icons.visibility_off
                                : Icons.visibility_outlined,
                              onSuffixIconTap: () => controller.hidePassword.toggle(),
                            )
                          ),
                          const SizedBox(height: 4,),
                          Align(
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              onTap: () => Get.to(ForgotPassword(), id: 0),
                              child: Text('Forgot Password?', style: TextStyle(
                                color: colorBlack
                              ))
                            )
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            height: 48,
                            width: double.infinity,
                            child: Button(
                              onPressed: () {
                                FocusScopeNode currFocus = FocusScope.of(context);
                                if (!currFocus.hasPrimaryFocus) {
                                  currFocus.unfocus();
                                }

                                controller.login();
                              },
                              label: 'Login',
                              //icon: Icons.arrow_circle_right
                            )
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Don\'t have an account? ', style: TextStyle(
                                color: colorGrey
                              )),
                              InkWell(
                                onTap: () => Get.off(Signup(), id: 0),
                                child: Text('Sign Up', style: TextStyle(
                                  color: colorBlack
                                )),
                              )
                            ],
                          )
                        ],
                      ),
                    ))
                  )
                ],
              )
            ),
          ),
          Obx(() {
            if (controller.authenticating.value) {
              return const Loader();
            }

            return Container();
          })
        ],
      )
    );
  }
}

class LoginController extends GetxController {
  late GlobalKey<FormState> formKey;
  Rx<AutovalidateMode> validateMode = AutovalidateMode.disabled.obs;
  RxBool hidePassword = true.obs;
  RxBool authenticating = false.obs;

  late TextEditingController emailCtrl;
  late TextEditingController passwordCtrl;

  @override
  void onInit() {
    super.onInit();
    formKey = GlobalKey();
    emailCtrl = TextEditingController();
    passwordCtrl = TextEditingController();
  }

  @override
  void onClose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    super.onClose();
  }

  void login() async {
    if (formKey.currentState!.validate()) {
      authenticating.value = true;

      // Get.off(const Home(), id: 0)
    } else {
      validateMode.value = AutovalidateMode.onUserInteraction;
    }
  }
}