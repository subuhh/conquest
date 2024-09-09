import 'package:conquest/common/widgets/searchbar.dart';
import 'package:conquest/core/model/banner.dart';
import 'package:conquest/core/model/product.dart';
import 'package:conquest/core/services/firestore_service.dart';
import 'package:conquest/features/screens/MarketPlace/Carousel/carousel_section.dart';
import 'package:conquest/features/screens/MarketPlace/Category/category_section.dart';
import 'package:conquest/features/screens/MarketPlace/Products/Product_cart_screen/Cart_Screen.dart';
import 'package:conquest/features/screens/MarketPlace/Products/Products_screen/products_section.dart';
import 'package:conquest/features/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../utils/constants/colors.dart';

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  final _firestoreService = FirestoreService();
  List<Map<String, dynamic>> _categories = [];
  List<BannerModel> _banners = [];
  List<ProductModel> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMarketplaceData();
  }

  Future<void> _fetchMarketplaceData() async {
    _products = await _firestoreService.fetchAllProducts();

    _categories = await _firestoreService.fetchCategories();

    _banners =
        await _firestoreService.fetchBanners(targetScreen: 'marketplace');

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColors.secondaryBackground,
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
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logos/conquest-icon.png',
              height: TSizes.iconLg + 15,
            ),
            const SizedBox(width: 5,),
            Image.asset(
              'assets/logos/conquest-string.png',
              height: TSizes.iconLg+80,
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>CartScreen()));
            },
            icon: const Icon(
              Iconsax.shopping_cart,
              size: TSizes.iconLg,
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _fetchMarketplaceData,
        color: TColors.primary,
        backgroundColor: Colors.white,
        child: Column(
          children: [
            const Searchbar(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Carousel Slider
                    CarouselSection(
                      isLoading: _isLoading, imageUrls: ["assets/Banners/img.png",'assets/Banners/img_1.png','assets/Banners/img_3.jpg','assets/Banners/img_4.jpg'],
                     // banners: _banners,
                    ),

                    // Category Buttons
                    CategorySection(
                      categories: _categories,
                      isLoading: _isLoading,
                    ),

                    // Trending Section
                    ProductsSection(
                      title: 'Trending Now',
                      isLoading: _isLoading,
                      products: _products,
                    ),

                    // Bestseller Section
                    ProductsSection(
                      title: 'Bestseller',
                      isLoading: _isLoading,
                      products: _products,
                    ),

                    // Top Picks Section
                    ProductsSection(
                      title: 'Top Picks',
                      isLoading: _isLoading,
                      products: _products,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
