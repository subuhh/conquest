import 'dart:io';
import 'package:conquest/common/widgets/custom_snackbar.dart';
import 'package:conquest/core/model/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/Controllers/community_controller/community_controller.dart';

class CommunityProfileEdit extends StatefulWidget {
  final UserModel userModel;

  const CommunityProfileEdit({super.key, required this.userModel});

  @override
  _CommunityProfileEditState createState() => _CommunityProfileEditState();
}

class _CommunityProfileEditState extends State<CommunityProfileEdit> {
  final CommunityController _communityController = CommunityController.instance;

  // Form controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  // Loading state
  bool _isLoading = false;

  // Change detection state
  bool _isChanged = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.userModel.name;
    _usernameController.text = widget.userModel.userName;
    _bioController.text = widget.userModel.bio ?? '';

    _communityController.profileImageUrl.value =
        widget.userModel.profileImageUrl ?? '';
    _communityController.bannerImageUrl.value =
        widget.userModel.bannerImageUrl ?? '';

    // Attach listeners
    _nameController.addListener(_checkForChanges);
    _usernameController.addListener(_checkForChanges);
    _bioController.addListener(_checkForChanges);

    _communityController.profileImageUrl.listen((_) => _checkForChanges());
    _communityController.bannerImageUrl.listen((_) => _checkForChanges());
  }

  @override
  void dispose() {
    _nameController.removeListener(_checkForChanges);
    _usernameController.removeListener(_checkForChanges);
    _bioController.removeListener(_checkForChanges);

    _nameController.dispose();
    _usernameController.dispose();
    _bioController.dispose();

    super.dispose();
  }

  // Check if any field has changed
  void _checkForChanges() {
    if (!mounted) return; // Avoid calling setState if the widget is not active

    final initialProfileImage = widget.userModel.profileImageUrl ?? '';
    final initialBannerImage = widget.userModel.bannerImageUrl ?? '';

    setState(() {
      _isChanged = _nameController.text != widget.userModel.name ||
          _usernameController.text != widget.userModel.userName ||
          _bioController.text != (widget.userModel.bio ?? '') ||
          _communityController.profileImageUrl.value != initialProfileImage ||
          _communityController.bannerImageUrl.value != initialBannerImage;
    });
  }

  // Submit the form to update profile
  Future<void> _submitProfileUpdate() async {
    if (_nameController.text.isNotEmpty &&
        _usernameController.text.isNotEmpty) {
      setState(() => _isLoading = true);

      final updatedUser = widget.userModel.copyWith(
        name: _nameController.text,
        userName: _usernameController.text,
        bio: _bioController.text,
      );

      final success =
          await _communityController.updateUserProfileWithImages(updatedUser);

      setState(() => _isLoading = false);

      if (success) {
        showSnackBar('Success', 'Profile updated successfully');
        // Navigator.replace(context, oldRoute: oldRoute, newRoute: newRoute)
        // Get.off(() => CommunityProfileScreen(userId: updatedUser.id));
        Navigator.pop(context, updatedUser);
      } else {
        showSnackBar('Error', 'Failed to update profile');
      }
    } else {
      Get.snackbar('Error', 'Name and Username are required');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Profile', style: GoogleFonts.poppins())),
      body: LayoutBuilder(builder: (context, constraints) {
        final height = constraints.maxHeight;
        final width = constraints.maxWidth;

        return SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                children: [
                  GestureDetector(
                    onTap: () =>
                        _communityController.pickImage(isProfile: false),
                    child: Obx(
                      () => Container(
                        height: height * 0.25,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          image: _communityController
                                  .bannerImageUrl.value.isNotEmpty
                              ? DecorationImage(
                                  image: _communityController
                                          .bannerImageUrl.value
                                          .startsWith('http')
                                      ? NetworkImage(_communityController
                                          .bannerImageUrl.value)
                                      : FileImage(File(_communityController
                                          .bannerImageUrl
                                          .value)) as ImageProvider,
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: height * 0.25 / 2 - 15),
                            TextField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                labelText: 'Full Name',
                                prefixIcon: Icon(Iconsax.user),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              readOnly: true,
                              controller: _usernameController,
                              decoration: const InputDecoration(
                                labelText: 'UserName',
                                prefixIcon: Icon(Iconsax.user_edit),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              style: TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: _bioController,
                              keyboardType: TextInputType.multiline,
                              decoration: const InputDecoration(
                                labelText: 'Bio',
                                prefixIcon: Icon(Icons.info_outline),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // User Profile Image
              Positioned(
                top: height * 0.25 - 110,
                left: width * 0.5 - (width * 0.22),
                child: GestureDetector(
                  onTap: () => _communityController.pickImage(isProfile: true),
                  child: Obx(
                    () => Container(
                      height: height * 0.22,
                      width: width * 0.45,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 10),
                      ),
                      child: CircleAvatar(
                        backgroundColor: Colors.grey[200],
                        backgroundImage: _communityController
                                .profileImageUrl.value.isNotEmpty
                            ? _communityController.profileImageUrl.value
                                    .startsWith('http')
                                ? NetworkImage(
                                    _communityController.profileImageUrl.value)
                                : FileImage(File(_communityController
                                    .profileImageUrl.value)) as ImageProvider
                            : null,
                        child:
                            _communityController.profileImageUrl.value.isEmpty
                                ? Icon(
                                    Icons.person,
                                    size: height * 0.1,
                                    color: Colors.grey,
                                  )
                                : null,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: ElevatedButton(
          onPressed: _isLoading || !_isChanged ? null : _submitProfileUpdate,
          style: ElevatedButton.styleFrom(
            backgroundColor: _isChanged ? Colors.red : Colors.grey,
            padding: EdgeInsets.zero,
          ),
          child: _isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text('Save Changes'),
        ),
      ),
    );
  }
}
