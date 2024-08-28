import 'package:conquest/features/screens/SplashScreen/SplashScreen.dart';
import 'package:flutter/material.dart';
import 'features/BottomNavBar/BottomNavBar.dart';
import 'features/utils/theme/theme.dart';

void main() {
  //Todo: Add Widget BINDING
  //Todo: init local Storage
  //Todo: Await Native Splash
  //Todo: Initialize Firebase
  //Todo: Initialize Authentication
  runApp(
      MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.system,
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      home:  SplashScreen(),
    );
  }
}
