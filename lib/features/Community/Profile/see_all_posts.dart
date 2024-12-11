import 'package:conquest/core/model/community/post_model.dart';
import 'package:conquest/features/Community/Post/Post_Card/post_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SeeAllPosts extends StatelessWidget {
  final List<PostModel> posts;
  const SeeAllPosts({super.key, required this.posts});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0, bottom: 8),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Icon(Icons.arrow_back),
                  ),
                  const SizedBox(width: 20),
                  Text(
                    'Posts',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  // physics: NeverScrollableScrollPhysics(),
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    return PostCardWidget(post: post);
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
