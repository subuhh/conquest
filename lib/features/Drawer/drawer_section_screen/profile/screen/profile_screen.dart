import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:conquest/features/utils/constants/colors.dart';
import '../../../../utils/constants/text_strings.dart';
import '../controller/profile_controller.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.put(ProfileController());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Profile',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
      backgroundColor: TColors.primaryBackground,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Form(
                          key: GlobalKey<FormState>(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              _buildProfilePicture(
                                  controller), // Profile Picture
                              const SizedBox(height: 20),
                              // Full Name
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Full Name',
                                  prefixIcon: Icon(Iconsax.user),
                                ),
                                controller: controller.nameController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your Full Name';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: controller.userNameController,
                                decoration: const InputDecoration(
                                  labelText: 'UserName',
                                  prefixIcon: Icon(Iconsax.user_edit),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your Username';
                                  }
                                  if (!RegExp(r'^[a-zA-Z0-9_]+$')
                                      .hasMatch(value)) {
                                    return 'Only alphabets, numbers, and underscores are allowed';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: controller.emailController,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Iconsax.direct_right),
                                  labelText: TTexts.email,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your Email';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: controller.phoneController,
                                decoration: const InputDecoration(
                                  labelText: 'Phone no.',
                                  prefixIcon: Icon(Iconsax.call),
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
                              const SizedBox(height: 20),
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Bio',
                                  prefixIcon: Icon(Icons.info_outline),
                                ),
                                controller: controller.bioController,
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
                      onPressed: controller.isEdited.value
                          ? () => controller.updateProfile()
                          : null,
                      child: controller.isLoading.value
                          ? const Center(
                              child: CircularProgressIndicator(
                                  color: Colors.white))
                          : const Text('Save Changes'),
                    ),
                  ),
                ],
              ),
              if (controller.isLoading.value)
                const Center(child: CircularProgressIndicator()),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildProfilePicture(ProfileController controller) {
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
                  controller.nameController.text.isNotEmpty
                      ? controller.nameController.text[0].toUpperCase()
                      : '',
                  style: Theme.of(Get.context!)
                      .textTheme
                      .headlineLarge!
                      .copyWith(color: Colors.white),
                ),
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
}
