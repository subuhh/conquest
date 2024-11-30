import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/Controllers/community_controller/post_creation_controller.dart';
import '../../../core/model/community/post_model.dart';
import '../../../utils/constants/colors.dart';

class PostCreationBottomSheet extends StatelessWidget {
  final PostCreationController _controller = Get.put(PostCreationController());

  PostCreationBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      maxChildSize: 0.95,
      minChildSize: 0.7,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 5,
                blurRadius: 7,
              ),
            ],
          ),
          child: ListView(
            controller: scrollController,
            children: [
              _buildHeader(),
              _buildMediaSelector(),
              _buildContentInput(),
              _buildCategorySelector(),
              _buildHashtagInput(),
              _buildCreatePostButton(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Create New Post',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: TColors.primary,
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, color: TColors.primary),
            onPressed: () => Get.back(),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaSelector() {
    return Obx(() => Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  // Add Media Buttons
                  _buildMediaAddButton(),

                  // Selected Media Preview
                  ..._controller.selectedMedia
                      .map((file) => Stack(
                            children: [
                              Container(
                                margin: EdgeInsets.all(8),
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    image: FileImage(file.file),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 0,
                                top: 0,
                                child: IconButton(
                                  icon: Icon(Icons.close, color: Colors.red),
                                  onPressed: () => _controller.removeMediaItem(
                                      _controller.selectedMedia.indexOf(file)),
                                ),
                              ),
                            ],
                          ))
                      .toList(),
                ],
              ),
            ),
          ],
        ));
  }

  Widget _buildMediaAddButton() {
    return Container(
      margin: EdgeInsets.all(8),
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(Icons.camera_alt, color: TColors.primary),
            onPressed: _controller.pickMultipleMedia,
          ),
          Text('Add Media', style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  // void _showMediaSourceDialog() {
  //   Get.dialog(
  //     AlertDialog(
  //       title: Text('Select Media Source'),
  //       content: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           ListTile(
  //             leading: Icon(Icons.photo_library),
  //             title: Text('Gallery'),
  //             onTap: () {
  //               Get.back();
  //               _controller.pickMediaFromGallery();
  //             },
  //           ),
  //           ListTile(
  //             leading: Icon(Icons.camera_alt),
  //             title: Text('Camera'),
  //             onTap: () {
  //               Get.back();
  //               _controller.captureMediaFromCamera();
  //             },
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildContentInput() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _controller.contentController,
        maxLines: 4,
        decoration: InputDecoration(
          hintText: 'What\'s on your mind?',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Category',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Obx(() => Wrap(
                spacing: 8,
                children: Category.values
                    .map((category) => ChoiceChip(
                          label: Text(category.name.capitalize!),
                          selected:
                              _controller.selectedCategory.value == category,
                          onSelected: (_) =>
                              _controller.selectedCategory.value = category,
                        ))
                    .toList(),
              )),
        ],
      ),
    );
  }

  Widget _buildHashtagInput() {
    final TextEditingController hashtagController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hashtags',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: hashtagController,
                  decoration: InputDecoration(
                    hintText: 'Add hashtag',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        if (hashtagController.text.isNotEmpty) {
                          _controller.addHashtag(
                              hashtagController.text.startsWith('#')
                                  ? hashtagController.text
                                  : '#${hashtagController.text}');
                          hashtagController.clear();
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          Obx(() => Wrap(
                spacing: 8,
                children: _controller.selectedHashtags
                    .map((hashtag) => Chip(
                          label: Text(hashtag),
                          onDeleted: () => _controller.removeHashtag(hashtag),
                        ))
                    .toList(),
              )),
        ],
      ),
    );
  }

  Widget _buildCreatePostButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Obx(
        () => ElevatedButton(
          onPressed:
              _controller.isLoading.value ? null : _controller.createPost,
          child: _controller.isLoading.value
              ? Center(child: CircularProgressIndicator(color: Colors.white))
              : Text('Create Post'),
          style: ElevatedButton.styleFrom(
            minimumSize: Size(double.infinity, 50),
          ),
        ),
      ),
    );
  }
}
