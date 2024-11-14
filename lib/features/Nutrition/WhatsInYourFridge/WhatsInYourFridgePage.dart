import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';

class WhatsInYourFridgePage extends StatelessWidget {
  const WhatsInYourFridgePage({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            child: Icon(Icons.arrow_back),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          height: 400,
                          padding: EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: TColors.softGrey,
                                ),
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Search...',
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(color: Colors.grey),
                                  ),
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                  onChanged: (value) {},
                                ),
                              ),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Roti",
                                    style:
                                        Theme.of(context).textTheme.bodyMedium!,
                                  ),
                                  Icon(
                                    Icons.add,
                                    weight: 1000,
                                    color: Colors.white,
                                  )
                                ],
                              )
                            ],
                          ),
                        );
                      });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Add Ingredients",
                      style: textTheme.headlineMedium,
                    ),
                    CircleAvatar(
                        backgroundColor: TColors.primary,
                        radius: 20,
                        child: Icon(
                          Icons.add,
                          weight: 1000,
                          color: Colors.white,
                        ))
                  ],
                ),
              ),
              SizedBox(height: TSizes.spaceBtwItems),
              Container(
                height: 400,
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: TColors.softGrey,
                  borderRadius: BorderRadius.circular(45),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/nutrition/Bread.svg',
                      colorFilter:
                          ColorFilter.mode(Colors.grey, BlendMode.srcIn),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(TSizes.spaceBtwItems),
                      child: Text(
                        "Search And Add some available Ingredients in your Fridge to Generate a Healthy Meal ",
                        textAlign: TextAlign.center,
                        style: textTheme.titleSmall!.apply(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () {},
          child: Text("Generate Meal"),
        ),
      ),
    );
  }
}
