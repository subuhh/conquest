import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/Controllers/Form_Controller/FormController.dart';
import '../../core/Controllers/Onboarding_Controller/OnboardingController.dart';
import '../../utils/constants/sizes.dart';
import 'Widgets/BottomNavigationButtons.dart';
import 'Widgets/PageIndicator.dart';
import 'Widgets/Pageview.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  // Ensure the controller is initialized in initState
  OnboardingController? controller;
  final FormController formController = Get.put(FormController());

  @override
  void initState() {
    super.initState();
    controller = OnboardingController(); // Initialize the controller here
  }

  @override
  void dispose() {
    controller?.dispose(); // Dispose the controller when not needed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Ensure controller is not null before accessing
    if (controller == null) {
      return Container();
    }

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: controller!.pageController,
              // Use the controller safely
              onPageChanged: (index) {
                controller!.onPageChanged(index, (int page) {
                  setState(() {});
                });
              },
              children: [
                buildPage(
                    image: 'assets/images/AnimeComunity.png',
                    title: 'Welcome',
                    description: 'Welcome to our app. Let\'s get started!',
                    height: 400),
                buildPage(
                    image: 'assets/images/AnimeWorkout1.png',
                    title: 'Stay Connected',
                    description: 'Stay connected with your loved ones.',
                    height: 300),
                buildPage(
                    image: 'assets/images/AnimeDietRecomendation.png',
                    title: 'Get Best Diet \nRecomendations',
                    description: '',
                    height: 300),
              ],
            ),
          ),
          buildPageIndicator(controller),
          SizedBox(
            height: TSizes.spaceBtwSections,
          ),
        ],
      ),
      bottomNavigationBar: buildBottomNavigationBarButtons(context),
    );
  }
}
