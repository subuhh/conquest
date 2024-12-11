import 'package:conquest/bindings/general_bindings.dart';
import 'package:conquest/features/Drawer/drawer_screen.dart';
import 'package:conquest/features/SplashScreen/splash_screen.dart';
import 'package:conquest/utils/theme/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'core/services/auth_service.dart';
import 'features/BottomNavBar/bottom_nav_bar.dart';
import 'features/HomePage/homepage.dart';
import 'features/MarketPlace/Cart/cart_screen.dart';
import 'features/Profile/profile_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env'); // Loads environment variables
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
    statusBarBrightness: Brightness.dark, // For iOS (dark icons)
  ));

  // Initialize GetX dependencies here
  Get.put(AuthService()); // Inject AuthService as a GetX controller
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      themeMode: ThemeMode.light,
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      initialBinding: GeneralBindings(),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const SplashScreen()),
        GetPage(name: '/homepage', page: () => const HomePage()),
        GetPage(name: '/drawer', page: () => DrawerScreen()),
        GetPage(name: '/btmnav', page: () => const BottomNavBar()),
        GetPage(name: '/profileScreen', page: () => const ProfilePage()),
        GetPage(name: '/cart', page: () => const CartScreen()),
      ],
    );
  }
}
