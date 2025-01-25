import 'package:eazi_ride/src/components/button.dart';
import 'package:eazi_ride/src/components/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.red)),
          padding: const EdgeInsets.fromLTRB(16, kToolbarHeight + 24, 16, 16),
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('EaziRide', style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold
              ), textAlign: TextAlign.center),
              const SizedBox(height: 16),
              Container(
                height: 270,
                // color: Colors.red,
                child: SvgPicture.asset('assets/svg/login.svg', fit: BoxFit.cover,)
              ),
              const SizedBox(height: 16,),
              Container(
                // color: Colors.yellow,
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Form(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 50,
                        child: Input(
                          placeholder: 'Email address',
                          prefixIcon: Icons.person_4_outlined,
                        )
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 50,
                        child: Input(
                          placeholder: 'Enter password',
                          obscureText: true,
                          prefixIcon: Icons.key,
                          suffixIcon: Icons.visibility_off,
                          onSuffixIconTap: () => print('Toggle password'),
                        )
                      ),
                      const SizedBox(height: 4,),
                      Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: () {},
                          child: Text('Forgot Password?')
                        )
                      ),
                      const SizedBox(height: 24),
                      const SizedBox(
                        height: 48,
                        width: double.infinity,
                        child: Button(
                          // onPressed: () {}, 
                          label: 'Login',
                          //icon: Icons.arrow_circle_right
                        )
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