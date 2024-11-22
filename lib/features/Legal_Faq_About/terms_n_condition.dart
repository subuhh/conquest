import 'package:flutter/material.dart';

class TermsConditionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Terms & Conditions"),
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
              "1. Acceptance of Terms\n"
                  "By using the Conquest app, you agree to these terms. If you do not agree, please do not use our app.\n\n"
                  "2. User Responsibilities\n"
                  "- Provide accurate personal and health information.\n"
                  "- Avoid harmful or offensive content in community spaces.\n"
                  "- Use the app solely for personal purposes.\n\n"
                  "3. Prohibited Activities\n"
                  "Users may not:\n"
                  "- Post inappropriate, illegal, or harmful content.\n"
                  "- Exploit the app currency or gamification features.\n"
                  "- Reverse-engineer or distribute the app code.\n\n"
                  "4. Intellectual Property\n"
                  "All app content, including workouts, recipes, and gamification designs, is owned by Conquest.\n\n"
                  "5. Limitation of Liability\n"
                  "We are not responsible for:\n"
                  "- Injuries or health issues resulting from app guidance.\n"
                  "- Unauthorized account access due to user negligence.\n\n"
                  "6. Marketplace Transactions\n"
                  "- Refunds and exchanges are subject to seller policies.\n"
                  "- App currency is non-transferable and non-refundable.\n\n"
                  "7. Modifications to Terms\n"
                  "We may update these terms periodically. Continued use of the app indicates acceptance of changes.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              "Contact Us",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "For questions, reach us at conquestfit88@gmail.com",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
