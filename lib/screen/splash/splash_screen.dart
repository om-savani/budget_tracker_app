import 'dart:async';
import 'dart:math';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<Offset> offsetAnimation;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInOut,
      ),
    );

    animationController.forward();

    Timer(const Duration(seconds: 3), () {
      Get.offNamed('/home');
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Centered content with animations
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SlideTransition(
                  position: offsetAnimation,
                  child: Image.asset(
                    'assets/images/background/splash_icon.png',
                    width: 150, // Adjust size as needed
                  ),
                ),
                const SizedBox(height: 20),
                AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                      'ExpenseX.',
                      textStyle: const TextStyle(
                        fontFamily: 'Bruno Ace SC',
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      speed: const Duration(milliseconds: 140),
                    ),
                  ],
                  isRepeatingAnimation: false,
                ),
              ],
            ),
          ),
          // Align(
          //   alignment: const Alignment(588.91, -1.94),
          //   child: Transform.rotate(
          //     angle: -127.86 * (pi / 180),
          //     child: Image.asset(
          //       'assets/images/background/img.png',
          //       fit: BoxFit.cover,
          //     ),
          //   ),
          // ),

          // Align(
          //   alignment: const Alignment(-181.74, 912.73),
          //   child: Transform.rotate(
          //     angle: 68.68 * (pi / 180),
          //     child: Image.asset(
          //       'assets/images/background/img.png',
          //       fit: BoxFit.cover,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
