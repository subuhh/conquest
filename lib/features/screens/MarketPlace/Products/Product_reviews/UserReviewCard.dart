import 'package:conquest/features/screens/MarketPlace/Products/Product_reviews/RatingBarIndicator.dart';
import 'package:conquest/features/screens/MarketPlace/Products/Product_reviews/rating_progress_indicator.dart';
import 'package:conquest/features/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:readmore/readmore.dart';

import '../../../../utils/constants/sizes.dart';

class UserReviewCard extends StatelessWidget {
  const UserReviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage('https://d38b044pevnwc9.cloudfront.net/cutout-nuxt/passport/1-change1.jpg'),
                ),
                const SizedBox(width: TSizes.spaceBtwItems,),
                Text('John Doe',style: Theme.of(context).textTheme.titleLarge,),
              ],
            ),
            IconButton(onPressed: (){}, icon: const Icon(Icons.more_vert)),
             ],
        ),
       // const SizedBox(height: TSizes.spaceBtwItems,),

        ///Review
        Row(children: [
          TRatingBarIndicator(rating: 4),
          const SizedBox(width: TSizes.spaceBtwItems,),
          Text('01 Nov, 2023',style: Theme.of(context).textTheme.bodyMedium,),
        ],),
        const SizedBox(height: TSizes.spaceBtwItems,),
        ReadMoreText('The User interface of the app is  quite intvitive, I was able to navigate and make purchases seamlessly, Great job',
        trimLines: 2,
          trimMode: TrimMode.Line,
          trimExpandedText: ' Show Less',
          trimCollapsedText: ' Show More',
          moreStyle: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: TColors.primary),
          lessStyle: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: TColors.primary),

        ),

      ],
    );
  }
}
