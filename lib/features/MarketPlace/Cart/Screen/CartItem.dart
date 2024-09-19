import 'package:conquest/core/model/cart_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../common/widgets/RoundedContainer.dart';
import '../../../../common/widgets/product_price_text.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/theme/customthemes/textThemes.dart';

class CartItem extends StatelessWidget {
  CartItem({
    Key? key,
    required this.cartItem,
  }) : super(key: key);

  final CartItemModel cartItem;

  @override
  Widget build(BuildContext context) {
    // Access the defined text theme

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: TSizes.spaceBtwItems / 3),
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
                        cartItem.image!,
                        height: 100,
                        width: 80,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(height: TSizes.spaceBtwItems),
                    ],
                  ),
                  const SizedBox(width: 16.0),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(cartItem.title,
                          style: TTextTheme.lightTextTheme.titleMedium),

                      /// Price
                      Row(
                        children: [
                          RichText(
                            text: TextSpan(
                              text: 'MRP ',
                              style: TTextTheme.lightTextTheme.titleLarge!
                                  .copyWith(fontWeight: FontWeight.w400)
                                  .apply(
                                    decoration: TextDecoration.lineThrough,
                                  ),
                              children: [
                                TextSpan(
                                  text: '₹${cartItem.price}',
                                  style: TTextTheme.lightTextTheme.titleLarge!
                                      .copyWith(fontWeight: FontWeight.w400)
                                      .apply(
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 5),
                          // New Price Tag
                          ProductPriceText(price: '₹${cartItem.price}'),

                          // Old Price

                          const SizedBox(width: TSizes.spaceBtwItems),
                          // Discounted Container
                        ],
                      ),
                      //Text('₹${widget.price*widget.quantity}', style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: RoundedContainer(
                          radius: TSizes.sm,
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(
                            horizontal: TSizes.sm,
                            vertical: TSizes.xs,
                          ),
                          child: Text(
                            '₹${cartItem.price}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .apply(color: TColors.white),
                          ),
                        ),
                      ),
                      SizedBox(height: TSizes.spaceBtwItems / 1.5),
                    ],
                  ),
                  Spacer(),
                  IconButton(
                      onPressed: () {
                        //Remove From List
                      },
                      icon: SvgPicture.asset(
                        'assets/icons/drawerIcons/delete.svg',
                        colorFilter:
                            ColorFilter.mode(TColors.grey, BlendMode.srcIn),
                      )),
                ],
              ),
              Divider(height: 2, color: TColors.grey),
              SizedBox(height: TSizes.spaceBtwItems),
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
                          onPressed: () {},
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
                          '${cartItem.quantity}', // Quantity number
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
                            color: TColors.white,
                          ),
                          onPressed: () {},
                        ),
                      )
                    ],
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: TSizes.spaceBtwItems),
                        child: Container(
                          height: 30,
                          decoration: BoxDecoration(
                            border: Border.all(color: TColors.grey, width: 1.5),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(
                            child: Text(
                              'Move To WishList',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
