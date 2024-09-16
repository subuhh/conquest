import 'package:conquest/core/Controllers/location_service.dart';
import 'package:conquest/core/model/address.dart';
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
  final String selectedAddress;
  final String userName;
  final String phoneNumber;
  final String userId;
  final bool isCurrentAddress;
  final LocationController locationController;

  const AddAddressDetails({
    super.key,
    required this.selectedAddress,
    required this.userName,
    required this.phoneNumber,
    required this.isCurrentAddress,
    required this.locationController,
    required this.userId,
  });

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
    nameController.text = widget.userName;
    phoneController.text = widget.phoneNumber;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SizedBox(
        height: THelperFunctions.screenHeight(context) * 0.82,
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
                      Text(
                        'Enter complete address',
                        style: TTextTheme.lightTextTheme.headlineMedium!
                            .copyWith(fontSize: 22),
                        // style: ,
                      ),
                      const SizedBox(height: TSizes.defaultSpace / 2),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isEditingReceiverDetails = true;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          height: isEditingReceiverDetails
                              ? THelperFunctions.screenHeight(context) * 0.17
                              : THelperFunctions.screenHeight(context) * 0.09,
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
                                        prefixIcon: const Icon(Iconsax.direct),
                                        suffixIcon: IconButton(
                                          onPressed: () {
                                            nameController.clear();
                                          },
                                          icon: const Icon(Iconsax.close_circle),
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
                                          icon: const Icon(Iconsax.close_circle),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Receiver details for this address',
                                      style: TTextTheme.lightTextTheme.titleLarge,
                                    ),
                                    const SizedBox(
                                        height: TSizes.defaultSpace / 3),
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
                                ChoiceChip(
                                  padding: const EdgeInsets.all(10),
                                  showCheckmark: false,
                                  selectedColor: Colors.green,
                                  label: const Row(
                                    children: [
                                      Icon(Icons.home_outlined),
                                      SizedBox(width: 5),
                                      Text('Home')
                                    ],
                                  ),
                                  selected: selectedAddressType == 'Home',
                                  onSelected: (isSelected) {
                                    setState(() {
                                      selectedAddressType = 'Home';
                                    });
                                  },
                                ),
                                ChoiceChip(
                                  padding: const EdgeInsets.all(10),
                                  showCheckmark: false,
                                  label: const Row(
                                    children: [
                                      Icon(Icons.work_outline),
                                      SizedBox(width: 5),
                                      Text('Work')
                                    ],
                                  ),
                                  selected: selectedAddressType == 'Work',
                                  onSelected: (isSelected) {
                                    setState(() {
                                      selectedAddressType = 'Work';
                                    });
                                  },
                                ),
                                ChoiceChip(
                                  padding: const EdgeInsets.all(10),
                                  showCheckmark: false,
                                  label: const Row(
                                    children: [
                                      Icon(Icons.location_on_outlined),
                                      SizedBox(width: 5),
                                      Text('Other')
                                    ],
                                  ),
                                  selected: selectedAddressType == 'Other',
                                  onSelected: (isSelected) {
                                    setState(() {
                                      selectedAddressType = 'Other';
                                    });
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: TSizes.defaultSpace),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: TColors.darkGrey),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width:
                                        THelperFunctions.screenWidth(context) *
                                            0.65,
                                    child: Text(
                                      widget.selectedAddress,
                                      maxLines: 4,
                                      overflow: TextOverflow.ellipsis,
                                      style: TTextTheme
                                          .lightTextTheme.displayLarge,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () => Get.back(),
                                    child: const Text(
                                      'Change',
                                      style: TextStyle(color: Colors.green),
                                    ),
                                  )
                                ],
                              ),
                            ),
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
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          setState(() => isLoading = true);
                          try {
                            bool isFirstAddress =
                                await _fireStore.isFirstAddress(widget.userId);

                            AddressModel addressModel = AddressModel(
                                id: '',
                                recipientName: nameController.text,
                                phoneNumber: phoneController.text.trim(),
                                houseNumber: houseNumberController.text,
                                addressType: selectedAddressType,
                                streetAddress: widget.isCurrentAddress
                                    ? widget
                                        .locationController.currentStreet.value!
                                    : widget.locationController.selectedStreet
                                        .value!,
                                city: widget.isCurrentAddress
                                    ? widget
                                        .locationController.currentCity.value!
                                    : widget
                                        .locationController.selectedCity.value!,
                                postalCode: widget.isCurrentAddress
                                    ? widget.locationController
                                        .currentPostalCode.value!
                                    : widget.locationController
                                        .selectedPostalCode.value!,
                                state: widget.isCurrentAddress
                                    ? widget
                                        .locationController.currentState.value!
                                    : widget.locationController.selectedState
                                        .value!,
                                isDefault: isFirstAddress);

                            _fireStore.addAddress(addressModel);

                            if (isFirstAddress) {
                              await _fireStore.updateDefaultAddress(
                                widget.userId,
                                addressModel.id,
                              );
                            }

                            setState(() => isLoading = false);
                            Get.back();
                            Get.back();
                          } catch (e) {
                            showSnackBar(
                                'Error', 'Failed to add address. Try again.',
                                isError: true);
                          } finally {
                            setState(() => isLoading = false);
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : const Text('Confirm Address'),
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
}
