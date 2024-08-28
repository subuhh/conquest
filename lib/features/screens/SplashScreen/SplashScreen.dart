import 'package:conquest/features/BottomNavBar/BottomNavBar.dart';
import 'package:conquest/features/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:page_transition/page_transition.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Delay for 3 seconds and then navigate to HomePage
    Future.delayed(Duration(seconds: 3), () {
      Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: BottomNavBar()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(

        child: Image.asset('assets/logos/conquest-string-icon.png',height: 200,),
      ),
    );
  }
}
