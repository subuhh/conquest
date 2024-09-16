import 'package:conquest/common/widgets/custom_snackbar.dart';
import 'package:conquest/core/model/address.dart';
import 'package:conquest/features/Address/add_new_address.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../common/widgets/divider_with_text.dart';
import '../../core/Controllers/Address_Controllers/saved_address_controller.dart';
import '../../utils/Shimmer/shimmer.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/sizes.dart';
import '../../utils/theme/customthemes/textThemes.dart';


class SavedAddress extends StatelessWidget {
  const SavedAddress({super.key});

  @override
  Widget build(BuildContext context) {
    final AddressController addressController = Get.put(AddressController());

    // Function to get icon based on address type
    IconData getAddressIcon(String type) {
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
    String getAddressTypeTitle(String type) {
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

      if (address.houseNumber.isNotEmpty) {
        addressComponents.add(address.houseNumber);
      }
      if (address.floor.isNotEmpty) addressComponents.add(address.floor);
      if (address.towerOrBlock.isNotEmpty) {
        addressComponents.add(address.towerOrBlock);
      }
      if (address.streetAddress.isNotEmpty) {
        addressComponents.add(address.streetAddress);
      }
      if (address.landmark.isNotEmpty) addressComponents.add(address.landmark);
      if (address.city.isNotEmpty) addressComponents.add(address.city);
      if (address.state.isNotEmpty) addressComponents.add(address.state);
      if (address.postalCode.isNotEmpty) {
        addressComponents.add(address.postalCode);
      }

      return addressComponents.join(', ');
    }

    void showDeleteConfirmationDialog(AddressModel address) {
      Get.defaultDialog(
        title: 'Delete Address',
        middleText: 'Are you sure you want to delete this address?',
        textCancel: 'Cancel',
        textConfirm: 'Delete',
        buttonColor: Colors.green,
        confirmTextColor: Colors.white,
        onCancel: () {},
        onConfirm: () async {
          Get.back(); // Close the dialog
          await addressController.deleteAddress(address.id);
          showSnackBar('Success', 'Address deleted successfully');
        },
        barrierDismissible: false,
      );
    }

    ListTile addressTile(AddressModel address) {
      return ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
        tileColor: Colors.white,
        leading: Icon(getAddressIcon(address.addressType)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(getAddressTypeTitle(address.addressType)),
            const Spacer(),
            PopupMenuButton<String>(
              color: Colors.white,
              icon: CircleAvatar(
                radius: 13,
                backgroundColor: Colors.grey.withOpacity(0.5),
                child: const CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.more_horiz, color: Colors.black, size: 22),
                ),
              ),
              onSelected: (value) {
                // if (value == 'edit') {
                // }
                if (value == 'delete') {
                  showDeleteConfirmationDialog(address);
                }
              },
              itemBuilder: (BuildContext context) {
                return [
                  // PopupMenuItem(
                  //   value: 'edit',
                  //   child: Text(
                  //     'Edit',
                  //     style: TTextTheme.lightTextTheme.titleLarge,
                  //   ),
                  // ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Text(
                      'Delete',
                      style: TTextTheme.lightTextTheme.titleLarge,
                    ),
                  ),
                ];
              },
            ),
          ],
        ),
        subtitle: Text(
          buildAddress(address),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }

    return Scaffold(
      backgroundColor: TColors.secondaryBackground,
      appBar: AppBar(
        elevation: 0,
        title: const Text('My Addresses'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Add Address Tile
            ListTile(
              tileColor: Colors.white,
              leading: const Icon(
                Icons.add,
                color: Colors.green,
                size: 24,
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
                Get.to(() => const AddNewAddress());
              },
            ),
            const SizedBox(height: TSizes.defaultSpace),

            // StreamBuilder for fetching addresses
            StreamBuilder<List<AddressModel>>(
              stream: addressController.addressStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Expanded(
                    child: ListView.separated(
                      itemCount: 5, // Show 5 shimmer placeholders
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: TSizes.defaultSpace),
                      itemBuilder: (context, index) =>
                          TShimmer.singleContainer(60),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const SizedBox.shrink();
                } else {
                  final addresses = snapshot.data!;
                  return Expanded(
                    child: Column(
                      children: [
                        // Saved Address
                        const DividerWithText(title: 'SAVED ADDRESSES'),
                        const SizedBox(height: TSizes.defaultSpace),
                        Expanded(
                          child: ListView.separated(
                            itemCount: addresses.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 20),
                            itemBuilder: (context, index) {
                              final address = addresses[index];
                              return addressTile(address);
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
