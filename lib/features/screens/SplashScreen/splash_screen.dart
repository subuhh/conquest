import 'package:conquest/features/BottomNavBar/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:page_transition/page_transition.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Delay for 3 seconds and then navigate to HomePage
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushAndRemoveUntil(
        context,
        PageTransition(
          type: PageTransitionType.fade,
          child: const BottomNavBar(),
        ),
        (route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logos/conquest-string-icon.png',
              height: 200,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.16,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
              child: const LoadingIndicator(
                indicatorType: Indicator.ballRotateChase,
                colors: [Colors.red, Colors.redAccent],
                strokeWidth: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
