import 'package:eazi_ride/src/config.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OTP extends StatelessWidget {
  final GlobalKey<FormState>? formKey;
  final TextEditingController? controller;
  final void Function(String)? onCompleted;

  const OTP({
    super.key,
    this.formKey,
    this.controller,
    this.onCompleted
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('OTP Verification', style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold
            )),
            const SizedBox(height: 12,),
            Text('Enter 5-digit verification code (12345) to continue.', style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500
            ),),
            const SizedBox(height: 40,),
            PinCodeTextField(
              controller: controller,
              appContext: context, 
              autoDisposeControllers: false,
              length: 5,
              keyboardType: TextInputType.number,
              cursorColor: colorBlack,
              mainAxisAlignment: MainAxisAlignment.center,
              pinTheme: const PinTheme.defaults(
                activeColor: colorPrimary,
                selectedColor: colorPrimary,
                inactiveColor: colorGrey
              ),
              separatorBuilder: (context, index) => const SizedBox(width: 16),
              onCompleted: onCompleted,
            ),
            const SizedBox(height: 40,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Didn\'t receive code? ', style: TextStyle(
                  color: colorGrey
                )),
                InkWell(
                  onTap: () {},
                  child: Text('Resend code'),
                )
              ],
            ),
          ],
        )
      )
    );
  }
} 