import 'package:conquest/features/utils/constants/colors.dart';
import 'package:flutter/material.dart';

import '../../../../utils/constants/enums.dart';
import 'OrderCard.dart';

final List<OrderCard> orders = [
  OrderCard(
    OrderID: 'HKM-25671-97046305',
    ProductName: 'MuscleBlaze Creatine Monohydrate',
    ProductCharacterstic: '0.55 lb Unflavoured',
    orderStatus: OrderStatus.delivered,
  ),
  OrderCard(
    OrderID: 'HKM-45678-97012345',
    ProductName: 'Optimum Nutrition Whey Protein',
    ProductCharacterstic: '2 lb Double Rich Chocolate',
    orderStatus: OrderStatus.shipped,
  ),
  OrderCard(
    OrderID: 'HKM-98765-97054321',
    ProductName: 'BSN Syntha-6 Protein Powder',
    ProductCharacterstic: '4.5 lb Strawberry Milkshake',
    orderStatus: OrderStatus.processing,
  ),
  // Add more orders as needed
];
class MyOrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColors.secondaryBackground,
      appBar: AppBar(
        title: Text('My Orders'),
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
                OrderID: order.OrderID,
                ProductName: order.ProductName,
                ProductCharacterstic: order.ProductCharacterstic,
                orderStatus: order.orderStatus,
              ),
            );
          },
        )
      ),
    );
  }
}

