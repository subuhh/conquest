import 'package:conquest/features/utils/constants/colors.dart';
import 'package:conquest/features/utils/constants/enums.dart';
import 'package:flutter/material.dart';
import 'OrderCard.dart';

final List<OrderCard> orders = [
  const OrderCard(
    orderID: 'HKM-25671-97046305',
    productName: 'MuscleBlaze Creatine Monohydrate',
    productCharacterstic: '0.55 lb Unflavoured',
    orderStatus: OrderStatus.delivered,
  ),
  const OrderCard(
    orderID: 'HKM-45678-97012345',
    productName: 'Optimum Nutrition Whey Protein',
    productCharacterstic: '2 lb Double Rich Chocolate',
    orderStatus: OrderStatus.shipped,
  ),
  const OrderCard(
    orderID: 'HKM-98765-97054321',
    productName: 'BSN Syntha-6 Protein Powder',
    productCharacterstic: '4.5 lb Strawberry Milkshake',
    orderStatus: OrderStatus.processing,
  ),
  // Add more orders as needed
];
class MyOrdersScreen extends StatelessWidget {
  const MyOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColors.secondaryBackground,
      appBar: AppBar(
        title: const Text('My Orders'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            return Padding(
              padding: const EdgeInsets.all(8.0), // Optional padding around each card
              child: OrderCard(
                orderID: order.orderID,
                productName: order.productName,
                productCharacterstic: order.productCharacterstic,
                orderStatus: order.orderStatus,
              ),
            );
          },
        )
      ),
    );
  }
}

