import 'package:conquest/core/Controllers/Form_Controller/FormControllr.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/sizes.dart';

class FormScreen extends StatelessWidget {
  // Controller initialized using GetX
  final FormController controller = Get.put(FormController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColors.softGrey, // Background color
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Back button
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    controller.previousQuestion();
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Animated Picture (Transition)
              Obx(() => AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder:
                    (Widget child, Animation<double> animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child: Image.asset(
                  controller.currentPicture,
                  key: ValueKey<String>(controller.currentPicture),
                  height: 200,
                ),
              )),

              const SizedBox(height: TSizes.spaceBtwSections),

              // Animated Question Text
              Obx(() => AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder:
                    (Widget child, Animation<double> animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child: Text(
                  controller.currentQuestion,
                  key: ValueKey<String>(controller.currentQuestion),
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall!
                      .apply(fontSizeFactor: 0.75),
                ),
              )),

              const SizedBox(height: TSizes.spaceBtwItems),

              // Progress Indicator
              Obx(() => TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 500),
                tween: Tween<double>(begin: 0, end: controller.progress),
                builder: (context, value, child) => SizedBox(
                  width: 150,
                  child: LinearProgressIndicator(
                    value: value,
                    color: TColors.primary,
                    backgroundColor: Colors.grey[300],
                  ),
                ),
              )),

              const SizedBox(height: TSizes.spaceBtwSections * 1.5),

              // Dynamic Widget (based on current question)
              Obx(() => AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder:
                    (Widget child, Animation<double> animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child: controller.currentWidget,
              )),
            ],
          ),
        ),
      ),
      // floatingActionButton: Obx(() => Visibility(
      //   visible: controller.currentQuestionIndex.value <
      //       controller.questions.length - 1,
      //   child: FloatingActionButton(
      //     onPressed: () {
      //       controller.nextQuestion();
      //     },
      //     child: const Icon(Icons.arrow_forward),
      //   ),
      // )),
    );
  }
}
