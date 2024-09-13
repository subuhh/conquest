import 'dart:developer';

import 'package:conquest/core/model/user.dart';
import 'package:conquest/core/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/services/firestore_service.dart';
import '../utils/constants/colors.dart';
import '../utils/constants/sizes.dart';
import '../utils/helpers/helper_functions.dart';
import '../utils/theme/customthemes/textThemes.dart';

class AddAddressDetails extends StatefulWidget {
  final String selectedAddress;
  const AddAddressDetails({super.key, required this.selectedAddress});

  @override
  State<AddAddressDetails> createState() => _AddAddressDetailsState();
}

class _AddAddressDetailsState extends State<AddAddressDetails> {
  final controller = Get.put(AuthService());
  final houseNumberController = TextEditingController();
  final floorController = TextEditingController();
  final towerController = TextEditingController();
  final landmarkController = TextEditingController();
  UserModel? userModel;
  final FirestoreService _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    try {
      final user = controller.user;
      final userData = await user.first;
      if (userData != null) {
        userModel = await _firestoreService.getUserDetails(userData.uid);
      }
    } catch (e) {
      log('Error fetching user details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 15,
        right: 15,
        top: 10,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter complete address',
              style: TTextTheme.lightTextTheme.titleLarge,
            ),
            const SizedBox(height: TSizes.spaceBtwItems),
            _buildReceiverDetails(),
            const SizedBox(height: TSizes.defaultSpace / 2),
            _buildAddressForm(context),
          ],
        ),
      ),
    );
  }

  Widget _buildReceiverDetails() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Receiver details for this address',
            style: TTextTheme.lightTextTheme.titleSmall,
          ),
          const SizedBox(height: TSizes.spaceBtwItems),
          Row(
            children: [
              const Icon(Icons.phone, size: 22),
              const SizedBox(width: 10),
              Text(
                '${userModel?.name ?? ''}, ${userModel?.phoneNumber ?? ''}',
                style: TTextTheme.lightTextTheme.titleSmall,
              ),
              const Spacer(),
              const Icon(Icons.arrow_forward_ios, size: 22),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddressForm(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Save address as *'),
          const SizedBox(height: TSizes.defaultSpace / 2),
          _buildAddressTypeChips(),
          const SizedBox(height: TSizes.defaultSpace),
          _buildAddressField(widget.selectedAddress),
          const SizedBox(height: TSizes.spaceBtwItems),
          _buildTextField('House number *', houseNumberController),
          const SizedBox(height: TSizes.spaceBtwItems),
          _buildTextField('Floor', floorController),
          const SizedBox(height: TSizes.spaceBtwItems),
          _buildTextField('Tower / Block *', towerController),
          const SizedBox(height: TSizes.spaceBtwItems),
          _buildTextField('Nearby landmark (optional)', landmarkController),
          const SizedBox(height: TSizes.spaceBtwItems),
          SizedBox(
            width: double.maxFinite, // Set the width of the button
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: TSizes.spaceBtwItems),
              ),
              onPressed: () {},
              child: const Text('Save'),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAddressTypeChips() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        ChoiceChip(
          label: Row(children: [Icon(Icons.home_outlined), SizedBox(width: 5), Text('Home')]),
          selected: true,
        ),
        ChoiceChip(
          label: Row(children: [Icon(Icons.work_outline), SizedBox(width: 5), Text('Work')]),
          selected: false,
        ),
        ChoiceChip(
          label: Row(children: [Icon(Icons.location_on_outlined), SizedBox(width: 5), Text('Other')]),
          selected: false,
        ),
      ],
    );
  }

  Widget _buildAddressField(String address) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: TColors.grey),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              address,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: TTextTheme.lightTextTheme.displayLarge,
            ),
          ),
          OutlinedButton(
            onPressed: () => Get.back(),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.all(15),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              side: const BorderSide(color: TColors.grey),
            ),
            child: Text('Change', style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String labelText, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: Theme.of(context).textTheme.bodyMedium,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $labelText';
        }
        return null;
      },
    );
  }
}
