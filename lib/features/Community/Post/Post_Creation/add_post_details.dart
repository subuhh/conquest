import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/Controllers/community_controller/post_creation_controller.dart';
import '../../../../core/model/community/post_model.dart';

class AddPostDetails extends StatelessWidget {
  final List<MediaFile> editedImages;

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
                hintText: 'Add a caption...', // More descriptive hint text
                hintStyle: TextStyle(
                  color: Colors.black, // Lighter hint text color for better UX
                ),
                border: InputBorder.none, // Removes the border
                filled: true, // Enables the background color
                fillColor: Colors
                    .grey[100], // Light background color to highlight the field
                contentPadding: EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16), // Padding inside the text field
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.transparent), // No border
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.transparent), // No border even when focused
                ),
              ),
            ),
            // ListTile(
            //   leading: Icon(Icons.location_on_outlined),
            //   title: Text('Add Location'),
            //   trailing: Icon(Icons.arrow_forward_ios),
            // ),
            SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Select Category',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Obx(
                () => Wrap(
                  spacing: 12, // Increase the spacing for better clarity
                  runSpacing: 8, // Vertical spacing between rows
                  children: Category.values
                      .map(
                        (category) => ChoiceChip(
                          label: Text(
                            category.name.capitalize!,
                            style: TextStyle(
                              color:
                                  _controller.selectedCategory.value == category
                                      ? Colors.white // Selected text color
                                      : Colors.black, // Unselected text color
                              fontWeight:
                                  FontWeight.bold, // Bold text for clarity
                            ),
                          ),
                          selected:
                              _controller.selectedCategory.value == category,
                          onSelected: (_) =>
                              _controller.selectedCategory.value = category,
                          selectedColor: Colors.black, // Color when selected
                          backgroundColor:
                              Colors.grey[100], // Color for unselected chips
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(30), // Rounded corners
                          ),
                          elevation: 4, // Subtle shadow for depth
                          shadowColor:
                              Colors.black.withOpacity(0.2), // Light shadow
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 16),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
            const SizedBox(height: 10),
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
                    _controller.selectedMedia.value = editedImages;

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
                fit: BoxFit.contain,
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
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hashtags',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black87, // A more subtle color for labels
            ),
          ),
          SizedBox(height: 8.0), // Space between label and input field
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: hashtagController,
                  decoration: InputDecoration(
                    hintText: 'Add hashtag...',
                    hintStyle:
                        TextStyle(color: Colors.grey), // Subtle hint color
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(30), // Rounded corners
                      borderSide:
                          BorderSide(color: Colors.grey.withOpacity(0.4)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.black, width: 1.5),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.add, color: Colors.black),
                      onPressed: () {
                        if (hashtagController.text.isNotEmpty) {
                          _controller.addHashtag(
                            hashtagController.text.startsWith('#')
                                ? hashtagController.text
                                : '#${hashtagController.text}',
                          );
                          hashtagController.clear();
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.0), // Space between input field and hashtags list
          Obx(
            () => Wrap(
              spacing: 8,
              runSpacing: 6, // Vertical spacing between chips
              children: _controller.selectedHashtags
                  .map((hashtag) => Chip(
                        label: Text(
                          hashtag,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        backgroundColor: Colors.black,
                        deleteIconColor: Colors.white,
                        onDeleted: () => _controller.removeHashtag(hashtag),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
