import 'package:conquest/common/widgets/RoundedContainer.dart';
import 'package:conquest/features/screens/MarketPlace/Products/OrderHIstory/helpSupportDialogBox.dart';
import 'package:conquest/features/utils/constants/enums.dart';
import 'package:conquest/features/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';



class OrderCard extends StatelessWidget {
  const OrderCard(
      {super.key, required this.OrderID, required this.ProductName, required this.ProductCharacterstic, required this.orderStatus});

  final OrderStatus orderStatus;
  final String OrderID;
  final String ProductName;
  final String ProductCharacterstic;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme
        .of(context)
        .textTheme;

    return RoundedContainer(
      backgroundColor: Colors.white,
      showBorder: true,
      borderColor: TColors.grey,
      //: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),

      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(getOrderStatusIcon(orderStatus), color: getStatusColor(orderStatus)),
                SizedBox(width: 8),
                Text(
                  getStatusText(orderStatus),
                  style: textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: getStatusColor(orderStatus),
                  ),
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('REORDER',
                    style: textTheme.bodySmall!.apply(color: Colors.white),),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: TColors.primary,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.all(10)
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              OrderID,
              style: textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
Divider(),
            Padding(
              padding: EdgeInsets.symmetric(vertical: TSizes.spaceBtwItems/2),
              child: Row(
                children: [
                  // Product Image
                  Image.network(
                    'https://apexsupplements.b-cdn.net/wp-content/uploads/2024/05/Muscleblaze-Creatine-Monohydrate-CreAMP-250gm-1.jpg',
                    width: 50,
                    height: 50,
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ProductName,
                        style: textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        ProductCharacterstic,
                        style: textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(),

            ///REview and rating button
            ///if review is give hide this widget
            Padding(
              padding: const EdgeInsets.symmetric(vertical: TSizes.spaceBtwItems/2),
              child: RoundedContainer(
                height: 50,
                showBorder: true,
                radius: 8,
                backgroundColor: TColors.grey.withOpacity(0.60),
                borderColor: TColors.darkerGrey.withOpacity(0.40),
                // decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(5),
                //     border: Border.all(width: 1, color: TColors.grey),
                //     color: TColors.lightGrey
                // ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Write a Review |',
                        style: textTheme.bodyMedium!.apply(color: Colors.indigo)),
                    Text('Rate Product', style: textTheme.bodyMedium),

                    Row(
                      children: [
                        for (var i = 0; i < 5; i++)
                          Icon(
                            Icons.star,
                            size: 20,
                            color: Colors.white,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Divider(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RoundedContainer(
                  radius: 5,
                  showBorder: true,
                  borderColor: Colors.grey,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text('View Full Detail',style: textTheme.labelLarge,),
                  ),
                ),
                GestureDetector(
                  onTap:()=> showContactSupportDialog(context),
                  child: RoundedContainer(
                    radius: 5,
                    showBorder: true,
                    borderColor: Colors.grey,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text('Need help?',style: textTheme.labelLarge,),
                    ),
                  ),
                ),
              ],
            )

          ],
        ),
      ),
    );
  }
}