import 'package:flutter/material.dart';

import '../../utils/constants/colors.dart';

String? selectedGender;

class GenderSelectionScreen extends StatefulWidget {
  @override
  _GenderSelectionScreenState createState() => _GenderSelectionScreenState();
}

class _GenderSelectionScreenState extends State<GenderSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Select Your Gender',style: Theme.of(context).textTheme.headlineMedium,),
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
                        child: Text('Male',
                          style:Theme.of(context).textTheme.headlineMedium!.apply(color: selectedGender == 'Male' ? TColors.primary : TColors.grey, ),
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
                          avatarImage: AssetImage(
                              'assets/female_avatar.jpg'), // Add your image
                        ),
                      ),
                      SizedBox(
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
                      SizedBox(
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
                          style:Theme.of(context).textTheme.headlineMedium!.apply(color: selectedGender == 'Female' ? TColors.primary : TColors.grey, ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50,vertical: 15)
                ),
                onPressed: () {}, child: Text('Continue')),
          )
        ],
      ),
    );
  }
}

class FemaleGenderButton extends StatelessWidget {
  final VoidCallback onTap;

  FemaleGenderButton({
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: -25,
              child: Icon(
                Icons.female,
                color: selectedGender == 'Female' ? TColors.primary : TColors.grey,
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
                child: CircleAvatar(
                  radius: 70,
                  backgroundImage: NetworkImage(
                      'https://media.istockphoto.com/id/1440456344/photo/happy-woman-and-lingerie-in-a-studio-for-wellness-beauty-and-weight-loss-against-a-white.jpg?s=612x612&w=0&k=20&c=R6zLbOFzGj73DQlP-qyv3vKdd-H98dX2Su_vKh26dHU='),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MaleGenderButton extends StatelessWidget {
  final VoidCallback onTap;
  final AssetImage avatarImage;

  MaleGenderButton({
    required this.onTap,
    required this.avatarImage,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
                child: CircleAvatar(
                  radius: 70,
                  backgroundImage: NetworkImage(
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR9t1YBPZ3e1Zm3_eYtqMX4eTV7oYwBTIlhTg&s'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
