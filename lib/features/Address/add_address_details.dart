import 'package:conquest/core/Controllers/location_service.dart';
import 'package:conquest/core/model/address.dart';
import 'package:conquest/core/services/auth_service.dart';
import 'package:conquest/core/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../common/widgets/custom_snackbar.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/sizes.dart';
import '../../utils/helpers/helper_functions.dart';
import '../../utils/theme/customthemes/textThemes.dart';

class AddAddressDetails extends StatefulWidget {
  final String? selectedAddress;
  final String? userName;
  final String? phoneNumber;
  final bool? isCurrentAddress;
  final LocationController? locationController;
  final AddressModel? addressModel;

  const AddAddressDetails(
      {super.key,
      this.selectedAddress,
      this.userName,
      this.phoneNumber,
      this.isCurrentAddress,
      this.locationController,
      this.addressModel});

  @override
  State<AddAddressDetails> createState() => _AddAddressDetailsState();
}

class _AddAddressDetailsState extends State<AddAddressDetails> {
  final formKey = GlobalKey<FormState>();
  final _fireStore = FirestoreService();
  final houseNumberController = TextEditingController();
  final floorController = TextEditingController();
  final towerController = TextEditingController();
  final landmarkController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  String selectedAddressType = 'Home';
  bool isLoading = false;
  bool isEditingReceiverDetails = false;

  @override
  void initState() {
    super.initState();
    if (widget.addressModel != null) {
      // nameController.text = widget.addressModel!.recipientName;
      // phoneController.text = widget.addressModel!.phoneNumber;
      houseNumberController.text = widget.addressModel!.houseNumber;
      floorController.text = widget.addressModel!.floor;
      towerController.text = widget.addressModel!.towerOrBlock;
      landmarkController.text = widget.addressModel!.landmark;
      selectedAddressType = widget.addressModel!.addressType;
    } else {
      nameController.text = widget.userName!;
      phoneController.text = widget.phoneNumber!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SizedBox(
        height: widget.addressModel != null
            ? THelperFunctions.screenHeight(context) * 0.7
            : THelperFunctions.screenHeight(context) * 0.82,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 15, right: 15, top: 10, bottom: 20),
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: TSizes.defaultSpace / 2),
                      Row(
                        children: [
                          if (widget.addressModel != null) ...[
                            GestureDetector(
                              onTap: () => Get.back(),
                              child: Icon(Icons.arrow_back),
                            ),
                            const SizedBox(width: 12),
                          ],
                          Text(
                            widget.addressModel == null
                                ? 'Enter complete address'
                                : 'Update your address',
                            style: TTextTheme.lightTextTheme.headlineMedium!
                                .copyWith(fontSize: 22),
                            // style: ,
                          ),
                        ],
                      ),
                      const SizedBox(height: TSizes.defaultSpace),
                      if (widget.addressModel == null) ...[
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isEditingReceiverDetails = true;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            height: isEditingReceiverDetails
                                ? THelperFunctions.screenHeight(context) * 0.18
                                : THelperFunctions.screenHeight(context) * 0.1,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: isEditingReceiverDetails
                                ? Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      TextFormField(
                                        controller: nameController,
                                        decoration: InputDecoration(
                                          labelText: "Receiver's name",
                                          prefixIcon:
                                              const Icon(Iconsax.direct),
                                          suffixIcon: IconButton(
                                            onPressed: () {
                                              nameController.clear();
                                            },
                                            icon: const Icon(
                                                Iconsax.close_circle),
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter an name.';
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(
                                          height: TSizes.defaultSpace / 2),
                                      TextFormField(
                                        controller: phoneController,
                                        decoration: InputDecoration(
                                          labelText: "Receiver's contact",
                                          prefixIcon: const Icon(Iconsax.call),
                                          suffixIcon: IconButton(
                                            onPressed: () {
                                              phoneController.clear();
                                            },
                                            icon: const Icon(
                                                Iconsax.close_circle),
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter a Phone Number';
                                          } else if (!RegExp(r'^[6-9]\d{9}$')
                                              .hasMatch(value)) {
                                            return 'Please enter a valid Phone Number';
                                          }
                                          return null;
                                        },
                                      ),
                                    ],
                                  )
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Receiver details for this address',
                                        style: TTextTheme
                                            .lightTextTheme.titleLarge,
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          const Icon(Icons.phone, size: 22),
                                          const SizedBox(width: 10),
                                          Text(
                                            // '${userModel!.name}, ${userModel!.phoneNumber}',
                                            '${widget.userName}, ${widget.phoneNumber}',
                                            style: TTextTheme
                                                .lightTextTheme.titleSmall,
                                          ),
                                          const Spacer(),
                                          const Icon(Icons.arrow_forward_ios,
                                              size: 22),
                                        ],
                                      ),
                                      const SizedBox(
                                          height: TSizes.defaultSpace / 3),
                                    ],
                                  ),
                          ),
                        ),
                        const SizedBox(height: TSizes.defaultSpace / 2),
                      ],
                      Container(
                        padding: const EdgeInsets.all(12),
                        height: THelperFunctions.screenHeight(context) * 0.6,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Save address as *'),
                            const SizedBox(height: TSizes.defaultSpace / 2),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                buildChoiceChip(
                                  label: 'Home',
                                  unselectedIcon: Icons.home_outlined,
                                  selectedIcon: Icons
                                      .home_filled, // Different icon when selected
                                  isSelected: selectedAddressType == 'Home',
                                  onSelected: () {
                                    setState(() {
                                      selectedAddressType = 'Home';
                                    });
                                  },
                                ),
                                buildChoiceChip(
                                  label: 'Work',
                                  unselectedIcon: Icons.work_outline,
                                  selectedIcon: Icons
                                      .work_rounded, // Different icon when selected
                                  isSelected: selectedAddressType == 'Work',
                                  onSelected: () {
                                    setState(() {
                                      selectedAddressType = 'Work';
                                    });
                                  },
                                ),
                                buildChoiceChip(
                                  label: 'Other',
                                  unselectedIcon: Icons.location_on_outlined,
                                  selectedIcon: Icons
                                      .location_on, // Different icon when selected
                                  isSelected: selectedAddressType == 'Other',
                                  onSelected: () {
                                    setState(() {
                                      selectedAddressType = 'Other';
                                    });
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: TSizes.defaultSpace),
                            if (widget.addressModel == null) ...[
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: TColors.darkGrey),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: THelperFunctions.screenWidth(
                                              context) *
                                          0.65,
                                      child: Text(
                                        widget.selectedAddress!,
                                        maxLines: 4,
                                        overflow: TextOverflow.ellipsis,
                                        style: TTextTheme
                                            .lightTextTheme.displayLarge,
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const SizedBox(height: 7),
                                        GestureDetector(
                                          onTap: () => Get.back(),
                                          child: const Text(
                                            'Change',
                                            style:
                                                TextStyle(color: Colors.green),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                            const SizedBox(height: TSizes.defaultSpace),
                            TextFormField(
                              controller: houseNumberController,
                              decoration: const InputDecoration(
                                labelText: 'House number *',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your house number';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: TSizes.defaultSpace),
                            TextFormField(
                              controller: floorController,
                              decoration: const InputDecoration(
                                labelText: 'Floor',
                              ),
                            ),
                            const SizedBox(height: TSizes.defaultSpace),
                            TextFormField(
                              controller: towerController,
                              decoration: const InputDecoration(
                                labelText: 'Tower / Block ',
                              ),
                            ),
                            const SizedBox(height: TSizes.defaultSpace),
                            TextFormField(
                              controller: landmarkController,
                              decoration: const InputDecoration(
                                labelText: 'Nearby landmark (optional)',
                              ),
                            ),
                            const SizedBox(height: TSizes.defaultSpace),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: THelperFunctions.screenHeight(context) * 0.12,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Material(
                elevation: 2,
                child: Container(
                  padding: const EdgeInsets.only(top: 15, bottom: 15),
                  color: TColors.white,
                  child: Container(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: savedAddress,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              widget.addressModel == null
                                  ? 'Confirm Address'
                                  : 'Update Address',
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void savedAddress() async {
    if (formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      final userId = AuthService.instance.currentUser!.uid;

      bool isFirstAddress = await _fireStore.isFirstAddress(userId);

      AddressModel addressModel = AddressModel(
          id: '',
          recipientName: nameController.text,
          phoneNumber: phoneController.text.trim(),
          houseNumber: houseNumberController.text,
          addressType: selectedAddressType,
          streetAddress: widget.isCurrentAddress!
              ? widget.locationController!.currentStreet.value!
              : widget.locationController!.selectedStreet.value!,
          city: widget.isCurrentAddress!
              ? widget.locationController!.currentCity.value!
              : widget.locationController!.selectedCity.value!,
          landmark: landmarkController.text,
          postalCode: widget.isCurrentAddress!
              ? widget.locationController!.currentPostalCode.value!
              : widget.locationController!.selectedPostalCode.value!,
          towerOrBlock: towerController.text,
          state: widget.isCurrentAddress!
              ? widget.locationController!.currentState.value!
              : widget.locationController!.selectedState.value!,
          floor: floorController.text,
          isDefault: isFirstAddress);

      try {
        // Update Address
        if (widget.addressModel != null) {
          _fireStore.updateAddress(addressModel, userId, addressModel.id);

          Get.back();
          showSnackBar('Success', 'Address Updated Successfully');
        }
        // Add new Address
        else {
          _fireStore.addAddress(addressModel);

          if (isFirstAddress) {
            await _fireStore.updateDefaultAddress(
              userId,
              addressModel.id,
            );
          }

          Get.back();
          Get.back();
          showSnackBar('Success', 'Address Added Successfully');
        }
      } catch (e) {
        showSnackBar('Error', 'Failed to add address. Try again.',
            isError: true);
        setState(() => isLoading = false);
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  // Function to create a ChoiceChip with a different icon when selected
  Widget buildChoiceChip({
    required String label,
    required IconData unselectedIcon,
    required IconData selectedIcon,
    required bool isSelected,
    required VoidCallback onSelected,
  }) {
    return ChoiceChip(
      padding: const EdgeInsets.all(10),
      showCheckmark: false,
      selectedColor: Colors.green,
      label: Row(
        children: [
          Icon(
            isSelected ? selectedIcon : unselectedIcon, // Switch between icons
            color: isSelected ? Colors.white : Colors.black,
            size: 20,
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
                color: isSelected ? Colors.white : Colors.black, fontSize: 16),
          ),
        ],
      ),
      selected: isSelected,
      onSelected: (isSelected) {
        if (isSelected) onSelected();
      },
    );
  }
}
