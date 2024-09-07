import 'package:carousel_slider/carousel_slider.dart';
import 'package:conquest/common/widgets/searchbar.dart';
import 'package:conquest/core/model/banner.dart';
import 'package:conquest/core/services/firestore_service.dart';
import 'package:conquest/features/screens/MarketPlace/productCard.dart';
import 'package:conquest/features/utils/constants/colors.dart';
import 'package:conquest/features/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shimmer/shimmer.dart';

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  final _firestoreService = FirestoreService();
  List<Map<String, dynamic>> _categories = [];
  List<BannerModel> _banners = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadCategories();
    loadBanners();
  }

  Future<void> loadCategories() async {
    _categories = await _firestoreService.fetchCategories();
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> loadBanners() async {
    _banners =
        await _firestoreService.fetchBanners(targetScreen: 'marketplace');
  }

  final List<Map<String, String>> trendingItems = [
    {'title': 'Dumbbells Set', 'image': 'https://picsum.photos/400?random=2'},
    {'title': 'Anime Hoodie', 'image': 'https://picsum.photos/400?random=5'},
    {'title': 'Protein Powder', 'image': 'https://picsum.photos/400?random=6'},
    {
      'title': 'Resistance Bands',
      'image': 'https://picsum.photos/400?random=7'
    },
  ];

  final List<Map<String, String>> bestsellers = [
    {'title': 'Anime T-shirt', 'image': 'https://picsum.photos/400?random=1'},
    {'title': 'Yoga Mat', 'image': 'https://picsum.photos/400?random=4'},
    {'title': 'Pre-Workout', 'image': 'https://picsum.photos/400?random=3'},
    {'title': 'Fitness Tracker', 'image': 'https://picsum.photos/400?random=8'},
  ];

  final List<Map<String, String>> topPicks = [
    {'title': 'Anime Figure', 'image': 'https://picsum.photos/400?random=2'},
    {'title': 'Kettlebell', 'image': 'https://picsum.photos/400?random=9'},
    {'title': 'Whey Protein', 'image': 'https://picsum.photos/400?random=10'},
    {'title': 'Anime Poster', 'image': 'https://picsum.photos/400?random=11'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushNamed(context, '/drawer');
          },
          icon: const Icon(
            Icons.menu,
            size: TSizes.iconLg,
          ),
        ),
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logos/conquest-icon.png',
              height: TSizes.iconLg + 10,
            ),
            Image.asset(
              'assets/logos/conquest-string.png',
              height: TSizes.imageThumbSize + 8,
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Iconsax.shopping_cart,
              size: TSizes.iconLg,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const Searchbar(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Carousel Slider
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 200.0,
                      autoPlay: true,
                      enlargeCenterPage: true,
                      viewportFraction: 1.0,
                      enableInfiniteScroll: true,
                    ),
                    items: List.generate(_banners.length, (index) {
                      final banner = _banners[index];
                      return Builder(
                        builder: (BuildContext context) {
                          return GestureDetector(
                            onTap: () => Navigator.pushNamed(
                              context,
                              banner.onTapScreen,
                            ),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image.network(
                                  banner.imageUrl,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10),
                  // Category Buttons
                  buildCategories(),

                  // Trending Section
                  buildSectionTitle(context, 'Trending Now'),
                  buildProductGridView(trendingItems),

                  // Bestseller Section
                  buildSectionTitle(context, 'Bestsellers'),
                  buildProductGridView(bestsellers),

                  // Top Picks Section
                  buildSectionTitle(context, 'Top Picks'),
                  buildProductGridView(topPicks),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCategories() {
    return _isLoading
        ? buildShimmerCategories()
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: _categories.map((category) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                    ),
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
                            radius: 35,
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
                                .copyWith(fontSize: 13),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          );
  }

  Widget buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text('See All'),
          ),
        ],
      ),
    );
  }

  Widget buildProductGridView(List<Map<String, String>> products) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      // child: GridView.builder(
      //   shrinkWrap: true,
      //   physics: const NeverScrollableScrollPhysics(),
      //   itemCount: products.length,
      //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      //     crossAxisCount: 2,
      //     crossAxisSpacing: 10,
      //     mainAxisSpacing: 10,
      //     childAspectRatio: 0.62,
      //   ),
      //   itemBuilder: (context, index) {
      //     final product = products[index];
      //
      //     // Ensure all fields have default values if null
      //     final imageUrl = product['image'] ?? '';
      //     //return buildProductCard(imageUrl, title);
      //     return ProductCard(
      //       imageUrl: imageUrl,
      //       title: 'Product name',
      //       oldPrice: '500',
      //       newPrice: '300',
      //     );
      //   },
      // ),
      child: SizedBox(
        height: 300, // Adjust this height based on the item size
        child: ListView.builder(
          scrollDirection:
              Axis.horizontal, // Make the ListView scroll horizontally
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];

            // Ensure all fields have default values if null
            final imageUrl = product['image'] ?? '';

            return SizedBox(
              width: MediaQuery.of(context).size.width *
                  0.475, // Adjust width based on your requirement
              //margin: EdgeInsets.symmetric(horizontal: 10.0), // Add some spacing between items
              child: ProductCard(
                imageUrl: imageUrl,
                title: 'Product name',
                oldPrice: '500',
                newPrice: '300',
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildShimmerCategories() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children:
              List.generate(_categories.length, (index) => shimmerCircle())
                  .toList(),
        ),
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
