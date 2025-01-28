import 'package:eazi_ride/src/components/button.dart';
import 'package:eazi_ride/src/components/input.dart';
import 'package:eazi_ride/src/components/loader.dart';
import 'package:eazi_ride/src/config.dart';
import 'package:eazi_ride/src/models/user.dart';
import 'package:eazi_ride/src/services/popup_manager.dart';
import 'package:eazi_ride/src/services/user.dart';
import 'package:eazi_ride/src/views/home.dart';
import 'package:eazi_ride/src/views/success.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'login.dart';

class Signup extends StatelessWidget {
  const Signup({super.key});

  @override
  Widget build(BuildContext context) {
    final SignupController controller = Get.put(SignupController());

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, kToolbarHeight + 24, 16, 16),
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  const Text('EaziRide', style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold
                  ), textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  Container(
                    // color: Colors.yellow,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Obx(() => Form(
                      key: controller.formKey,
                      autovalidateMode: controller.validateMode.value,
                      child: Column(
                        children: [
                          FormFieldBox(
                            child: Input(
                              controller: controller.nameCtrl,
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return 'Name cannot be empty';
                                } return null;
                              },
                              placeholder: 'Name',
                              prefixIcon: Icons.person_4_outlined,
                            )
                          ),
                          const SizedBox(height: 8),
                          FormFieldBox(
                            child: Input(
                              controller: controller.emailCtrl,
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return 'Email address cannot be empty';
                                }

                                if (!EmailValidator.validate(v)) {
                                  return 'Please enter a valid email address';
                                }

                                return null;
                              },
                              placeholder: 'Email address',
                              prefixIcon: Icons.alternate_email,
                            )
                          ),
                          const SizedBox(height: 8),
                          FormFieldBox(
                            child: Input(
                              controller: controller.phoneCtrl,
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return 'Phone number cannot be empty';
                                } 

                                if (v.length != 11 && v.length != 13) {
                                  return 'Invalid phone number';
                                }

                                return null;
                              },
                              placeholder: 'Phone number',
                              prefixIcon: Icons.phone_android_outlined,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              keyboardType: TextInputType.phone,
                            )
                          ),
                          const SizedBox(height: 8),
                          FormFieldBox(
                            child: Input(
                              controller: controller.passwordCtrl,
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return 'Password cannot be empty';
                                } return null;
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
                          const SizedBox(height: 8),
                          FormField<bool>(
                            builder: (state) {
                              return Container(
                                padding: state.errorText != null ? const EdgeInsets.symmetric(horizontal: 8) : null,
                                decoration: BoxDecoration(
                                  border: state.errorText != null
                                    ? Border.all(color: Colors.red)
                                    : null
                                ),
                                child: Row(
                                  children: [
                                    Checkbox(
                                      value: controller.acceptTerms.value, 
                                      onChanged: (v) {
                                        controller.acceptTerms.value = v ?? false;
                                        state.didChange(v);
                                      },
                                      checkColor: Colors.white,
                                      activeColor: colorPrimary,
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          controller.acceptTerms.toggle();
                                          state.didChange(controller.acceptTerms.value);
                                        },
                                        child: RichText(
                                          text: const TextSpan(
                                            style: TextStyle(color: colorGrey),
                                            children: [
                                              TextSpan(text: 'By continuing, I confirm I have read the '),
                                              TextSpan(
                                                text: 'Terms and Conditions ',
                                                style: TextStyle(color: colorBlack, fontWeight: FontWeight.w500)
                                              ),
                                              TextSpan(text: 'and '),
                                              TextSpan(
                                                text: 'Privacy Policy',
                                                style: TextStyle(color: colorBlack, fontWeight: FontWeight.w500)
                                              )
                                            ]
                                          )
                                        )
                                      )
                                    )
                                  ],
                                ),
                              );
                            },
                            validator: (v) {
                              if (!controller.acceptTerms.value) {
                                return 'You need to accept terms';
                              } return null;
                            },
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

                                controller.signup();
                              }, 
                              label: 'Sign Up',
                              //icon: Icons.arrow_circle_right
                            )
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Already have an account? ', style: TextStyle(
                                color: colorGrey
                              )),
                              InkWell(
                                onTap: () => Get.off(Login(), id: 0),
                                child: Text('Log In', style: TextStyle(
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
            if (controller.processing.value) {
              return const Loader();
            }

            return Container();
          })
        ],
      )
    );
  }
}

class SignupController extends GetxController {
  late GlobalKey<FormState> formKey;
  Rx<AutovalidateMode> validateMode = AutovalidateMode.disabled.obs;
  RxBool hidePassword = true.obs;
  RxBool processing = false.obs;
  RxBool acceptTerms = false.obs;

  late TextEditingController nameCtrl;
  late TextEditingController emailCtrl;
  late TextEditingController phoneCtrl;
  late TextEditingController passwordCtrl;

  late UserService userService;

  @override
  void onInit() {
    super.onInit();

    userService = Get.put(UserService());

    formKey = GlobalKey();
    nameCtrl = TextEditingController();
    emailCtrl = TextEditingController();
    phoneCtrl = TextEditingController();
    passwordCtrl = TextEditingController();
  }

  @override
  void onClose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    passwordCtrl.dispose();
    super.onClose();
  }

  void signup() async {
    if (formKey.currentState!.validate()) {
      processing.value = true;

      final User user = User(
        name: nameCtrl.text,
        email: emailCtrl.text,
        phone: phoneCtrl.text
      );

      await userService.signup(user);

      processing.value = false;

      Get.off(
        Success(
          message: 'Account created successfully',
          onContinue: () => Get.off(const Login(), id: 0),
        ),
        id: 0
      );
    } else {
      validateMode.value = AutovalidateMode.onUserInteraction;
    }
  }
}