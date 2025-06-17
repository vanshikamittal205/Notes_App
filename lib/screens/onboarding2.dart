import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../widgets/buttons/bottomButton.dart';

class Onboarding2 extends StatelessWidget {
  const Onboarding2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Lottie.asset('assets/onboarding2.json', height: 250), // Replace with your image
            const SizedBox(height: 30),
            const Text(
              "Capture & Organize notes in a seamless way",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                "Streamline your productivity by capturing and organizing your ideas into notes",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 18),
              ),
            ),
            const Spacer(),

            BottomButton(
              text: 'Get Started',
              onPressed: () => Navigator.pushNamed(context, '/login'),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
