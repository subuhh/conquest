import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'dart:developer';
import '../../common/widgets/custom_snackbar.dart';

class LocationController extends GetxController {
  var currentPosition = Rxn<Position>(); // To store the user's current position
  var currentAddress = Rxn<String>(); // To store the user's current position
  var selectedAddress = Rxn<String>('');
  var currentAddressLocality = Rxn<String>();
  var isLoading = false.obs; // For managing loading state

  @override
  void onInit() {
    super.onInit();
    fetchLocation(); // Fetch location when the app starts
  }

  // Function to fetch user's current location
  Future<void> fetchLocation() async {
    isLoading.value = true; // Start loading
    bool serviceEnabled;
    LocationPermission permission;

    try {
      // Check if location services are enabled
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        showSnackBar('Error', 'Location services are not enabled.');
        isLoading.value = false;
        return;
      }

      // Check and request location permissions
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          showSnackBar('Error', 'Location permission denied.');
          isLoading.value = false;
          return;
        }
      }

      // Handle permanently denied location permissions
      if (permission == LocationPermission.deniedForever) {
        showSnackBar('Error', 'Location permissions are permanently denied.');
        isLoading.value = false;
        return;
      }

      // Get the current position of the device
      Position position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.bestForNavigation));

      // Store the current position in reactive variable
      currentPosition.value = position;
      log('Current Location: ${position.latitude}, ${position.longitude}');

      // Fetch the address from the current coordinates
      await getAddressFromLatLng(position.latitude, position.longitude);
    } catch (e) {
      showSnackBar('Error', 'Failed to get current location: $e');
      log('Failed to get current location. Please Try Again.');
    } finally {
      isLoading.value = false; // Stop loading
    }
  }

  // Function to get user address from Lat and Lang
  // Function to get user address from Lat and Lang
  Future<void> getAddressFromLatLng(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      Placemark place = placemarks[0];
      String formattedAddress =
          "${place.street}, ${place.locality}, ${place.subAdministrativeArea}, ${place.administrativeArea}";

      // Update the current address
      currentAddress.value = formattedAddress;
      currentAddressLocality.value = place.locality;
      log('Address: $formattedAddress');
    } catch (e) {
      showSnackBar('Error', 'Failed to get address from coordinates: $e');
      log('Failed to get address from coordinates: $e');
    }
  }
}
