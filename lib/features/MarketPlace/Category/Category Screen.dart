// import 'package:flutter/material.dart';
//
// import '../../../utils/constants/colors.dart';
// import '../Products/ProductCard/ProductCardLarge.dart';
//
// class CategoryScreen extends StatelessWidget {
//   const CategoryScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: TColors.secondaryBackground,
//       appBar: AppBar(
//         leading: IconButton(
//             onPressed: () => Navigator.pop(context),
//             icon: Icon(
//               Icons.arrow_back,
//               color: Colors.white,
//             )),
//         backgroundColor: TColors.primary,
//         title: Text(
//           'Category Title',
//           style: Theme.of(context)
//               .textTheme
//               .titleMedium!
//               .apply(color: Colors.white),
//         ),
//         centerTitle: true,
//       ),
//       body: ListView.builder(
//         itemCount: 5,
//         itemBuilder: (context, index) {
//           return ProductCardLarge(
//               title: 'Title',
//               imageUrl: '',
//               color: 'color',
//               originalPrice: 50,
//               discountedPrice: 40);
//         },
//       ),
//     );
//   }
// }
