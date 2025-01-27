import 'package:eazi_ride/src/components/button.dart';
import 'package:eazi_ride/src/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'login.dart';

class Onboarding extends StatelessWidget {
  const Onboarding({super.key});

  @override
  Widget build(BuildContext context) {
    OnboardingController controller = Get.put(OnboardingController());
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * .8,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 40,
                        child: Obx(() {
                          if (controller.activePageIdx.value < 2) {
                            return Align(
                              alignment: Alignment.centerRight,
                              child: TextButton.icon(
                                iconAlignment: IconAlignment.end,
                                onPressed: () {
                                  GetStorage().write('firstLaunch', false);
                                  Get.off(Login(), id: 0);
                                },
                                icon: Icon(Icons.arrow_forward, color: Colors.black,),
                                label: Text('Skip', style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black
                                )),
                                /*child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(width: 4,),
                                    Icon(Icons.keyboard_double_arrow_right_rounded, color: Colors.black,)
                                  ],
                                )*/
                              )
                            );
                          }

                          return Container();
                        })
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .7,
                        child: GestureDetector(
                          onHorizontalDragEnd: (details) {
                            if (details.velocity.pixelsPerSecond.dx < 1) {
                              // right
                              final idx = controller.imageCtrl.page;
                              if (idx! < 2) {
                                _jumpToPage(idx.toInt() + 1);
                              }
                            } else {
                              // left
                              final idx = controller.imageCtrl.page;
                              if (idx! > 0) {
                                _jumpToPage(idx.toInt() - 1);
                              }
                            }
                          },
                          child: Column(
                            children: [
                              Expanded(
                                flex: 3,
                                child: PageView(
                                  physics: const NeverScrollableScrollPhysics(),
                                  controller: controller.imageCtrl,
                                  onPageChanged: (index) {
                                    controller.activePageIdx.value = index;
                                  },
                                  children: [
                                    _buildOnboardingImage('assets/svg/onboard1.svg'),
                                    _buildOnboardingImage('assets/svg/onboard2.svg'),
                                    _buildOnboardingImage('assets/svg/onboard3.svg')
                                  ],
                                )
                              ),
                              // const SizedBox(height: 25),
                              Container(
                                height: 70, 
                                decoration: BoxDecoration(
                                  // border: Border.all(color: Colors.brown)
                                ),
                                child: Obx(() => AnimatedSmoothIndicator(
                                  activeIndex: controller.activePageIdx.value,
                                  count: 3,
                                  effect: const ExpandingDotsEffect(
                                    activeDotColor: colorPrimary,
                                    dotColor: Color(0xFFD0D0D0),
                                    dotWidth: 26,
                                    dotHeight: 8
                                  ),
                                  onDotClicked: (idx) => _jumpToPage(idx),
                                )),
                              ),
                              SizedBox(
                                height: 130,
                                child: PageView(
                                  physics: const NeverScrollableScrollPhysics(),
                                  controller: controller.contentCtrl,
                                  onPageChanged: (index) {
                                    controller.activePageIdx.value = index;
                                  },
                                  children: [
                                    _buildOnboardingCaption(
                                      title: 'Ride Easy',
                                      subtitle: 'Book rides with a tap. Easy, comfortable and reliable.'
                                    ),
                                    _buildOnboardingCaption(
                                      title: 'Your Schedule, Your Ride',
                                      subtitle: 'Schedule your ride in advance for stress-free travel.'
                                    ),
                                    _buildOnboardingCaption(
                                      title: 'Safe and Secure',
                                      subtitle: 'Peace of mind with every ride. Trusted drivers, secure payments.'
                                    ),
                                  ],
                                )
                              )
                            ],
                          )
                        )
                      ),
                    ],
                  )
                )
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(bottom: 16),
                  alignment: Alignment.topCenter,
                  child: Obx(() {
                    if (controller.activePageIdx.value < 2) {
                      return SizedBox(
                        width: double.infinity, 
                        height: 50,
                        child: Button(
                          onPressed: () {
                            final idx = controller.imageCtrl.page;
                            if (idx! < 2) {
                              _jumpToPage(idx.toInt() + 1);
                            }
                          },
                          label: 'Next'
                        )
                      );
                    }

                    return SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: Button(
                        onPressed: () {
                          GetStorage().write('firstLaunch', false);
                          Get.off(Login(), id: 0);
                        },
                        label: 'Login'
                      )
                    );
                  }),
                )
              )
            ],
          )
        ),
      )
    );
  }

  Widget _buildOnboardingImage(String path) {
    return SizedBox(
      child: SvgPicture.asset(
        path,
        // fit: BoxFit.cover,
      )
    );
  }

  Widget _buildOnboardingCaption({String? title, String? subtitle}) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 38),
          child: Text(
            title ?? '', 
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: colorBlack
            ),
            textAlign: TextAlign.center,
          )
        ),
        const SizedBox(height: 8,),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            subtitle ?? '', 
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: colorGrey
            ),
            textAlign: TextAlign.center,
          )
        )
      ],
    );
  }

  void _jumpToPage(int idx) {
    OnboardingController controller = Get.find();

    controller.imageCtrl.animateToPage(
      idx,
      duration: const Duration(milliseconds: 150), 
      curve: Curves.linear
    );
    controller.contentCtrl.animateToPage(
      idx,
      duration: const Duration(milliseconds: 150), 
      curve: Curves.linear
    );
  }
}

class OnboardingController extends GetxController {
  late PageController imageCtrl;
  late PageController contentCtrl;
  RxInt activePageIdx = 0.obs;

  @override
  void onInit() {
    super.onInit();
    imageCtrl = PageController();
    contentCtrl = PageController();
  }

  @override
  void onClose() {
    imageCtrl.dispose();
    contentCtrl.dispose();
    super.onClose();
  }
}