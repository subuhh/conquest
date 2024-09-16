import 'dart:async';
import 'dart:convert';
import 'package:conquest/common/widgets/divider_with_text.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../core/Controllers/location_service.dart';
import '../../core/api_key/google_api_key.dart';
import 'package:http/http.dart' as http;

import '../../utils/constants/sizes.dart';
import '../../utils/helpers/helper_functions.dart';
import '../../utils/theme/customthemes/textThemes.dart';

class SearchBottomSheet extends StatefulWidget {
  final Function(Map<String, dynamic>) onSuggestionSelected;

  const SearchBottomSheet({
    super.key,
    required this.onSuggestionSelected,
  });

  @override
  State<SearchBottomSheet> createState() => _SearchBottomSheetState();
}

class _SearchBottomSheetState extends State<SearchBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  final LocationController _locationController = Get.put(LocationController());
  final String _apiKey = googleMapApiKey; // Replace with your actual API key
  final String _sessionToken = "12345";
  final String _baseUrl =
      "https://maps.googleapis.com/maps/api/place/autocomplete/json";
  List<dynamic> _placeList = [];
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      getSuggestions(_searchController.text);
    });
  }

  Future<void> getSuggestions(String input) async {
    if (input.isEmpty) {
      setState(() {
        _placeList.clear();
      });
      return;
    }

    String request =
        '$_baseUrl?input=$input&key=$_apiKey&sessiontoken=$_sessionToken';
    var response = await http.get(Uri.parse(request));

    if (response.statusCode == 200) {
      setState(() {
        _placeList = jsonDecode(response.body)['predictions'];
      });
    } else {
      throw "Failed to fetch suggestions";
    }
  }

  void _onSuggestionSelected(Map<String, dynamic> suggestion) async {
    List<Location> locations =
        await locationFromAddress(suggestion['description']);
    double latitude = locations.first.latitude;
    double longitude = locations.first.longitude;

    // _locationController.currentPosition.value =

    widget.onSuggestionSelected({
      'latitude': latitude,
      'longitude': longitude,
      'address': suggestion['description'],
    });

    Get.back(); // Close the bottom sheet after selecting
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 20),
      height: THelperFunctions.screenHeight(context) * 0.7,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const SizedBox(height: TSizes.defaultSpace / 2),
          Text(
            'My Addresses',
            style: TTextTheme.lightTextTheme.headlineMedium!
                .copyWith(fontSize: 22),
            // style: ,
          ),
          const SizedBox(height: TSizes.defaultSpace),
          // Search TextField
          TextField(
            controller: _searchController,
            autofocus: true,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              filled: true,
              fillColor: Colors.white,
              hintText: 'Search for area, street name...',
              hintStyle:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              prefixIcon: Icon(
                Icons.search,
                size: 26,
                color: Colors.green[900],
              ),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Iconsax.close_circle, size: 26),
                      onPressed: () {
                        _searchController.clear();
                      },
                    )
                  : null,
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                borderSide: BorderSide(color: Colors.grey),
              ),
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                borderSide: BorderSide(color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(height: TSizes.defaultSpace),
          if (_searchController.text.isEmpty) ...[
            // Current Location Text
            const DividerWithText(title: 'CURRENT LOCATION'),
            const SizedBox(height: TSizes.defaultSpace),
            // Current List Tile
            ListTile(
              tileColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              leading: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.my_location,
                    size: 28,
                    color: Colors.green[900],
                  ),
                ],
              ),
              title: Text(
                _locationController.currentStreet.value!,
                style: TTextTheme.lightTextTheme.headlineSmall!
                    .copyWith(fontSize: 18),
              ),
              subtitle: Text(
                _locationController.currentAddress.value!,
                style: TTextTheme.lightTextTheme.headlineSmall!.copyWith(
                  fontSize: 14,
                  color: Colors.black.withOpacity(0.7),
                ),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 26,
              ),
            ),
            // Recent Locations
            if (_locationController.selectedAddress.value!.isNotEmpty) ...[
              const SizedBox(height: TSizes.defaultSpace),
              const DividerWithText(title: 'RECENT LOCATION'),
              const SizedBox(height: TSizes.defaultSpace),
              // Current List Tile
              ListTile(
                tileColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.schedule,
                      size: 28,
                      color: Colors.green[900],
                    ),
                  ],
                ),
                title: Text(
                  _locationController.selectedStreet.value!,
                  style: TTextTheme.lightTextTheme.headlineSmall!
                      .copyWith(fontSize: 18),
                ),
                subtitle: Text(
                  _locationController.selectedAddress.value!,
                  style: TTextTheme.lightTextTheme.headlineSmall!.copyWith(
                    fontSize: 14,
                    color: Colors.black.withOpacity(0.7),
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 26,
                ),
              ),
            ]
          ],
          if (_searchController.text.isNotEmpty) ...[
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 10);
                },
                itemCount: _placeList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    tileColor: Colors.white,
                    onTap: () => _onSuggestionSelected(_placeList[index]),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    title: Text(
                      _placeList[index]['structured_formatting']['main_text'],
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      _placeList[index]['description'],
                      style: const TextStyle(fontSize: 15),
                    ),
                    leading: const Icon(Icons.location_on_outlined),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}
