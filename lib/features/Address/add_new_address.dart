import 'dart:developer';
import 'package:conquest/features/Address/add_address_details.dart';
import 'package:conquest/features/Address/search_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../core/Controllers/location_service.dart';
import '../../core/model/user.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/firestore_service.dart';
import '../../utils/Shimmer/shimmer.dart';
import '../../utils/constants/colors.dart';
import '../../utils/theme/customthemes/textThemes.dart';

class AddNewAddress extends StatefulWidget {
  const AddNewAddress({
    super.key,
  });

  @override
  State<AddNewAddress> createState() => _AddNewAddressState();
}

class _AddNewAddressState extends State<AddNewAddress> {
  CameraPosition? _cameraPosition;
  GoogleMapController? _mapController;

  UserModel? userModel;
  final FirestoreService _firestoreService = FirestoreService();
  final controller = Get.put(AuthService());

  final _locationController = Get.find<LocationController>();

  bool isFetchingAddress = false;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  void _onCameraIdle() async {
    if (_cameraPosition != null) {
      setState(() {
        isFetchingAddress = true;
      });
      // Fetch address based on the new camera position
      await _locationController.getAddressFromLatLng(
        _cameraPosition!.target.latitude,
        _cameraPosition!.target.longitude,
      );
      setState(() {
        isFetchingAddress = false;
      });
    }
  }

  void _handleSuggestionSelected(Map<String, dynamic> suggestion) {
    double latitude = suggestion['latitude'];
    double longitude = suggestion['longitude'];
    // String address = suggestion['address'];

    setState(() {
      _cameraPosition = CameraPosition(
        target: LatLng(latitude, longitude),
        zoom: 17.5,
      );

      _locationController.selectedAddress.value = suggestion['address'];
      _locationController.setSelectedAddress(latitude, longitude);
      // _locationController.currentAddressLocality.value = suggestion['address'];
    });

    // If you have a map controller, animate the camera
    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(_cameraPosition!),
    );
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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Confirm Delivery Location',
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          if (_locationController.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.green,
              ),
            );
          }
          return Column(
            children: [
              // Map
              Stack(
                children: [
                  // Map
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.62,
                    child: GoogleMap(
                      mapType: MapType.normal,
                      initialCameraPosition: _cameraPosition ??
                          CameraPosition(
                            target: LatLng(
                                _locationController
                                        .currentPosition.value?.latitude ??
                                    0,
                                _locationController
                                        .currentPosition.value?.longitude ??
                                    0),
                            zoom: 17.5,
                          ),
                      zoomControlsEnabled: false,
                      myLocationEnabled: false,
                      onCameraMove: (position) {
                        _cameraPosition = position;
                      },
                      onCameraIdle: _onCameraIdle,
                      onMapCreated: (GoogleMapController controller) {
                        // Set up the map controller
                        _mapController = controller;
                      },
                    ),
                  ),
                  // Search TextField
                  Positioned(
                    top: 10,
                    left: 15,
                    right: 15,
                    child: TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Search for area, street name...',
                        hintStyle: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                        prefixIcon: Icon(
                          Icons.search,
                          size: 26,
                          color: Colors.green[900],
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                      onTap: () {
                        showModalBottomSheet(
                          backgroundColor: TColors.softGrey,
                          isScrollControlled: true,
                          enableDrag: false,
                          context: context,
                          builder: (BuildContext context) {
                            return SearchBottomSheet(
                              onSuggestionSelected: _handleSuggestionSelected,
                            );
                          },
                        );
                      },
                    ),
                  ),

                  // Location Button
                  Positioned(
                    bottom: 16,
                    left: MediaQuery.of(context).size.width / 3 - 22,
                    child: OutlinedButton(
                      onPressed: () {
                        // Center map to current location
                        if (_locationController.currentPosition.value != null) {
                          final position =
                              _locationController.currentPosition.value!;
                          final newCameraPosition = CameraPosition(
                              target:
                                  LatLng(position.latitude, position.longitude),
                              zoom: 17.5);
                          _mapController?.animateCamera(
                              CameraUpdate.newCameraPosition(
                                  newCameraPosition));
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(12),
                          ),
                          side: BorderSide(color: Colors.green),
                        ),
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          children: [
                            Icon(Icons.my_location, color: Colors.green[900]),
                            const SizedBox(width: 10),
                            Text(
                              'Use current location',
                              style: TextStyle(color: Colors.green[900]),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Location Pin
                  Positioned(
                    top: MediaQuery.of(context).size.width / 1.5 + 10,
                    left: MediaQuery.of(context).size.width / 2 - 10,
                    child: SizedBox(
                      width: 35,
                      height: 35,
                      child:
                          // Image.asset('assets/images/location-icon-removebg-preview.png')
                          SvgPicture.asset(
                        'assets/icons/appicons/location-pin.svg',
                      ),
                    ),
                  )
                ],
              ),

              // Text
              const Padding(
                padding: EdgeInsets.only(left: 15, top: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'DELIVERING YOUR ORDER TO',
                    style: TextStyle(fontSize: 14, color: Colors.blue),
                  ),
                ),
              ),

              // Icon, Live Location, Change Button
              ListTile(
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 30,
                      color: Colors.green[900],
                    ),
                  ],
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: isFetchingAddress
                          ? TShimmer.singleContainer(20)
                          : Text(
                              _locationController.selectedAddress.value!.isEmpty
                                  ? _locationController.currentCity.value!
                                  : _locationController.selectedCity.value!,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TTextTheme.lightTextTheme.headlineSmall!
                                  .copyWith(fontSize: 18),
                            ),
                    ),
                    TextButton(
                      onPressed: () {
                        showModalBottomSheet(
                          backgroundColor: TColors.softGrey,
                          isScrollControlled: true,
                          context: context,
                          enableDrag: false,
                          builder: (BuildContext context) {
                            return SearchBottomSheet(
                              onSuggestionSelected: _handleSuggestionSelected,
                            );
                          },
                        );
                      },
                      child: Text(
                        'CHANGE',
                        style: TTextTheme.lightTextTheme.titleLarge!
                            .copyWith(color: Colors.green[900], fontSize: 14),
                      ),
                    ),
                  ],
                ),
                subtitle: isFetchingAddress
                    ? TShimmer.singleContainer(50)
                    : Text(
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        _locationController.selectedAddress.value!.isEmpty
                            ? _locationController.currentAddress.value!
                            : _locationController.selectedAddress.value!,
                        style: TTextTheme.lightTextTheme.headlineSmall!
                            .copyWith(fontSize: 16),
                      ),
              )
            ],
          );
        }),
      ),

      // Bottom Elevated Button
      bottomNavigationBar: Material(
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: GestureDetector(
            onTap: () {
              showModalBottomSheet(
                backgroundColor: TColors.softGrey,
                isScrollControlled: true,
                enableDrag: false,
                context: context,
                builder: (BuildContext context) {
                  return AddAddressDetails(
                    selectedAddress:
                        _locationController.selectedAddress.value!.isEmpty
                            ? _locationController.currentAddress.value!
                            : _locationController.selectedAddress.value!,
                    phoneNumber: userModel!.phoneNumber,
                    userName: userModel!.name,
                    isCurrentAddress:
                        _locationController.selectedAddress.value!.isEmpty,
                    locationController: _locationController,
                  );
                },
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.green[900],
                borderRadius: const BorderRadius.all(Radius.circular(12)),
              ),
              height: 55,
              width: double.infinity,
              alignment: Alignment.center,
              child: const Text(
                'Add more address details',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
