import 'package:flutter/material.dart';
import '../../../../../common/widgets/TCurvedEdgesWidget.dart';
import '../../../../../common/widgets/Troundedimage.dart';
import '../../../../../core/model/product.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_functions.dart';

class ProductImageSlider extends StatefulWidget {
  final ProductModel productModel;

  const ProductImageSlider({
    super.key,
    required this.productModel,
  });

  @override
  State<ProductImageSlider> createState() => _ProductImageSliderState();
}

class _ProductImageSliderState extends State<ProductImageSlider> {
  int _selectedImageIndex = 0;
  final PageController _pageController = PageController();

  // Function to show full-screen zoomable image
  void _showZoomableImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.all(0),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pop(); // Close the dialog when tapping anywhere
          },
          child: InteractiveViewer(
            panEnabled: true,
            minScale: 0.5,
            maxScale: 4.0,
            child: Center(
              child: Image.network(imageUrl),
            ),
          ),
        ),
      ),
    );
  }

  // Function to update the selected image when swiping
  void _onPageChanged(int index) {
    setState(() {
      _selectedImageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final imageCount = widget.productModel.images.length;

    return TCurvedEdgesWidget(
      child: Container(
        color: dark ? TColors.darkerGrey : TColors.light,
        child: Stack(
          alignment: Alignment.center,
          children: [
            /// Main Large Image (Swipable with PageView)
            GestureDetector(
              onTap: () {
                // Open zoomable image on tap
                _showZoomableImage(context, widget.productModel.images[_selectedImageIndex]);
              },
              child: SizedBox(
                height: 400,
                child: Padding(
                  padding: const EdgeInsets.all(TSizes.productImageRadius * 2),
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: _onPageChanged,
                    itemCount: widget.productModel.images.length,
                    itemBuilder: (context, index) {
                      return Image.network(
                        widget.productModel.images[index],
                        fit: BoxFit.fitHeight,
                      );
                    },
                  ),
                ),
              ),
            ),

            /// Image Slider (Below the main image)
            Positioned(
              bottom: TSizes.spaceBtwSections,
              child: SizedBox(
                height: 80,
                width: imageCount == 1
                    ? 80
                    : imageCount == 2
                    ? MediaQuery.of(context).size.width * 0.5
                    : MediaQuery.of(context).size.width * 0.9,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: widget.productModel.images.length,
                  separatorBuilder: (_, __) => const SizedBox(
                    width: TSizes.spaceBtwItems,
                  ),
                  itemBuilder: (_, index) {
                    return GestureDetector(
                      onTap: () {
                        // Update the selected image and swipe to the corresponding page
                        setState(() {
                          _selectedImageIndex = index;
                          _pageController.animateToPage(index,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut);
                        });
                      },
                      child: TRoundedImage(
                        fit: BoxFit.fitHeight,
                        backgroundColor: dark ? TColors.dark : TColors.white,
                        width: 80,
                        border: Border.all(
                          color: _selectedImageIndex == index
                              ? TColors.primary
                              : Colors.grey, // Highlight selected image
                        ),
                        padding: const EdgeInsets.all(TSizes.sm),
                        imageUrl: widget.productModel.images[index],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
