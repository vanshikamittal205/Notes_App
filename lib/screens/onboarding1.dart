import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../widgets/buttons/bottomButton.dart';

class Onboarding1 extends StatelessWidget {
  const Onboarding1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Lottie.asset('assets/onboarding1.json', height: 250), // Replace with your image
            const SizedBox(height: 30),
            const Text(
              "Plan your everyday tasks",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                "Effortlessly organize your daily life and stay on top of tasks",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 18),
              ),
            ),
            const Spacer(),
            BottomButton(
              text: 'Next',
              onPressed: () => Navigator.pushNamed(context, '/onboarding2'),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
