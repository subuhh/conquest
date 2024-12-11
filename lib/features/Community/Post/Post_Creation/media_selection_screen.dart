import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';
import '../../../../core/Controllers/community_controller/post_album_picker_controller.dart';
import '../../../../core/Controllers/community_controller/post_creation_controller.dart';

class MediaPickerScreen extends StatelessWidget {
  const MediaPickerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MediaPickerController());
    Get.put(PostCreationController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "New Post",
          style: TextStyle(color: Colors.black),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
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
              dropdownColor: Colors.white,
              value: controller.selectedAlbum.value,
              isExpanded: true,
              underline: Container(height: 0),
              style: const TextStyle(color: Colors.white, fontSize: 16),
              icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
              items: controller.albums.map((album) {
                return DropdownMenuItem<AssetPathEntity>(
                  value: album,
                  child: Text(
                    album.name,
                    style: TextStyle(color: Colors.black),
                  ),
                );
              }).toList(),
              onChanged: (selectedAlbum) {
                if (selectedAlbum != null) {
                  controller.loadMediaFromAlbum(selectedAlbum);
                }
              },
            ),
          ),

          const SizedBox(width: 20),

          // Multi-select toggle
          Obx(
            () => CircleAvatar(
              radius: 22,
              backgroundColor: controller.isMultiSelectEnabled.value
                  ? Colors.blue
                  : Colors.black.withOpacity(0.1),
              child: IconButton(
                icon: SvgPicture.asset(
                  'assets/icons/community/multiple_select.svg',
                  colorFilter: ColorFilter.mode(
                      controller.isMultiSelectEnabled.value
                          ? Colors.white
                          : Colors.black,
                      BlendMode.srcIn),
                ),
                onPressed: controller.toggleMultiSelect,
              ),
            ),
          ),

          const SizedBox(width: 10),

          // Camera button
          CircleAvatar(
            radius: 22,
            backgroundColor: Colors.black.withOpacity(0.1),
            child: IconButton(
              icon: const Icon(Icons.camera_alt, color: Colors.black),
              onPressed: () {
                // TODO: Implement camera capture functionality
                controller.initializeCameraController();
              },
            ),
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
                  onLongPress: () => controller.toggleMultiSelect(),
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
                          top: 6,
                          right: 6,
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 200),
                            opacity: isSelected ? 1.0 : 0.0,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              width: 25,
                              height: 25,
                              padding: const EdgeInsets.all(4),
                              child: Center(
                                child: Text(
                                  '${controller.selectedMedia.indexOf(media) + 1}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
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
