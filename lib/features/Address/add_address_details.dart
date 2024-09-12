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
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  // UserModel? userModel;
  // final FirestoreService _firestoreService = FirestoreService();

  // @override
  // void initState(){
  //   super.initState();
  //   _fetchUserDetails();
  // }
  //
  // Future<void> _fetchUserDetails() async {
  //   final user = controller.currentUser!.uid;
  //   userModel = await _firestoreService.getUserDetails(user);
  // }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding:
            const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 20),
        height: THelperFunctions.screenHeight(context) * 0.8,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter complete address',
              style: TTextTheme.lightTextTheme.headlineMedium!,
              // style: ,
            ),
            const SizedBox(height: TSizes.defaultSpace / 2),
            Container(
              padding: const EdgeInsets.all(12),
              height: THelperFunctions.screenHeight(context) * 0.09,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Receiver details for this address',
                    style: TTextTheme.lightTextTheme.titleLarge,
                  ),
                  const SizedBox(height: TSizes.defaultSpace / 3),
                  Row(
                    children: [
                      const Icon(Icons.phone, size: 22),
                      const SizedBox(width: 10),
                      Text(
                        // '${userModel!.name}, ${userModel!.phoneNumber}',
                        'Anubhav Bindal, 8881284276',
                        style: TTextTheme.lightTextTheme.titleSmall,
                      ),
                      const Spacer(),
                      const Icon(Icons.arrow_forward_ios, size: 22),
                    ],
                  ),
                  const SizedBox(height: TSizes.defaultSpace / 3),
                ],
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
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ChoiceChip(
                        label: Row(
                          children: [
                            Icon(Icons.home_outlined),
                            SizedBox(width: 5),
                            Text('Home')
                          ],
                        ),
                        selected: true,
                      ),
                      ChoiceChip(
                        label: Row(
                          children: [
                            Icon(Icons.work_outline),
                            SizedBox(width: 5),
                            Text('Work')
                          ],
                        ),
                        selected: false,
                      ),
                      ChoiceChip(
                        label: Row(
                          children: [
                            Icon(Icons.location_on_outlined),
                            SizedBox(width: 5),
                            Text('Other')
                          ],
                        ),
                        selected: false,
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: THelperFunctions.screenWidth(context) * 0.6,
                          child: Text(
                            'Nekchand Tower, NEKCHAND TOWER, sahibzada Ajit Singh Nagar, Punjab, 140413',
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                            style: TTextTheme.lightTextTheme.displayLarge,
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () => Get.back(),
                          child: const Text('Change'),
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
                      labelText: 'Tower / Block *',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your tower / block';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: TSizes.defaultSpace),
                  TextFormField(
                    controller: landmarkController,
                    decoration: const InputDecoration(
                      labelText: 'Nearby landmark (optional)',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
