import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'dart:developer';
import '../../common/widgets/custom_snackbar.dart';

class LocationController extends GetxController {
  var isLoading = false.obs; // For managing loading state
  var currentPosition = Rxn<Position>(); // To store the user's current position
  var currentAddress = Rxn<String>(); // To store the user's current position
  // var currentAddressLocality = Rxn<String>();
  var currentStreet = Rxn<String>();
  var currentCity = Rxn<String>();
  var currentPostalCode = Rxn<String>();
  var currentState = Rxn<String>();

  var selectedAddress = Rxn<String>('');
  var selectedStreet = Rxn<String>('');
  var selectedCity = Rxn<String>('');
  var selectedPostalCode = Rxn<String>('');
  var selectedState = Rxn<String>('');

  // Global permission status
  var locationPermissionGranted = false.obs;

  void onInit() {
    super.onInit();
    fetchLocation();
  }

  // Method to check and request location permissions
  Future<bool> checkLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showSnackBar('Location Services Disabled',
          'Please enable location services to proceed.',
          isError: true);
      return false;
    }

    // Check and request location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showSnackBar('Permission Denied',
            'Location permission is denied. Please allow location access in settings.',
            actionLabel: 'Settings',
            onAction: Geolocator.openAppSettings,
            isError: true);
        return false;
      }
    }

    // Handle permanently denied location permissions
    if (permission == LocationPermission.deniedForever) {
      showSnackBar('Permission Denied',
          'Location permissions are permanently denied. Please enable them in settings.',
          actionLabel: 'Settings',
          onAction: Geolocator.openAppSettings,
          isError: true);
      return false;
    }

    // If permissions are granted
    locationPermissionGranted.value = true;
    return true;
  }

  // Function to fetch user's current location
  Future<bool> fetchLocation() async {
    isLoading.value = true; // Start loading

    try {
      // Check location permissions
      bool permissionGranted = await checkLocationPermission();
      if (!permissionGranted) {
        isLoading.value = false;
        return false;
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
      return true;
    } catch (e) {
      showSnackBar('Error', 'Unable to fetch location. Please try again later.',
          isError: true);
      log('Failed to get current location. Please Try Again.');
      return false;
    } finally {
      isLoading.value = false; // Stop loading
    }
  }

  // Function to get user address from Lat and Lang
  Future<void> getAddressFromLatLng(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      Placemark place = placemarks[0];
      String formattedAddress =
          "${place.street}, ${place.locality}, ${place.subAdministrativeArea}, ${place.administrativeArea}";

      // Update the current address
      currentAddress.value = formattedAddress;
      currentCity.value = place.locality;
      currentPostalCode.value = place.postalCode;
      currentStreet.value = place.street;
      currentState.value = place.subAdministrativeArea;
      log('Address: $formattedAddress');
    } catch (e) {
      showSnackBar('Error', 'Unable to fetch address. Please try again later.',
          isError: true);
      log('Failed to get address from coordinates: $e');
    }
  }

  // Handle when an address is selected from suggestions
  Future<void> setSelectedAddress(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];

        selectedAddress.value =
            "${place.street}, ${place.locality}, ${place.administrativeArea}";
        selectedCity.value = place.locality;
        selectedPostalCode.value = place.postalCode;
        selectedStreet.value = place.street;
        selectedState.value = place.subAdministrativeArea;
        log('Selected Address: ${selectedAddress.value}');
      }
    } catch (e) {
      showSnackBar('Error',
          'Failed to get address from coordinates. Please try again later.',
          isError: true);
    }
  }
}
