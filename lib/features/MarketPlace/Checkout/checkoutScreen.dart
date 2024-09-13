import 'package:conquest/features/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class Checkoutscreen extends StatefulWidget {
  const Checkoutscreen({super.key});

  @override
  State<Checkoutscreen> createState() => _CheckoutscreenState();
}

class _CheckoutscreenState extends State<Checkoutscreen> {
  String selecteMethod = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            Text('Total ₹10,498',style: Theme.of(context).textTheme.titleMedium,),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(12)
              ),
              onPressed: () {
                // Place order logic
              },
              child: Text('Proceed to Pay',style: Theme.of(context).textTheme.titleMedium!.apply(color: Colors.white)),
              // Style will be derived from theme
            ),
          ],
        ),
      ),
      backgroundColor: TColors.secondaryBackground,
      appBar: AppBar(
        title: Text('Select a Payment method'),
        elevation: 0, // Uses theme's appBar style
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          ExpansionTile(
            title: Text('UPI Payments'),
            children: [
              RadioListTile(
                title: Text('PhonePe'),
                value: 'PhonePe',
                groupValue: selecteMethod,
                onChanged: (value) {
                  setState(() {
                    selecteMethod = value as String;
                  });
                },
              ),
              RadioListTile(
                title: Text('Google Pay'),
                value: 'Google Pay',
                groupValue: selecteMethod,
                onChanged: (value) {
                  setState(() {
                    selecteMethod = value as String;
                  });
                },
              ),
              RadioListTile(
                //fillColor: ,
                title: Text('Paytm'),
                value: 'Paytm',
                groupValue: selecteMethod,
                onChanged: (value) {
                  setState(() {
                    selecteMethod = value as String;
                  });
                },
              ),
              RadioListTile(
                title: Text('Pay via UPI ID'),
                value: 'Pay via UPI ID',
                groupValue: selecteMethod,
                onChanged: (value) {
                  setState(() {
                    selecteMethod = value as String;
                  });
                },
              ),
            ],
          ),
          ExpansionTile(
            title: Text('Debit / Credit / Saved Card'),
            children: [
              // Add widgets for debit/credit card payments
            ],
          ),
          ExpansionTile(
            title: Text('Wallets'),
            children: [
              RadioListTile(
                title: Text('Paytm & Paytm Postpaid'),
                value: 'Paytm & Paytm Postpaid',
                groupValue: selecteMethod,
                onChanged: (value) {
                  setState(() {
                    selecteMethod = value as String;
                  });
                },
              ),
              RadioListTile(
                title: Text('PhonePe'),
                value: 'PhonePe Wallet',
                groupValue: selecteMethod,
                onChanged: (value) {
                  setState(() {
                    selecteMethod = value as String;
                  });
                },
              ),
              RadioListTile(
                title: Text('Amazon Pay'),
                value: 'Amazon Pay',
                groupValue: selecteMethod,
                onChanged: (value) {
                  setState(() {
                    selecteMethod = value as String;
                  });
                },
              ),
              // Add more wallet options as needed
            ],
          ),
          ExpansionTile(
            title: Text('Internet Banking'),
            children: [
              // Add widgets for internet banking
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Container(
              padding: EdgeInsets.all(15),
              color: Colors.amber.shade50,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order Summary (3 items)',
                    style: Theme.of(context).textTheme.titleLarge, // Use theme's headline style
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total Price'),
                      Text('₹12,197'),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Convenience Fee'),
                      Text('₹0'),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Discount'),
                      Text('-₹1,699', style: TextStyle(color: Colors.green)), // Keeping green for discount
                    ],
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Amount',
                        style: Theme.of(context).textTheme.titleLarge, // Use theme's headline style
                      ),
                      Text(
                        '₹10,498',
                        style: Theme.of(context).textTheme.titleLarge, // Use theme's headline style
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
