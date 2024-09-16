import 'package:conquest/features/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../common/widgets/RoundedContainer.dart';
import '../../../../common/widgets/product_price_text.dart';
import '../../../utils/constants/colors.dart';

class CartItem extends StatefulWidget {
  final String title;
  final String color;
  final double orignalPrice;
  final double dicountedPrice;
  String? imageUrl = 'https://cdn.shopify.com/s/files/1/0070/7032/files/product-label-design.jpg?v=1680902906';
  int quantity;

  CartItem({
    Key? key,
    required this.title,
    required this.color,
    required this.orignalPrice,
    required this.dicountedPrice,
    this.imageUrl,
    this.quantity = 1, // Default quantity set to 1
  }) : super(key: key);

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  @override
  Widget build(BuildContext context) {
    // Access the defined text theme
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: TSizes.spaceBtwItems/3),
      child: Card(
        elevation: 0.25,
        color: Colors.white,
        margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 16.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Image.network(
                        'https://cdn.shopify.com/s/files/1/0070/7032/files/product-label-design.jpg?v=1680902906',
                        height: 100,
                        width: 80,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(height: TSizes.spaceBtwItems,),


                    ],
                  ),

                  const SizedBox(width: 16.0),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.title, style: textTheme.titleMedium),
                      Text('Color: ${widget.color}', style: textTheme.bodyMedium?.copyWith(color: Colors.grey)),
                      SizedBox(height: TSizes.spaceBtwItems/1.5,),


                      /// Price
                      buildPriceText(widget: widget),
                      //Text('₹${widget.price*widget.quantity}', style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      buildDiscountRibbon(widget: widget),
                      SizedBox(height: TSizes.spaceBtwItems/1.5,),


                    ],

                  ),
                  Spacer(),
                  IconButton(onPressed: (){
                    //Remove From List
                  },icon: SvgPicture.asset('assets/icons/drawerIcons/delete.svg',color:Colors.grey,)),

                ],
              ),
              Divider(height: 2,color: TColors.grey,),
              SizedBox(height: TSizes.spaceBtwItems,),
              Row(
                children: [
                  ///Quantity Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Container(
                        decoration: BoxDecoration(
                          color: TColors.primary,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(8.0),
                            bottomLeft: Radius.circular(8.0),
                          ),
                          border: Border.all(
                            color: TColors.primary,
                            width: 1.0,
                          ),
                        ),
                        width: 30,
                        height: 25,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(
                            Iconsax.minus,
                            color: TColors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              if (widget.quantity > 1) {
                                widget.quantity--;
                              }
                            });
                          },
                        ),
                      ),

                      // Quantity box
                      Container(
                        width: 30,
                        height: 25,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: TColors.white,
                          border: Border.symmetric(
                            horizontal: BorderSide(
                              color: TColors.grey,
                              width: 1.0,
                            ),
                          ),
                        ),
                        child: Text(
                          '${widget.quantity}', // Quantity number
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),

                      // Plus button
                      Container(
                        decoration: BoxDecoration(
                          color: TColors.primary,
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(8.0),
                            bottomRight: Radius.circular(8.0),
                          ),
                          border: Border.all(
                            color: TColors.primary,
                            width: 1.0,
                          ),
                        ),
                        width: 30,
                        height: 25,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(
                            Iconsax.add,
                            color: TColors.
                            white,
                          ),
                          onPressed: () {
                            // Handle plus button
                            setState(() {
                              if (widget.quantity < 6) {
                                widget.quantity++;
                              }
                            });
                          },
                        ),
                      )
                    ],
                  ),
                  Expanded(child: GestureDetector(
                      onTap: (){
                        //Remove From Cart
                        //Move to WishList
                      },
                      child: buildMoveToWhishList()))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
class buildMoveToWhishList extends StatefulWidget {
  const buildMoveToWhishList({super.key});

  @override
  State<buildMoveToWhishList> createState() => _buildMoveToWhishListState();
}

class _buildMoveToWhishListState extends State<buildMoveToWhishList> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TSizes.spaceBtwItems),
      child: Container(
        height: 30,
       decoration: BoxDecoration(
         border: Border.all(color: TColors.grey,width: 1.5),
         borderRadius: BorderRadius.circular(5)
         
       ),
        child: Center(child: Text('Move To WishList',style: Theme.of(context).textTheme.bodyMedium,)),
      ),
    );
  }
}


class buildDiscountRibbon extends StatelessWidget {
  const buildDiscountRibbon({
    super.key,
    required this.widget,
  });

  final CartItem widget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: RoundedContainer(
        radius: TSizes.sm,
        backgroundColor: Colors.green,
        padding: const EdgeInsets.symmetric(
          horizontal: TSizes.sm,
          vertical: TSizes.xs,
        ),
        child: Text(
          '${((widget.orignalPrice-widget.dicountedPrice)/widget.orignalPrice * 100).toInt()}% OFF',
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .apply(color: TColors.white),
        ),
      ),
    );
  }
}

class buildPriceText extends StatelessWidget {
  const buildPriceText({
    super.key,
    required this.widget,
  });

  final CartItem widget;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        RichText(
          text: TextSpan(
            text: 'MRP ',
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontWeight: FontWeight.w400)
                .apply(
              decoration: TextDecoration.lineThrough,
            ),

            children: [
              TextSpan(
                text: '₹${widget.orignalPrice*widget.quantity}',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.w400)
                    .apply(
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        // New Price Tag
        ProductPriceText(
          price: '${widget.dicountedPrice*widget.quantity}',
        ),


        // Old Price

        const SizedBox(width: TSizes.spaceBtwItems),
        // Discounted Container

      ],
    );
  }
}
