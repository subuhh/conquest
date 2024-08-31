import 'package:carousel_slider/carousel_slider.dart';
import 'package:conquest/common/widgets/searchbar.dart';
import 'package:conquest/features/screens/MarketPlace/productCard.dart';
import 'package:conquest/features/utils/constants/colors.dart';
import 'package:conquest/features/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  final List<String> carouselImages = [
    'https://via.placeholder.com/600x300?text=Fitness+Gear',
    'https://via.placeholder.com/600x300?text=Anime+Merch',
    'https://via.placeholder.com/600x300?text=Supplements+Sale',
  ];

  

  final List<Map<String, String>> trendingItems = [
    {'title': 'Dumbbells Set', 'image': 'https://picsum.photos/400?random=2'},
    {'title': 'Anime Hoodie', 'image': 'https://picsum.photos/400?random=5'},
    {'title': 'Protein Powder', 'image': 'https://picsum.photos/400?random=6'},
    {
      'title': 'Resistance Bands',
      'image': 'https://picsum.photos/400?random=7'
    },
  ];

  final List<Map<String, String>> Categories = [
    {'title': 'Supplements', 'image': 'assets/icons/appicons/supplimenticon.svg'},
    {'title': 'Merchandise', 'image': 'assets/icons/appicons/merchandiseIcon.svg'},
    {'title': 'Healthy\n Snacks', 'image': 'assets/icons/appicons/healthySnacksIcon.svg'},
    {
      'title': 'Equipments',
      'image': 'assets/icons/appicons/gymEquipments.svg'
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Searchbar(),
              // Carousel Slider
              CarouselSlider(
                options: CarouselOptions(
                  height: 200.0,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  viewportFraction: 1.0,
                  enableInfiniteScroll: true,
                ),
                items: List.generate(10, (index) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.network(
                            'https://picsum.photos/400?random=$index',
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
              // Category Buttons
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: Categories.map((category) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                                radius: 40,
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: SvgPicture.asset(
                                    category['image']!,
                                    fit: BoxFit.contain, // Ensures the image fits within the container
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: TSizes.sm),
                            Container(
                              width: 80, // Set a fixed width for the text to ensure alignment
                              child: Text(
                                category['title']!,
                                style: Theme.of(context).textTheme.bodySmall,
                                textAlign: TextAlign.center, // Center the text
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
        
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
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.65,
        ),
        itemBuilder: (context, index) {
          final product = products[index];

          // Ensure all fields have default values if null
          final imageUrl = product['image'] ?? '';
          final title = product['title'] ?? 'Product';
          //return buildProductCard(imageUrl, title);
          return ProductCard(imageUrl: imageUrl, title: 'Product name', oldPrice: '500', newPrice: '300',);
        },
      ),
    );
  }

  Widget buildProductCard(
    String imageUrl,
    String title,
  ) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(15)),
                child: Image.network(
                  imageUrl,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.error), // Handle image load errors
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Title
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),

                    // Price Row
                    const Row(
                      children: [
                        // if (oldPrice != null && oldPrice.isNotEmpty)
                        Text(
                          '₹500',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        SizedBox(width: 6),
                        Text(
                          '₹349',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Add to Cart Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 20),
                      ),
                      onPressed: () {
                        // Add to cart logic here
                      },
                      child: const Text(
                        'Add to Cart',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Discount Ribbon
          Positioned(
            top: 10,
            left: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                '20% OFF',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
