import 'package:eazi_ride/src/components/button.dart';
import 'package:eazi_ride/src/components/input.dart';
import 'package:eazi_ride/src/components/otp.dart';
import 'package:eazi_ride/src/config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final FPController controller = Get.put(FPController());

    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
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
                  return Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Forgot Password', style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold
                        )),
                        const SizedBox(height: 12,),
                        Text('Enter your email address or phone number to reset your password', style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500
                        ),),
                        const SizedBox(height: 40,),
                        Input(
                          prefixIcon: HugeIcons.strokeRoundedAt,
                          placeholder: 'Email address or phone number',
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
                  );
                }

                if (controller.stage.value == FPStage.validateToken) {
                  return OTP(
                    formKey: controller.stage1FormKey,
                    controller: controller.tokenCtrl,
                    onCompleted: (code) => controller.validateToken(),
                  );
                }

                if (controller.stage.value == FPStage.updatePassword) {
                  return Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('New Password', style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold
                        )),
                        const SizedBox(height: 12),
                        Text('Create your new password', style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500
                        )),
                        const SizedBox(height: 40),
                        Input(
                          prefixIcon: HugeIcons.strokeRoundedLockPassword,
                          placeholder: 'Password',
                        ),
                        const SizedBox(height: 24,),
                        Input(
                          prefixIcon: HugeIcons.strokeRoundedLockPassword,
                          placeholder: 'Confirm Password',
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
                  );
                }

                if (controller.stage.value == FPStage.passwordUpdated) {
                  return Container(width: double.infinity, child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        HugeIcons.strokeRoundedCheckmarkBadge01,
                        color: colorPrimary,
                        size: 120
                      ),
                      const SizedBox(height: 24,),
                      Text('Password updated successfully', style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold
                      ), textAlign: TextAlign.center,),
                      const SizedBox(height: 40),
                      SizedBox(
                        height: 45,
                        width: double.infinity,
                        child: Button(
                          onPressed: () => Get.back(id: 0),
                          label: 'Login',
                        ),
                      )
                    ],
                  ));
                }

                return Container();
              })
            )
          ),
          Obx(() {
            if (controller.processing.value) {
              return Container(
                color: Colors.white.withOpacity(.3),
                child: Center(
                  child: CircularProgressIndicator.adaptive(
                    valueColor: AlwaysStoppedAnimation(colorPrimary),
                  ),
                ),
              );
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

  late GlobalKey<FormState> stage0FormKey;
  late GlobalKey<FormState> stage1FormKey;
  late GlobalKey<FormState> stage2FormKey;
  late TextEditingController tokenCtrl;

  @override
  void onInit() {
    super.onInit();
    stage0FormKey = GlobalKey<FormState>();

    stage1FormKey = GlobalKey<FormState>();
    tokenCtrl = TextEditingController();

    stage2FormKey = GlobalKey<FormState>();

  }

  void requestToken() async {
    processing.value = true;
    await Future.delayed(const Duration(seconds: 2));
    processing.value = false;

    stage.value = FPStage.validateToken;
  }

  void validateToken() async {
    processing.value = true;
    await Future.delayed(const Duration(seconds: 2));
    processing.value = false;

    stage.value = FPStage.updatePassword;
  }

  void updatePassword() async {
    processing.value = true;
    await Future.delayed(const Duration(seconds: 2));
    processing.value = false;

    stage.value = FPStage.passwordUpdated;
  }
}

enum FPStage {
  requestToken,
  validateToken,
  updatePassword,
  passwordUpdated
}