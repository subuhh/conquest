import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../common/widgets/RoundedContainer.dart';
import '../../../../common/widgets/product_price_text.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';

class Productcardlarge extends StatelessWidget {
  const Productcardlarge({super.key, required this.title, required this.color, required this.orignalPrice, required this.discountedPrice});

  final String title;
  final String color;
  final double orignalPrice;
  final double discountedPrice;
  final String? imageUrl = 'https://cdn.shopify.com/s/files/1/0070/7032/files/product-label-design.jpg?v=1680902906';
  @override
  Widget build(BuildContext context) {
    // Access the defined text theme
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: TSizes.spaceBtwItems/2),
      child: Card(
        elevation: 0.25,
        color: Colors.white,
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
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
                      Text(title, style: textTheme.titleMedium),
                      Text('Color: ${color}', style: textTheme.bodyMedium?.copyWith(color: Colors.grey)),
                      SizedBox(height: TSizes.spaceBtwItems/1.5,),


                      /// Price
                      buildPriceText(orignalPrice: orignalPrice, dicountedPrice: discountedPrice,),
                      //Text('₹${widget.price*widget.quantity}', style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      buildDiscountRibbon(orignalPrice: orignalPrice,dicountedPrice:discountedPrice ,),
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
              Expanded(child: GestureDetector(
                  onTap: (){
                    //Remove From Cart
                    //Move to WishList
                  },
                  child: buildMoveToWhishList()))

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
    super.key, required this.orignalPrice, required this.dicountedPrice,

  });

  final double orignalPrice;
  final double dicountedPrice;

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
          '${((orignalPrice-dicountedPrice)/orignalPrice * 100).toInt()}% OFF',
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
    super.key, required this.orignalPrice, required this.dicountedPrice,

  });
final double orignalPrice;
final double dicountedPrice;


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
                text: '₹${orignalPrice}',
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
          price: '${dicountedPrice}',
        ),


        // Old Price

        const SizedBox(width: TSizes.spaceBtwItems),
        // Discounted Container

      ],
    );
  }
}
