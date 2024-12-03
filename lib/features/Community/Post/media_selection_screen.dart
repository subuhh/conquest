import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';
import '../../../core/Controllers/community_controller/post_album_picker_controller.dart';
import '../../../core/Controllers/community_controller/post_creation_controller.dart';

class MediaPickerScreen extends StatelessWidget {
  const MediaPickerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MediaPickerController());
    final postCreationController = Get.put(PostCreationController());

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "New Post",
          style: TextStyle(color: Colors.white),
        ),
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        backgroundColor: Colors.black,
        actions: [
          Obx(
            () => TextButton(
              onPressed: controller.selectedMedia.isNotEmpty
                  ? controller.proceedToNextScreen
                  : null,
              child: Text(
                "Next",
                style: TextStyle(
                    color: controller.selectedMedia.isNotEmpty
                        ? Colors.blue
                        : Colors.blue.withOpacity(0.5),
                    fontSize: 16),
              ),
            ),
          ),
        ],
      ),
      body: Obx(() {
        // Handle loading state
        if (controller.isLoading.value) {
          return const Center(
              child: CircularProgressIndicator(
            color: Colors.white,
          ));
        }

        // Handle permission denied
        if (!controller.permissionGranted.value) {
          return _buildPermissionDeniedView(controller);
        }

        // Main media picker layout
        return Column(
          children: [
            // Selected media preview (50% of screen)
            _buildSelectedMediaPreview(controller),

            // Top section with camera, multi-select, and album dropdown
            _buildTopSection(controller),

            // Media grid
            _buildMediaGrid(controller),
          ],
        );
      }),
    );
  }

  Widget _buildPermissionDeniedView(MediaPickerController controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.lock, size: 50, color: Colors.white),
          const SizedBox(height: 16),
          const Text(
            "Permission Required",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 8),
          const Text(
            "We need access to your gallery and camera.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: controller.checkPermissionAndLoadMedia,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(
              "Grant Permission",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopSection(MediaPickerController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Album dropdown
          Expanded(
            child: DropdownButton<AssetPathEntity>(
              dropdownColor: Colors.black,
              value: controller.selectedAlbum.value,
              isExpanded: true,
              underline: Container(height: 0),
              style: const TextStyle(color: Colors.white, fontSize: 16),
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
              items: controller.albums.map((album) {
                return DropdownMenuItem<AssetPathEntity>(
                  value: album,
                  child: Text(album.name),
                );
              }).toList(),
              onChanged: (selectedAlbum) {
                if (selectedAlbum != null) {
                  controller.loadMediaFromAlbum(selectedAlbum);
                }
              },
            ),
          ),

          // Multi-select toggle
          IconButton(
            icon: Obx(() => Icon(
                  controller.isMultiSelectEnabled.value
                      ? Icons.check_box
                      : Icons.check_box_outline_blank,
                  color: Colors.white,
                )),
            onPressed: controller.toggleMultiSelect,
          ),

          // Camera button
          IconButton(
            icon: const Icon(Icons.camera_alt, color: Colors.white),
            onPressed: () {
              // TODO: Implement camera capture functionality
              controller.initializeCameraController();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedMediaPreview(MediaPickerController controller) {
    return Obx(() {
      if (controller.selectedMedia.isEmpty)
        return SizedBox(
          height: Get.height * 0.5,
        );

      return SizedBox(
        height: Get.height * 0.5, // 50% of screen height
        child: PageView.builder(
          itemCount: controller.selectedMedia.length,
          itemBuilder: (context, index) {
            final media = controller.selectedMedia[index];
            return FutureBuilder(
              future: media.thumbnailData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.data != null) {
                  return Image.memory(
                    snapshot.data!,
                    fit: BoxFit.contain,
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            );
          },
        ),
      );
    });
  }

  Widget _buildMediaGrid(MediaPickerController controller) {
    return Expanded(
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
        ),
        itemCount: controller.allMedia.length,
        itemBuilder: (context, index) {
          final media = controller.allMedia[index];
          return FutureBuilder(
            future: media.thumbnailData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.data != null) {
                return GestureDetector(
                  onTap: () => controller.selectMedia(media),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.memory(
                        snapshot.data!,
                        fit: BoxFit.cover,
                      ),
                      // Selection overlay
                      Obx(() {
                        final isSelected =
                            controller.selectedMedia.contains(media);
                        return Positioned(
                          top: 4,
                          right: 4,
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 200),
                            opacity: isSelected ? 1.0 : 0.0,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              padding: const EdgeInsets.all(4),
                              child: Text(
                                '${controller.selectedMedia.indexOf(media) + 1}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                      // Video indicator
                      if (media.type == AssetType.video)
                        const Positioned(
                          child: Center(
                            child: Icon(
                              Icons.play_circle_outline,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              }
              return Container(color: Colors.grey[300]);
            },
          );
        },
      ),
    );
  }
}
