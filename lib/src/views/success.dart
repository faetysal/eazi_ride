import 'package:eazi_ride/src/components/button.dart';
import 'package:eazi_ride/src/config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

class Success extends StatelessWidget {
  final String? message;
  final Function()? onContinue;

  const Success({super.key, required this.message, this.onContinue});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              HugeIcons.strokeRoundedCheckmarkBadge01,
              color: colorPrimary,
              size: 120
            ),
            const SizedBox(height: 24,),
            if (message != null)
            Text(message!, style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold
            ), textAlign: TextAlign.center,),
            const SizedBox(height: 40),
            SizedBox(
              height: 45,
              width: double.infinity,
              child: Button(
                onPressed: onContinue,
                label: 'Login',
              ),
            )
          ],
        )
      )
    );
  }
}