import 'package:conquest/features/Authentication/Login/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/widgets/custom_snackbar.dart';
import '../../../core/model/user.dart';
import '../../../core/services/firestore_service.dart';
import '../../../utils/constants/colors.dart';

String? selectedGender;

class GenderSelectionScreen extends StatefulWidget {
  final User user;
  final String email;
  final String username;
  final String name;
  final String phoneNumber;
  const GenderSelectionScreen({
    super.key,
    required this.user,
    required this.email,
    required this.username,
    required this.name,
    required this.phoneNumber,
  });

  @override
  State<GenderSelectionScreen> createState() => _GenderSelectionScreenState();
}

class _GenderSelectionScreenState extends State<GenderSelectionScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Select Your Gender',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      backgroundColor: TColors.secondaryBackground,
      body: Column(
        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 50,
                        child: Text(
                          'Male',
                          style:
                              Theme.of(context).textTheme.headlineMedium!.apply(
                                    color: selectedGender == 'Male'
                                        ? TColors.primary
                                        : TColors.grey,
                                  ),
                        ),
                      ),
                      SizedBox(
                        height: 250,
                        child: MaleGenderButton(
                          onTap: () {
                            setState(() {
                              selectedGender = 'Male';
                            });
                          },
                          avatarImage: const AssetImage(
                              'assets/female_avatar.jpg'), // Add your image
                        ),
                      ),
                      const SizedBox(
                        height: 150,
                      ),
                    ],
                  ),
                ),
                // SizedBox(width: 40,),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 150,
                      ),
                      SizedBox(
                        height: 250,
                        child: FemaleGenderButton(
                          onTap: () {
                            setState(() {
                              selectedGender = 'Female';
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        child: Text(
                          'Female',
                          style:
                              Theme.of(context).textTheme.headlineMedium!.apply(
                                    color: selectedGender == 'Female'
                                        ? TColors.primary
                                        : TColors.grey,
                                  ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                onPressed: _genderSelection,
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : const Text('Continue'),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _genderSelection() async {
    try {
      setState(() => isLoading = true);
      if (selectedGender!.isNotEmpty) {
        final userModel = UserModel(
          id: widget.user.uid,
          userName: widget.username,
          name: widget.name,
          email: widget.email,
          phoneNumber: widget.phoneNumber,
          gender: selectedGender,
        );

        // Save user data in Firestore
        await FirestoreService().createUserDocument(userModel);

        Get.offAll(() =>const LoginScreen());
        showSnackBar('Success', 'Account created successfully. Please log in.');
      } else {
        showSnackBar('Error', 'Please Select Gender!');
      }
    } catch (e) {
      setState(() => isLoading = false);
      showSnackBar('Error', 'Something Error Occurred. Please Try Again.');
    } finally {
      setState(() => isLoading = false);
    }
  }
}

class FemaleGenderButton extends StatelessWidget {
  final VoidCallback onTap;

  const FemaleGenderButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: -25,
            child: Icon(
              Icons.female,
              color:
                  selectedGender == 'Female' ? TColors.primary : TColors.grey,
              size: 300, // Icon size
            ),
          ),
          Positioned(
            top: 0,
            child: CircleAvatar(
              radius: 85, // Adjust size accordingly
              //backgroundColor: isSelected ? Colors.blue : Colors.white,
              backgroundColor:
                  selectedGender == 'Female' ? TColors.primary : TColors.grey,
              child: const CircleAvatar(
                radius: 70,
                backgroundImage: NetworkImage(
                    'https://media.istockphoto.com/id/1440456344/photo/happy-woman-and-lingerie-in-a-studio-for-wellness-beauty-and-weight-loss-against-a-white.jpg?s=612x612&w=0&k=20&c=R6zLbOFzGj73DQlP-qyv3vKdd-H98dX2Su_vKh26dHU='),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MaleGenderButton extends StatelessWidget {
  final VoidCallback onTap;
  final AssetImage avatarImage;

  const MaleGenderButton({
    super.key,
    required this.onTap,
    required this.avatarImage,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 40,
            top: 0,
            child: Icon(
              Icons.north_east,
              color: selectedGender == 'Male' ? TColors.primary : TColors.grey,
              size: 200, // Icon size
            ),
          ),
          Positioned(
            bottom: 0,
            child: CircleAvatar(
              radius: 85, // Adjust size accordingly
              //backgroundColor: isSelected ? Colors.blue : Colors.white,
              backgroundColor:
                  selectedGender == 'Male' ? TColors.primary : TColors.grey,
              child: const CircleAvatar(
                radius: 70,
                backgroundImage: NetworkImage(
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR9t1YBPZ3e1Zm3_eYtqMX4eTV7oYwBTIlhTg&s'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
