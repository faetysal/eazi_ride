import 'package:eazi_ride/src/components/button.dart';
import 'package:eazi_ride/src/components/input.dart';
import 'package:eazi_ride/src/components/loader.dart';
import 'package:eazi_ride/src/components/otp.dart';
import 'package:eazi_ride/src/config.dart';
import 'package:eazi_ride/src/services/popup_manager.dart';
import 'package:eazi_ride/src/services/user.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

import 'success.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final FPController controller = Get.put(FPController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
        centerTitle: true,
        elevation: 0,
        foregroundColor: colorBlack,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, kToolbarHeight + 24, 16, 16),
            child: SingleChildScrollView(
              child: Obx(() {
                if (controller.stage.value == FPStage.requestToken) {
                  return Obx(() => Form(
                    key: controller.stage0FormKey,
                    autovalidateMode: controller.stage0ValidateMode.value,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Forgot Password', style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold
                        )),
                        const SizedBox(height: 12,),
                        const Text('Enter your email address or phone number to reset your password', style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500
                        ),),
                        const SizedBox(height: 40,),
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
                            prefixIcon: Icons.alternate_email,
                            placeholder: 'Email address or phone number',
                          ),
                        ),
                        const SizedBox(height: 24,),
                        SizedBox(
                          height: 45,
                          width: double.infinity,
                          child: Button(
                            label: 'Continue',
                            onPressed: () => controller.requestToken(),
                          )
                        ),
                      ],
                    )
                  ));
                }

                if (controller.stage.value == FPStage.validateToken) {
                  return OTP(
                    formKey: controller.stage1FormKey,
                    controller: controller.tokenCtrl,
                    onCompleted: (code) => controller.validateToken(code),
                  );
                }

                if (controller.stage.value == FPStage.updatePassword) {
                  return Obx(() => Form(
                    key: controller.stage2FormKey,
                    autovalidateMode: controller.stage2ValidateMode.value,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('New Password', style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold
                        )),
                        const SizedBox(height: 12),
                        const Text('Create your new password', style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500
                        )),
                        const SizedBox(height: 40),
                        FormFieldBox(
                          child: Input(
                            controller: controller.passwd1Ctrl,
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return 'Password cannot be empty';
                              } return null;
                            },
                            prefixIcon: Icons.lock_outline,
                            placeholder: 'Password',
                            obscureText: controller.hidePassword.value,
                            suffixIcon: controller.hidePassword.value
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                            onSuffixIconTap: () => controller.hidePassword.toggle(),
                          ),
                        ),
                        const SizedBox(height: 24,),
                        FormFieldBox(
                          child: Input(
                            controller: controller.passwd2Ctrl,
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return 'Password cannot be empty';
                              } 

                              if (v != controller.passwd1Ctrl.text) {
                                return 'Passwords do not match';
                              }
                              
                              return null;
                            },
                            prefixIcon: Icons.lock_outline,
                            placeholder: 'Password',
                            obscureText: controller.hidePassword.value,
                            suffixIcon: controller.hidePassword.value
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                            onSuffixIconTap: () => controller.hidePassword.toggle(),
                          ),
                        ),
                        const SizedBox(height: 24,),
                        SizedBox(
                          height: 45,
                          width: double.infinity,
                          child: Button(
                            onPressed: () => controller.updatePassword(),
                            label: 'Save',
                          ),
                        )
                      ],
                    )
                  ));
                }

                if (controller.stage.value == FPStage.passwordUpdated) {
                  return SizedBox(
                    width: double.infinity, 
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Success(
                          message: 'Password updated successfully',
                          onContinue: () => Get.back(id: 0),
                        ),
                      ],
                    )
                  );
                }

                return Container();
              })
            )
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

class FPController extends GetxController {
  Rx<FPStage> stage = FPStage.requestToken.obs;
  RxBool processing = false.obs;
  late UserService userService;

  final stage0FormKey = GlobalKey<FormState>();
  Rx<AutovalidateMode> stage0ValidateMode = AutovalidateMode.disabled.obs;
  late TextEditingController emailCtrl;

  final stage1FormKey = GlobalKey<FormState>();
  AutovalidateMode stage1ValidateMode = AutovalidateMode.disabled;
  late TextEditingController tokenCtrl;

  final stage2FormKey = GlobalKey<FormState>();
  Rx<AutovalidateMode> stage2ValidateMode = AutovalidateMode.disabled.obs;
  late TextEditingController passwd1Ctrl;
  late TextEditingController passwd2Ctrl;
  RxBool hidePassword = true.obs;

  @override
  void onInit() {
    super.onInit();
    userService = Get.find();

    emailCtrl = TextEditingController();
    tokenCtrl = TextEditingController();
    passwd1Ctrl = TextEditingController();
    passwd2Ctrl = TextEditingController();
  }

  @override
  void onClose() {
    emailCtrl.dispose();
    tokenCtrl.dispose();
    passwd1Ctrl.dispose();
    passwd2Ctrl.dispose();
    super.onClose();
  }

  void requestToken() async {
    if (stage0FormKey.currentState!.validate()) {
      processing.value = true;

      final user = await userService.getUserByEmail(emailCtrl.text);
      if (user == null) {
        processing.value = false;
        PopupManager.error(title: 'Failed', message: 'Email address does not exist.');
        return;
      }

      processing.value = false;

      stage.value = FPStage.validateToken;
    } else {
      stage0ValidateMode.value = AutovalidateMode.onUserInteraction;
    }
  }

  void validateToken(String code) async {
    processing.value = true;
    await Future.delayed(const Duration(seconds: 1));

    if (code == '12345') {
      stage.value = FPStage.updatePassword;
    } else {
      PopupManager.error(title: 'Verification Failed', message: 'Invalid verification code');
    }

    processing.value = false;
  }

  void updatePassword() async {
    if (stage2FormKey.currentState!.validate()) {
      processing.value = true;
      final result = await userService.updatePassword(
        email: emailCtrl.text, 
        password: passwd1Ctrl.text
      );

      if (result == 0) {
        processing.value = false;
        PopupManager.error(message: 'Unable to update password');
        return;
      }

      processing.value = false;

      stage.value = FPStage.passwordUpdated;
    } else {
      stage2ValidateMode.value = AutovalidateMode.onUserInteraction;
    }
  }
}

enum FPStage {
  requestToken,
  validateToken,
  updatePassword,
  passwordUpdated
}