import 'dart:developer';

import 'package:conquest/features/Address/add_address_details.dart';
import 'package:conquest/features/Address/search_bottom_sheet.dart';
import 'package:conquest/features/utils/constants/colors.dart';
import 'package:conquest/features/utils/theme/customthemes/textThemes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../core/Controllers/location_service.dart';
import '../../core/model/user.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/firestore_service.dart';

class AddNewAddress extends StatefulWidget {
  const AddNewAddress({super.key});

  @override
  State<AddNewAddress> createState() => _AddNewAddressState();
}

class _AddNewAddressState extends State<AddNewAddress> {
  CameraPosition? _cameraPosition;
  Marker? _marker;
  GoogleMapController? _mapController;

  UserModel? userModel;
  final FirestoreService _firestoreService = FirestoreService();
  final controller = Get.put(AuthService());

  final LocationController _locationController =
      Get.put(LocationController()); // GetX location controller

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  void _handleSuggestionSelected(Map<String, dynamic> suggestion) {
    double latitude = suggestion['latitude'];
    double longitude = suggestion['longitude'];
    // String address = suggestion['address'];

    setState(() {
      _cameraPosition = CameraPosition(
        target: LatLng(latitude, longitude), zoom: 15,
        // zoom: 14.4743,
      );

      _marker = Marker(
        markerId: const MarkerId('selected_location'),
        position: LatLng(latitude, longitude),
        infoWindow: const InfoWindow(title: 'Selected Location'),
        draggable: true,
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

  // Called when the user drags the marker and releases it
  void _onMarkerDragged(LatLng position) {
    _locationController.getAddressFromLatLng(
        position.latitude, position.longitude);
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
                  SizedBox(
                    height: _locationController.selectedAddress.value == null ||
                            _locationController
                                .selectedAddress.value!.isNotEmpty
                        ? MediaQuery.of(context).size.height * 0.69
                        : MediaQuery.of(context).size.height * 0.66,
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
                            zoom: 14.4743,
                          ),
                      zoomControlsEnabled: false,
                      myLocationEnabled: false,
                      markers: {
                        _marker ??
                            Marker(
                              markerId: const MarkerId('live_location'),
                              position: LatLng(
                                  _locationController
                                          .currentPosition.value?.latitude ??
                                      0,
                                  _locationController
                                          .currentPosition.value?.longitude ??
                                      0),
                              infoWindow:
                                  const InfoWindow(title: 'Live Location'),
                              draggable: true,
                              onDragEnd: _onMarkerDragged,
                            )
                      },
                      onMapCreated: (GoogleMapController controller) {
                        // Set up the map controller
                        _mapController = controller;
                      },
                    ),
                  ),
                  // TextField
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
                              zoom: 14.4743);
                          _mapController?.animateCamera(
                              CameraUpdate.newCameraPosition(
                                  newCameraPosition));
                          setState(() {
                            _marker = Marker(
                              markerId: const MarkerId('live_location'),
                              position:
                                  LatLng(position.latitude, position.longitude),
                              infoWindow:
                                  const InfoWindow(title: 'Live Location'),
                              draggable: true,
                            );
                          });
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
                ],
              ),

              // Text
              const Padding(
                padding: EdgeInsets.only(left: 15, top: 15),
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
                      child: Text(
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
                subtitle: Text(
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
