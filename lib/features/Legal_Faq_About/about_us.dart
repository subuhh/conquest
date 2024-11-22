import 'package:conquest/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "About Conquest",
          style: TextStyle(color: Colors.white),
        ),
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: TColors.primary,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [TColors.primary, TColors.primary.withOpacity(0.5)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Conquest App",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Empowering Your Fitness Journey",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // About Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionHeader(title: "About Conquest"),
                  SizedBox(height: 10),
                  Text(
                    "Conquest is not just an app—it's a lifestyle revolution. Our platform bridges the gap between fitness, nutrition, and community engagement, providing a seamless and comprehensive approach to health and wellness. Whether you're embarking on your first workout or striving to break your personal best, Conquest is designed to guide and inspire you at every step.",
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ],
              ),
            ),

            // Mission Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionHeader(title: "Our Mission"),
                  SizedBox(height: 10),
                  Text(
                    "To empower individuals to achieve their fitness and wellness goals by delivering cutting-edge technology, personalized insights, and a supportive community. Conquest aims to transform how people approach health—making it accessible, engaging, and enjoyable for everyone.",
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ],
              ),
            ),

            // Vision Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionHeader(title: "Our Vision"),
                  SizedBox(height: 10),
                  Text(
                    "Our vision is to become the world’s most trusted and innovative health and fitness platform. By fostering a holistic approach to wellness, we aim to inspire millions to lead healthier, happier, and more fulfilling lives. At Conquest, we believe in progress, not perfection—helping users take one step closer to their goals each day.",
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ],
              ),
            ),

            // Ideology Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionHeader(title: "Our Ideology"),
                  SizedBox(height: 10),
                  Text(
                    "At Conquest, we stand by the philosophy that fitness is for everyone. We celebrate diversity in goals, abilities, and preferences, creating an inclusive environment that encourages growth at every level. Our ideology is rooted in innovation, collaboration, and the belief that every individual has the potential to conquer their personal milestones.",
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ],
              ),
            ),

            // Goals Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionHeader(title: "Our Goals"),
                  SizedBox(height: 10),
                  GoalBulletPoint(
                      text:
                          "Deliver a seamless, user-friendly platform that integrates fitness, nutrition, and community features."),
                  GoalBulletPoint(
                      text:
                          "Encourage long-term engagement through gamification and rewards."),
                  GoalBulletPoint(
                      text:
                          "Provide scientifically-backed nutrition and workout guidance tailored to individual needs."),
                  GoalBulletPoint(
                      text:
                          "Foster a supportive and inclusive community for users to connect, share, and inspire."),
                  GoalBulletPoint(
                      text:
                          "Innovate constantly to stay ahead of trends in health and fitness technology."),
                ],
              ),
            ),

            // Footer Section
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "© 2024 Conquest App - All Rights Reserved",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }
}

class GoalBulletPoint extends StatelessWidget {
  final String text;

  const GoalBulletPoint({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle, size: 20, color: Colors.blueAccent),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }
}
