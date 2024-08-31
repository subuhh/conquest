import 'package:conquest/features/screens/Drawer/drawer_screen.dart';
import 'package:conquest/features/screens/HomePage/homepage.dart';
import 'package:conquest/features/screens/SplashScreen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'features/BottomNavBar/bottom_nav_bar.dart';
import 'features/utils/theme/theme.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
        '/btmnav': (context) => const BottomNavBar(),
      },
    );
  }
}
