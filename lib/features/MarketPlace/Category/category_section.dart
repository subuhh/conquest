import 'package:conquest/features/MarketPlace/Category/Category%20Screen.dart';
import 'package:conquest/features/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/sizes.dart';

class CategorySection extends StatefulWidget {
  final List<Map<String, dynamic>> categories;
  final bool isLoading;
  const CategorySection(
      {super.key, required this.categories, required this.isLoading});

  @override
  State<CategorySection> createState() => _CategorySectionState();
}

class _CategorySectionState extends State<CategorySection> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          widget.isLoading
              ? buildShimmerCategories()
              : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: widget.categories.map((category) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: GestureDetector(
                      onTap: () => THelperFunctions.navigateToScreen(
                          context, CategoryScreen()),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: TColors.grey,
                                width: 1.5,
                              ),
                            ),
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 30,
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: SvgPicture.asset(
                                  getSvgAssetForCategory(category['name']),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: TSizes.sm),
                          SizedBox(
                            width: 85,
                            child: Text(
                              category['name']!,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(fontSize: 12),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
        ],
      ),
    );
  }

  Widget buildShimmerCategories() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(4, (index) => shimmerCircle()).toList(),
      ),
    );
  }

  Widget shimmerCircle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          width: 70,
          height: 70,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  String getSvgAssetForCategory(String name) {
    switch (name.toLowerCase()) {
      case 'supplements':
        return 'assets/icons/appicons/supplimenticon.svg';
      case 'merchandise':
        return 'assets/icons/appicons/merchandiseIcon.svg';
      case 'healthy snacks':
        return 'assets/icons/appicons/healthySnacksIcon.svg';
      case 'equipments':
        return 'assets/icons/appicons/gymEquipments.svg';
      default:
        return 'assets/icons/appicons/supplimenticon.svg'; // Fallback icon if no match
    }
  }
}
