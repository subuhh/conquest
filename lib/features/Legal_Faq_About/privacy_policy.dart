import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Privacy Policy"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Effective Date: 20 Nov 2024",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              "1. Introduction\n"
                  "Conquest ('we', 'our', 'us') respects your privacy and is committed to protecting it through compliance with this privacy policy. "
                  "This document explains how we collect, use, and safeguard your information.\n\n"
                  "2. Information We Collect\n"
                  "- Personal Information: Name, email, address, date of birth, payment information.\n"
                  "- Health Data: Weight, height, activity levels, and dietary preferences.\n"
                  "- Usage Data: App usage patterns, search queries, and interaction history.\n"
                  "- Device Information: IP address, device type, and operating system.\n\n"
                  "3. How We Use Your Information\n"
                  "We use your data to:\n"
                  "- Provide personalized workout and nutrition plans.\n"
                  "- Track progress through calorie counters and activity data.\n"
                  "- Facilitate community interactions (posts, chats, and comments).\n"
                  "- Process marketplace transactions and app currency.\n"
                  "- Improve app functionality and user experience.\n\n"
                  "4. Sharing of Information\n"
                  "We do not sell your data. However, we may share it with:\n"
                  "- Service Providers to manage app services.\n"
                  "- Law Enforcement to comply with legal obligations.\n\n"
                  "5. Data Security\n"
                  "Your data is encrypted and stored securely. However, no system is completely secure; we recommend safeguarding your account credentials.\n\n"
                  "6. Your Rights\n"
                  "You may:\n"
                  "- Access and correct your data.\n"
                  "- Request data deletion.\n"
                  "- Opt out of marketing communications.\n\n"
                  "7. Updates to This Policy\n"
                  "We may update this policy from time to time. Changes will be communicated through the app.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              "Contact Us",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "If you have questions, contact us at conquestfit88@gmail.com",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
