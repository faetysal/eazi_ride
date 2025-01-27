import 'package:eazi_ride/src/components/button.dart';
import 'package:eazi_ride/src/components/input.dart';
import 'package:eazi_ride/src/config.dart';
import 'package:eazi_ride/src/views/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'login.dart';

class Signup extends StatelessWidget {
  const Signup({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, kToolbarHeight + 24, 16, 16),
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Text('EaziRide', style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold
              ), textAlign: TextAlign.center),
              const SizedBox(height: 16),
              Container(
                // color: Colors.yellow,
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Form(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 50,
                        child: Input(
                          placeholder: 'Name',
                          prefixIcon: Icons.person_4_outlined,
                        )
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 50,
                        child: Input(
                          placeholder: 'Email address',
                          prefixIcon: Icons.email_outlined,
                        )
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 50,
                        child: Input(
                          placeholder: 'Phone number',
                          prefixIcon: Icons.phone_android_outlined,
                        )
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 50,
                        child: Input(
                          placeholder: 'Enter password',
                          obscureText: true,
                          prefixIcon: Icons.lock_outline,
                          suffixIcon: Icons.visibility_off,
                          onSuffixIconTap: () => print('Toggle password'),
                        )
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Checkbox(
                            value: true, 
                            onChanged: (v) {}
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text('By continuing, I confirm I have read the Terms and Conditions and Privacy Policy.')
                          )
                        ],
                      ),
                      const SizedBox(height: 24),
                    
                      SizedBox(
                        height: 48,
                        width: double.infinity,
                        child: Button(
                          onPressed: () => Get.off(const Home(), id: 0), 
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
                )
              )
            ],
          )
        ),
      )
    );
  }
}