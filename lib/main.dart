import 'package:conquest/features/screens/Drawer/drawer_screen.dart';
import 'package:conquest/features/screens/Drawer/drawer_section_screen/profile/profile_screen.dart';
import 'package:conquest/features/screens/HomePage/homepage.dart';
import 'package:conquest/features/screens/Cart/Screen/cart_screen.dart';
import 'package:conquest/features/screens/SplashScreen/splash_screen.dart';
import 'package:conquest/features/screens/MarketPlace/Products/Products_screen/product_detail.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/services/auth_service.dart';
import 'features/BottomNavBar/bottom_nav_bar.dart';
import 'features/utils/theme/theme.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
      ],
      child: const MyApp(),
    ),
  );
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
      home: const SplashScreen(),
      initialRoute: '/',
      routes: {
        '/homepage': (context) => const homepage(),
        '/drawer': (context) => const DrawerScreen(),
        '/btmnav': (context) => const BottomNavBar(),
        '/productDetails': (context) => const ProductDetail(),
        '/profileScreen': (context) => const ProfilePage(),
        '/cart': (context) => const CartScreen(),
      },
    );
  }
}
