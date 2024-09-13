import 'dart:developer';

import 'package:conquest/core/model/address.dart';
import 'package:conquest/core/services/firestore_service.dart';
import 'package:conquest/features/Address/add_new_address.dart';
import 'package:conquest/features/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../core/Controllers/location_service.dart';
import '../../core/services/auth_service.dart';
import '../utils/constants/colors.dart';
import '../utils/constants/sizes.dart';

class SavedAddress extends StatefulWidget {
  const SavedAddress({super.key});

  @override
  State<SavedAddress> createState() => _SavedAddressState();
}

class _SavedAddressState extends State<SavedAddress> {
  final locationController = Get.put(LocationController());
  final controller = Get.put(AuthService());
  List<AddressModel> addressModel = [];
  bool isLoading = true;
  final FirestoreService fireStore = FirestoreService();

  @override
  void initState() {
    super.initState();
    _fetchAllAddress();
  }

  Future<void> _fetchAllAddress() async {
    try {
      addressModel =
          await fireStore.fetchAllAddress(controller.currentUser!.uid);
      log('Address Model Length: ${addressModel.length}');
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      rethrow;
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Function to get icon based on address type
  IconData _getAddressIcon(String type) {
    switch (type.toLowerCase()) {
      case 'home':
        return Iconsax.home;
      case 'work':
        return Iconsax.building_4;
      default:
        return Iconsax.location;
    }
  }

  // Function to get title for address type
  String _getAddressTypeTitle(String type) {
    switch (type.toLowerCase()) {
      case 'home':
        return 'Home';
      case 'work':
        return 'Work';
      default:
        return 'Other';
    }
  }

  // Function to build the address string
  String buildAddress(AddressModel address) {
    List<String> addressComponents = [];

    // Only add fields if they are not empty
    if (address.houseNumber.isNotEmpty) {
      addressComponents.add(address.houseNumber);
    }
    if (address.floor.isNotEmpty) {
      addressComponents.add(address.floor);
    }
    if (address.towerOrBlock.isNotEmpty) {
      addressComponents.add(address.towerOrBlock);
    }
    if (address.streetAddress.isNotEmpty) {
      addressComponents.add(address.streetAddress);
    }
    if (address.landmark.isNotEmpty) {
      addressComponents.add(address.landmark);
    }
    if (address.city.isNotEmpty) addressComponents.add(address.city);

    if (address.state.isNotEmpty) addressComponents.add(address.state);

    if (address.postalCode.isNotEmpty) {
      addressComponents.add(address.postalCode);
    }

    // Join all the address components with commas
    return addressComponents.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColors.secondaryBackground,
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'My Addresses',
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              tileColor: Colors.white,
              leading: const Icon(
                Icons.add,
                color: Colors.green,
                size: 24,
                weight: 4,
              ),
              title: Text(
                'Add Address',
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      color: Colors.green,
                    ),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              onTap: () {
                locationController.currentPosition.value;
                Get.to(() => const AddNewAddress());
              },
            ),
            if (addressModel.length.isGreaterThan(0)) ...[
              const SizedBox(height: TSizes.defaultSpace),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(child: Divider()),
                  const SizedBox(width: 10),
                  Text(
                    ' SAVED ADDRESSES ',
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black.withOpacity(0.9)),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: TSizes.defaultSpace),
              isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Colors.green,
                      ),
                    )
                  : Expanded(
                      child: ListView.separated(
                        itemCount: addressModel.length,
                        separatorBuilder: (context, index) {
                          return const SizedBox(
                            height: 20,
                          );
                        },
                        itemBuilder: (BuildContext context, int index) {
                          final address = addressModel[index];
                          return ListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            tileColor: Colors.white,
                            leading: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  _getAddressIcon(address.addressType),
                                ),
                              ],
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            title: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  _getAddressTypeTitle(address.addressType),
                                ),
                                const Spacer(),
                                IconButton(
                                  onPressed: () {},
                                  icon: CircleAvatar(
                                    radius: 13,
                                    backgroundColor:
                                        Colors.grey.withOpacity(0.5),
                                    child: const CircleAvatar(
                                      radius: 12,
                                      backgroundColor: Colors.white,
                                      child: Icon(
                                        Icons.more_horiz,
                                        color: Colors.black,
                                        size: 22,
                                      ),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: CircleAvatar(
                                    radius: 13,
                                    backgroundColor:
                                        Colors.grey.withOpacity(0.5),
                                    child: CircleAvatar(
                                      radius: 12,
                                      backgroundColor: Colors.white,
                                      child: SvgPicture.asset(
                                        'assets/icons/appicons/share.svg',
                                        height: 22,
                                        width: 22,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: THelperFunctions.screenWidth(context) *
                                      0.6,
                                  child: Text(
                                    buildAddress(address),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
            ]
          ],
        ),
      ),
    );
  }

  Container customAddressTile({
    required IconData icon,
    required String title,
    required String subTitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Leading Icon on top
          Icon(
            icon, // Adjust the icon size if necessary
            size: 30,
            color: Colors.black,
          ),
          const SizedBox(height: 8), // Spacing between icon and text

          // Title
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8), // Spacing between title and subtitle

          // Subtitle
          Text(
            subTitle,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 12), // Spacing between subtitle and icons

          // Row with two icons below the subtitle
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {
                  // Add functionality for first icon
                },
                icon: const Icon(
                  Icons.more_horiz,
                  color: Colors.black,
                ),
              ),
              IconButton(
                onPressed: () {
                  // Add functionality for second icon
                },
                icon: const Icon(
                  Icons.share,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
