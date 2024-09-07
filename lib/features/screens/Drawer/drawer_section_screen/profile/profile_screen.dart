import 'dart:developer';
import 'package:conquest/common/widgets/custom_snackbar.dart';
import 'package:conquest/features/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../core/model/user.dart';
import '../../../../../core/services/auth_service.dart';
import '../../../../../core/services/firestore_service.dart';
import '../../../../utils/constants/text_strings.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _userNameController;
  late TextEditingController _phoneController;
  late TextEditingController _bioController;
  String? _selectedGender;
  UserModel? _userModel;
  bool _isEdited = false;

  // final List<int> heightOptionsCm = List.generate(250, (index) => index + 50);
  // final List<String> heightOptionsFtIn = [
  //   "4'0\"", "4'1\"", "4'2\"", "4'3\"", "4'4\"", "4'5\"", "4'6\"", "4'7\"", "4'8\"", "4'9\"",
  //   "4'10\"", "4'11\"", "5'0\"", "5'1\"", "5'2\"", "5'3\"", "5'4\"", "5'5\"", "5'6\"", "5'7\"",
  //   "5'8\"", "5'9\"", "5'10\"", "5'11\"", "6'0\"", "6'1\"", "6'2\"", "6'3\"", "6'4\"", "6'5\"",
  //   "6'6\"", "6'7\"", "6'8\"", "6'9\"", "6'10\"", "6'11\"", "7'0\""
  // ];
  //
  // final List<int> weightOptionsKg = List.generate(200, (index) => index + 20);
  // final List<int> weightOptionsLb = [
  //   40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 100,
  //   105, 110, 115, 120, 125, 130, 135, 140, 145, 150, 155, 160,
  //   165, 170, 175, 180, 185, 190, 195, 200, 205, 210, 215, 220,
  //   225, 230, 235, 240, 245, 250, 255, 260, 265, 270, 275, 280,
  //   285, 290, 295, 300, 305, 310, 315, 320, 325, 330, 335, 340,
  //   345, 350, 355, 360, 365, 370, 375, 380, 385, 390, 395, 400
  // ];
  //
  // int _selectedHeight = 170;
  // String _selectedHeightUnit = 'cm';
  // int _selectedWeight = 60;
  // String _selectedWeightUnit = 'kg';

  bool _isLoading = true;
  final FirestoreService _firestoreService = FirestoreService();
  final AuthService _auth = AuthService();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        UserModel? userModel = await _firestoreService.getUserDetails(user.uid);
        if (userModel != null) {
          setState(() {
            _userModel = userModel;
            _nameController = TextEditingController(text: userModel.name)
              ..addListener(_checkIfEdited);
            _userNameController =
                TextEditingController(text: userModel.userName)
                  ..addListener(_checkIfEdited);
            _emailController = TextEditingController(text: userModel.email)
              ..addListener(_checkIfEdited);
            _phoneController =
                TextEditingController(text: userModel.phoneNumber)
                  ..addListener(_checkIfEdited);
            _bioController = TextEditingController(text: userModel.bio)
              ..addListener(_checkIfEdited);
            _selectedGender = userModel.gender;
            _isLoading = false; // Data loaded, stop the loading state
          });
        }
      }
    } catch (e) {
      // Handle errors here (e.g., show error message)
      log('Error fetching user data: $e');
    }
  }

  void _checkIfEdited() {
    bool isEdited = _nameController.text != _userModel?.name ||
        _emailController.text != _userModel?.email ||
        _phoneController.text != _userModel?.phoneNumber ||
        _userNameController.text != _userModel?.userName ||
        _bioController.text != _userModel?.bio ||
        _selectedGender != _userModel?.gender;
    if (isEdited != _isEdited) {
      setState(() {
        _isEdited = isEdited;
      });
    }
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // UserModel? latestUserData =
        //     await _firestoreService.getUserDetails(_userModel!.id);

        UserModel updatedUser = UserModel(
          id: _userModel!.id,
          name: _nameController.text,
          email: _emailController.text,
          phoneNumber: _phoneController.text,
          userName: _userNameController.text,
          gender: _selectedGender,
          bio: _bioController.text,
        );

        await _firestoreService.updateUserDetails(updatedUser);

        showSnackBar(context, 'Profile updated successfully');
        Navigator.pop(context, updatedUser);
      } catch (e) {
        showSnackBar(context, 'Failed to update profile');
        log('$e');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildProfilePicture() {
    return Center(
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          // Profile Picture (CircleAvatar)
          Stack(
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: TColors.primary,
                child: Text(
                    _nameController.text.isNotEmpty
                        ? _nameController.text[0].toUpperCase()
                        : '',
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge!
                        .copyWith(color: Colors.white)),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: CircleAvatar(
                  radius: 21,
                  backgroundColor: Colors.black,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white,
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(Iconsax.edit),
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Profile',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
      backgroundColor: TColors.primaryBackground,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Stack(
          children: [
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  _buildProfilePicture(), // Profile Picture
                                  const SizedBox(height: 20),
                                  // First Name
                                  TextFormField(
                                    decoration: const InputDecoration(
                                      labelText: 'Full Name',
                                      prefixIcon: Icon(Iconsax.user),
                                    ),
                                    controller: _nameController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your Full Name';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 20),
                                  TextFormField(
                                    controller: _userNameController,
                                    decoration: const InputDecoration(
                                      labelText: 'UserName',
                                      prefixIcon: Icon(Iconsax.user_edit),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your Username';
                                      }
                                      // Validate for allowed characters
                                      if (!RegExp(r'^[a-zA-Z0-9_]+$')
                                          .hasMatch(value)) {
                                        return 'Only alphabets, numbers, and underscores are allowed';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 20),
                                  // Email (non-editable)
                                  TextFormField(
                                    controller: _emailController,
                                    decoration: const InputDecoration(
                                        prefixIcon: Icon(Iconsax.direct_right),
                                        labelText: TTexts.email),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your Email';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 20),
                                  // Phone Number
                                  TextFormField(
                                    controller: _phoneController,
                                    decoration: const InputDecoration(
                                      labelText: 'Phone no.',
                                      prefixIcon: Icon(Iconsax.call),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter a Phone Number'; // Allows empty input
                                      } else if (!RegExp(r'^[6-9]\d{9}$')
                                          .hasMatch(value)) {
                                        return 'Please enter a valid Phone Number';
                                      }
                                      return null; // Valid input
                                    },
                                  ),
                                  const SizedBox(height: 20),
                                  TextFormField(
                                    decoration: const InputDecoration(
                                      labelText: 'Bio',
                                      prefixIcon: Icon(Icons.info_outline),
                                    ),
                                    controller: _bioController,
                                    keyboardType: TextInputType.multiline,
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16.0),
                        child: ElevatedButton(
                          onPressed: _isEdited ? _updateProfile : () {},
                          child: _isLoading
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  'Save Changes',
                                ),
                        ),
                      ),
                    ],
                  ),
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }

  DropdownMenuItem<String> customDropdownItem(String value) => DropdownMenuItem(
        value: value,
        child: Text(
          value,
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(fontWeight: FontWeight.w600),
        ),
      );
}
