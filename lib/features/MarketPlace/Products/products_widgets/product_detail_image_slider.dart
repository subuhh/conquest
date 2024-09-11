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

  late List<String> _imageList;

  @override
  void initState() {
    super.initState();
    _imageList = List.from(widget.productModel.images); // Copy images list to modify
  }

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

  // Function to update the image order and move the selected image to the first place
  void _moveSelectedImageToFirst(int index) {
    setState(() {
      String selectedImage = _imageList[index];  // Get the selected image
      _imageList.removeAt(index);               // Remove it from its current position
      _imageList.insert(0, selectedImage);      // Insert it at the first position
      _selectedImageIndex = 0;                  // Set the first image as the selected image
      _pageController.jumpToPage(0);            // Move the PageView to the first image
    });
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final imageCount = _imageList.length;

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
                _showZoomableImage(context, _imageList[_selectedImageIndex]);
              },
              child: SizedBox(
                height: 400,
                child: Padding(
                  padding: const EdgeInsets.all(TSizes.productImageRadius * 2),
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: _onPageChanged,
                    itemCount: _imageList.length,
                    itemBuilder: (context, index) {
                      return Image.network(
                        _imageList[index],
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
                    : MediaQuery.of(context).size.width * 0.8,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: _imageList.length,
                  separatorBuilder: (_, __) => const SizedBox(
                    width: TSizes.spaceBtwItems,
                  ),
                  itemBuilder: (_, index) {
                    return GestureDetector(
                      onTap: () {
                        // Move selected image to the first place and display it
                        _moveSelectedImageToFirst(index);
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
                        imageUrl: _imageList[index],
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
