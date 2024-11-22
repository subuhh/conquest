import 'package:flutter/material.dart';

class FAQScreen extends StatelessWidget {
  final Map<String, List<Map<String, String>>> faqs = {
    "Workout": [
      {
        "question": "How do I track my workouts?",
        "answer":
            "You can log your workouts manually or use guided workout routines in the app."
      },
      {
        "question": "Are the workout plans customizable?",
        "answer":
            "Yes, you can customize your plans based on your goals and preferences."
      },
      {
        "question": "What types of workouts are available?",
        "answer": "We offer strength, cardio, yoga, HIIT, and more."
      },
      {
        "question": "Can I create my own workout plan?",
        "answer":
            "Yes, you can create a personalized plan by selecting exercises."
      },
      {
        "question": "How can I track my progress?",
        "answer":
            "Track progress through analytics, charts, and performance logs."
      },
      {
        "question": "Do the workouts require equipment?",
        "answer": "We have both equipment-free and equipment-based exercises."
      },
      {
        "question": "Are workouts safe for beginners?",
        "answer": "Yes, we offer beginner-friendly workouts with instructions."
      },
      {
        "question": "Is there a warm-up routine included?",
        "answer":
            "Every workout includes a recommended warm-up and cool-down routine."
      },
      {
        "question": "Can I sync my workouts with my smartwatch?",
        "answer":
            "Yes, you can sync with popular devices like Fitbit and Apple Watch."
      },
      {
        "question": "How often should I work out?",
        "answer":
            "We recommend working out at least 3-5 times a week, but it depends on your goals."
      },
    ],
    "Nutrition": [
      {
        "question": "What kind of recipes are available?",
        "answer": "We offer keto, vegan, vegetarian, and high-protein recipes."
      },
      {
        "question": "How are my calorie needs calculated?",
        "answer":
            "Calories are calculated based on your age, weight, height, and activity level."
      },
      {
        "question": "Can I log my meals?",
        "answer": "Yes, you can log your meals and track your nutrition intake."
      },
      {
        "question": "Does the app suggest diet plans?",
        "answer":
            "Yes, the app offers personalized diet plans based on your goals."
      },
      {
        "question": "Are recipes categorized by meal type?",
        "answer":
            "Yes, recipes are categorized into breakfast, lunch, dinner, and snacks."
      },
      {
        "question": "Can I track macros like protein and carbs?",
        "answer": "Yes, the app provides detailed macronutrient breakdowns."
      },
      {
        "question": "Are there options for food allergies?",
        "answer": "Yes, you can filter recipes based on common allergens."
      },
      {
        "question": "Can I share recipes with others?",
        "answer": "Yes, you can share recipes with friends and the community."
      },
      {
        "question": "Is the nutrition info accurate?",
        "answer":
            "All nutrition data is verified and based on reliable sources."
      },
      {
        "question": "Can I create a grocery list?",
        "answer":
            "Yes, you can create grocery lists directly from selected recipes."
      },
    ],
    "Marketplace": [
      {
        "question": "What products are available?",
        "answer":
            "You can find fitness equipment, supplements, and merchandise."
      },
      {
        "question": "How do I purchase items?",
        "answer":
            "Add items to your cart and complete the purchase using available payment methods."
      },
      {
        "question": "Are there discounts for app users?",
        "answer": "Yes, app currency and special offers provide discounts."
      },
      {
        "question": "Can I track my orders?",
        "answer": "Yes, you can track orders under the Marketplace section."
      },
      {
        "question": "Are refunds available?",
        "answer": "Refund policies depend on individual sellers."
      },
      {
        "question": "How do I contact sellers?",
        "answer": "You can contact sellers via the app's messaging system."
      },
      {
        "question": "Are products delivered internationally?",
        "answer": "Delivery options depend on the seller's policy."
      },
      {
        "question": "Can I use app currency for purchases?",
        "answer": "Yes, app currency can be redeemed for eligible purchases."
      },
      {
        "question": "How do I review a product?",
        "answer":
            "You can leave reviews on purchased products in the order history."
      },
      {
        "question": "What payment methods are accepted?",
        "answer": "We accept credit/debit cards, UPI, and app currency."
      },
    ],
    "Community": [
      {
        "question": "What can I post in the community?",
        "answer":
            "You can post text updates, images, and videos related to fitness and wellness."
      },
      {
        "question": "Are there guidelines for posting?",
        "answer":
            "Yes, community guidelines must be followed to ensure respectful interactions."
      },
      {
        "question": "Can I comment on others' posts?",
        "answer":
            "Yes, you can like, comment, and share posts within the community."
      },
      {
        "question": "How do I report inappropriate content?",
        "answer": "Use the 'Report' button on posts or contact support."
      },
      {
        "question": "Can I create groups?",
        "answer":
            "Currently, groups are not supported but may be added in future updates."
      },
      {
        "question": "Is the community moderated?",
        "answer":
            "Yes, moderators review flagged content to maintain a positive environment."
      },
      {
        "question": "Can I follow other users?",
        "answer": "Yes, you can follow users to view their posts in your feed."
      },
      {
        "question": "How do I earn badges?",
        "answer":
            "Badges are earned by engaging actively in the community and completing challenges."
      },
      {
        "question": "Can I delete my posts?",
        "answer":
            "Yes, you can delete your posts at any time from your profile."
      },
      {
        "question": "How do I join challenges?",
        "answer":
            "Challenges are listed in the Community section. Join by clicking 'Participate'."
      },
    ],
    "Gamification": [
      {
        "question": "What are the gamification features?",
        "answer":
            "Gamification includes challenges, leaderboards, badges, and rewards."
      },
      {
        "question": "How do I earn app currency?",
        "answer":
            "Complete challenges, daily tasks, and milestones to earn currency."
      },
      {
        "question": "What are badges?",
        "answer":
            "Badges are achievements earned by reaching specific goals or milestones."
      },
      {
        "question": "Can I compete with friends?",
        "answer":
            "Yes, leaderboards allow you to compete with friends and other users."
      },
      {
        "question": "Are there daily challenges?",
        "answer": "Yes, daily challenges are available to keep you engaged."
      },
      {
        "question": "How do I view my rewards?",
        "answer":
            "Rewards are displayed in your profile under the Rewards section."
      },
      {
        "question": "Can I trade app currency?",
        "answer": "No, app currency is non-transferable."
      },
      {
        "question": "Do challenges have expiration dates?",
        "answer": "Yes, challenges must be completed within the specified time."
      },
      {
        "question": "How do I unlock premium features?",
        "answer":
            "Premium features can be unlocked using app currency or subscriptions."
      },
      {
        "question": "Are rewards real items or digital?",
        "answer":
            "Rewards include both real items (discounts) and digital items (badges, currency)."
      },
    ],
    "User & Security": [
      {
        "question": "How is my data secured?",
        "answer":
            "Your data is encrypted and stored securely to prevent unauthorized access."
      },
      {
        "question": "Can I change my password?",
        "answer": "Yes, you can change your password under the Profile section."
      },
      {
        "question": "How do I delete my account?",
        "answer":
            "You can delete your account in the app settings. This action is irreversible."
      },
      {
        "question": "Is my payment information secure?",
        "answer":
            "Yes, we use industry-standard encryption for all payment transactions."
      },
      {
        "question": "Can I access my data?",
        "answer":
            "Yes, you can request a copy of your data under the Privacy section."
      },
      {
        "question": "What happens if my account is hacked?",
        "answer": "Contact support immediately to secure your account."
      },
      {
        "question": "Can I use the app on multiple devices?",
        "answer":
            "Yes, your account syncs across devices using the same login credentials."
      },
      {
        "question": "Are my posts private?",
        "answer":
            "Community posts are public, but you can control your profile visibility."
      },
      {
        "question": "What happens if I violate guidelines?",
        "answer":
            "Violating guidelines may result in warnings, suspension, or account bans."
      },
      {
        "question": "How do I contact support?",
        "answer":
            "You can contact support through the Help section or email support@conquestapp.com."
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FAQ"),
      ),
      body: ListView(
        children: faqs.entries.map((section) {
          return FAQSection(
            title: section.key,
            faqs: section.value,
          );
        }).toList(),
      ),
    );
  }
}

class FAQSection extends StatelessWidget {
  final String title;
  final List<Map<String, String>> faqs;

  const FAQSection({required this.title, required this.faqs});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section heading
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
          child: Text(
            '$title',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        Card(
          elevation: 4,
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Column(
            children: faqs.map((faq) {
              return ExpansionTile(
                title: Text(
                  faq['question']!,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      faq['answer']!,
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
