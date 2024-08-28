import 'package:conquest/features/screens/Drawer/drawer_screen.dart';
import 'package:conquest/features/screens/HomePage/homepage.dart';
import 'package:conquest/features/screens/SplashScreen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'features/utils/theme/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.light,
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      home:  const SplashScreen(),
      initialRoute: '/',
      routes: {
        '/homepage': (context) => const Homepage(),
        '/drawer': (context) => const DrawerScreen(),
      },
    );
  }
}
