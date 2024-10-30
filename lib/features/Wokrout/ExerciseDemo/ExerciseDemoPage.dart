import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import 'Widgets/PlayControlButtons.dart';


class Exercisedemopage extends StatelessWidget {
  const Exercisedemopage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: PlayControlButtons(),
      ),
      body: SafeArea(child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Stack(
          children: [
            Positioned(
              top: 5,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: LinearProgressIndicator(minHeight: 10,value: 0.5,color: TColors.primary,borderRadius: BorderRadius.circular(5),),
                  ),

                  /// Timer
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Icon(Icons.highlight_remove,size: 30,),
                      SizedBox(width: TSizes.spaceBtwItems,),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('00:25',style: Theme.of(context).textTheme.headlineLarge,),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: '1',
                                  style: Theme.of(context).textTheme.headlineMedium,
                                ),
                                TextSpan(
                                  text: '/18',
                                  style: Theme.of(context).textTheme.headlineMedium!.apply(color: Colors.grey,),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                  ],),


                ],
              ),
            ),
            Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '1',
                        style: Theme.of(context).textTheme.headlineLarge!.copyWith(fontSize: 45),
                      ),
                      TextSpan(
                        text: '/10 reps',
                        style: Theme.of(context).textTheme.headlineLarge
                      ),
                    ],
                  ),
                ),
                
                Text("Shoulder Joint Rotations",style: Theme.of(context).textTheme.titleLarge!.apply(color: Colors.grey),)

              ],
            )),
            Center(
                child: Image.asset('assets/TempImages/KmKW.gif')
            ),
          ],
        ),
      )),
    );
  }
}
