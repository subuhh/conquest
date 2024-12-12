import 'package:camera/camera.dart';
import 'package:conquest/core/Controllers/community_controller/stories_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';
import '../../../../core/Controllers/community_controller/post_album_picker_controller.dart';
import '../../../../core/Controllers/community_controller/post_creation_controller.dart';
import '../../../../utils/constants/colors.dart';

enum MediaPickerMode { post, story }

class MediaPickerScreen extends StatelessWidget {
  final MediaPickerMode pickerMode;

  MediaPickerScreen({super.key, this.pickerMode = MediaPickerMode.post});

  final controller = Get.put(MediaPickerController());
  final postCreationController = Get.put(PostCreationController());
  final storiesController = StoriesController.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          pickerMode == MediaPickerMode.post ? "New Post" : "New Story",
          style: const TextStyle(color: Colors.black),
        ),
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        actions: [
          Obx(
            () => TextButton(
              onPressed: controller.selectedMedia.isNotEmpty
                  ? () {
                      _proceedWithMedia(context);
                    }
                  : null,
              child: Text(
                pickerMode == MediaPickerMode.post ? "Next" : "Upload",
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
          return _buildPermissionDeniedView();
        }

        // Camera mode view
        if (controller.isCameraMode.value) {
          return _buildCameraView();
        }

        // Existing media picker layout
        return _buildMediaPickerLayout();
      }),
    );
  }

  Future<void> _proceedWithMedia(BuildContext context) async {
    if (pickerMode == MediaPickerMode.story) {
      // For stories, take the first selected media
      final mediaFile = await controller.selectedMedia.first.file;
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(
            color: TColors.primary,
          ),
        ),
        barrierDismissible: false,
        barrierColor: Colors.black.withOpacity(0.4),
      );
      try {
        await storiesController.createStoryFromMedia(mediaFile!);
      } finally {
        Get.back(); // Close the dialog
      }
    } else {
      // Existing post creation logic
      controller.proceedToNextScreen();
    }
  }

  Widget _buildMediaPickerLayout() {
    return Column(
      children: [
        _buildSelectedMediaPreview(),
        // Existing top section
        _buildTopSection(),

        // Media grid or camera capture preview
        _buildMediaGrid(),
      ],
    );
  }

  Widget _buildPermissionDeniedView() {
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

  Widget _buildTopSection() {
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
                controller.initializeCameraController();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraView() {
    return Stack(
      children: [
        // Camera preview
        Positioned.fill(
          child: controller.cameraController.value != null
              ? CameraPreview(controller.cameraController.value!)
              : Container(color: Colors.black),
        ),

        // Camera mode controls
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Toggle photo/video mode
              IconButton(
                icon: Icon(
                  controller.isVideoMode.value
                      ? Icons.camera_alt
                      : Icons.videocam,
                  color: Colors.white,
                  size: 36,
                ),
                onPressed: controller.toggleCaptureMode,
              ),

              // Capture button
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.white.withOpacity(0.5),
                child: IconButton(
                  icon: Icon(
                    controller.isVideoMode.value
                        ? (controller.cameraController.value?.value
                                    .isRecordingVideo ==
                                true
                            ? Icons.stop
                            : Icons.fiber_manual_record)
                        : Icons.camera_alt,
                    color: Colors.white,
                    size: 36,
                  ),
                  onPressed: () {
                    if (controller.isVideoMode.value) {
                      controller.cameraController.value?.value
                                  .isRecordingVideo ==
                              true
                          ? controller.stopVideoRecording()
                          : controller.recordVideo();
                    } else {
                      controller.capturePhoto();
                    }
                  },
                ),
              ),

              // Close camera mode
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 36),
                onPressed: () => controller.isCameraMode.value = false,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedMediaPreview() {
    return Obx(() {
      if (controller.selectedMedia.isEmpty)
        return SizedBox(
          height:
              Get.height * (pickerMode == MediaPickerMode.story ? 0.7 : 0.4),
        );

      return SizedBox(
        height: Get.height * (pickerMode == MediaPickerMode.story ? 0.7 : 0.4),
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

  Widget _buildMediaGrid() {
    return Expanded(
      child: RefreshIndicator(
        color: Colors.red,
        backgroundColor: Colors.black,
        onRefresh: controller.loadAlbums,
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
                                size: 50,
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
      ),
    );
  }
}
