import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/Controllers/community_controller/post_creation_controller.dart';
import '../../../../core/model/community/post_model.dart';

class AddPostDetails extends StatelessWidget {
  final RxList<MediaFile> editedImages;

  AddPostDetails({Key? key, required this.editedImages}) : super(key: key);

  final _controller = PostCreationController.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Post'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMediaCarousel(),
            SizedBox(height: 16.0),
            TextField(
              controller: _controller.contentController,
              decoration: InputDecoration(
                hintText: 'What\'s on your mind?',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.location_on_outlined),
              title: Text('Add Location'),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Select Category',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Obx(
                () => Wrap(
                  spacing: 8,
                  children: Category.values
                      .map(
                        (category) => ChoiceChip(
                          label: Text(
                            category.name.capitalize!,
                            style: TextStyle(color: Colors.black),
                          ),
                          selected:
                              _controller.selectedCategory.value == category,
                          onSelected: (_) =>
                              _controller.selectedCategory.value = category,
                          selectedColor: Colors.black,
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
            _buildHashtagInput(),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Obx(
          () => ElevatedButton(
            onPressed: _controller.isLoading.value
                ? null
                : () {
                    _controller.createPost();
                  },
            child: _controller.isLoading.value
                ? Center(child: CircularProgressIndicator(color: Colors.white))
                : Text('Create Post'),
          ),
        ),
      ),
    );
  }

  Widget _buildMediaCarousel() {
    return CarouselSlider(
      options: CarouselOptions(
        height: 300,
        enlargeCenterPage: true,
        enableInfiniteScroll: false,
      ),
      items: editedImages.map((mediaFile) {
        return Builder(
          builder: (BuildContext context) {
            if (mediaFile.type == MediaType.image) {
              return Image.memory(
                mediaFile.file,
                fit: BoxFit.cover,
                width: double.infinity,
              );
            } else if (mediaFile.type == MediaType.video) {
              return Stack(
                children: [
                  Container(
                    width: double.infinity,
                    color: Colors.black,
                    child: Center(
                      child: Icon(
                        Icons.videocam,
                        color: Colors.white,
                        size: 100,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      'Video',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ),
                ],
              );
            } else {
              return SizedBox.shrink();
            }
          },
        );
      }).toList(),
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
          Obx(
            () => Wrap(
              spacing: 8,
              children: _controller.selectedHashtags
                  .map((hashtag) => Chip(
                        label: Text(hashtag),
                        onDeleted: () => _controller.removeHashtag(hashtag),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
