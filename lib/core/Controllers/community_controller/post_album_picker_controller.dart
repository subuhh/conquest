import 'dart:developer';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:conquest/core/Controllers/community_controller/post_creation_controller.dart';
import 'package:conquest/features/Community/Post/Post_Creation/add_post_details.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:permission_handler/permission_handler.dart';

class MediaPickerController extends GetxController {
  // Observable variables
  final RxList<AssetPathEntity> albums = <AssetPathEntity>[].obs;
  final RxList<AssetEntity> allMedia = <AssetEntity>[].obs;
  final RxList<AssetEntity> selectedMedia = <AssetEntity>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool permissionGranted = false.obs;
  final Rx<AssetPathEntity?> selectedAlbum = Rx<AssetPathEntity?>(null);

  // Camera-related variables
  Rx<CameraController?> cameraController = Rx<CameraController?>(null);
  final RxList<CameraDescription> cameras = <CameraDescription>[].obs;

  // Error and state management
  final Rx<String?> errorMessage = Rx<String?>(null);

  // Toggle multi-select mode
  final RxBool isMultiSelectEnabled = false.obs;

  // Camera capture modes
  final RxBool isCameraMode = false.obs;
  final Rx<File?> capturedMedia = Rx<File?>(null);
  final RxBool isVideoMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    initializeMedia();
  }

  // Toggle between photo and video capture modes
  void toggleCaptureMode() {
    isVideoMode.toggle();
  }

  Future<void> initializeMedia() async {
    try {
      // Initialize cameras
      cameras.value = await availableCameras();

      // Request permissions
      await checkPermissionAndLoadMedia();
    } catch (e) {
      _handleError(e, 'Initializing media');
    }
  }

  Future<void> checkPermissionAndLoadMedia() async {
    try {
      // Reset state
      errorMessage.value = null;
      isLoading.value = true;
      permissionGranted.value = false;

      // Request both gallery and camera permissions
      final galleryStatus = await Permission.photos.request();
      final videoStatus = await Permission.videos.request();
      final cameraStatus = await Permission.camera.request();

      if (galleryStatus.isGranted &&
          cameraStatus.isGranted &&
          videoStatus.isGranted) {
        permissionGranted.value = true;
        await loadAlbums();
      } else {
        // Handle permission denial
        if (galleryStatus.isDenied || cameraStatus.isDenied) {
          errorMessage.value = 'Gallery or Camera permission denied';
        } else if (galleryStatus.isPermanentlyDenied ||
            cameraStatus.isPermanentlyDenied) {
          errorMessage.value = 'Permissions permanently denied';
          await openAppSettings();
        }
      }
    } catch (e) {
      _handleError(e, 'Error checking permissions');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadAlbums() async {
    try {
      // Reset state
      isLoading.value = true;
      errorMessage.value = null;

      // Fetch albums with advanced filtering
      final fetchedAlbums = await PhotoManager.getAssetPathList(
        type: RequestType.common, // Allow both image and video
        filterOption: FilterOptionGroup(
          imageOption: FilterOption(
            sizeConstraint: SizeConstraint(),
          ),
          videoOption: FilterOption(
            sizeConstraint: SizeConstraint(),
          ),
          orders: [
            OrderOption(
              type: OrderOptionType.createDate,
              asc: false,
            ),
          ],
        ),
      );

      // Update albums
      albums.value = fetchedAlbums;

      // Select first album by default
      if (fetchedAlbums.isNotEmpty) {
        selectedAlbum.value = fetchedAlbums[0];
        await loadMediaFromAlbum(selectedAlbum.value!);
      }
    } catch (e) {
      _handleError(e, 'Error loading albums');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMediaFromAlbum(AssetPathEntity album) async {
    try {
      // Reset state
      allMedia.clear();
      isLoading.value = true;
      errorMessage.value = null;

      // Fetch media from the selected album
      final albumMedia = await album.getAssetListPaged(
        page: 0,
        size: 50, // Adjust as needed
      );

      // Update media
      allMedia.value = albumMedia;

      // Select first media by default if available
      if (allMedia.isNotEmpty) {
        selectMedia(allMedia[0]);
      }
    } catch (e) {
      _handleError(e, 'Error loading media from album');
    } finally {
      isLoading.value = false;
    }
  }

  void selectMedia(AssetEntity media) {
    // Clear previous selections if not in multi-select mode
    if (!isMultiSelectEnabled.value) {
      selectedMedia.clear();
    }

    // Prevent selecting more than 10 media
    if (selectedMedia.length < 10) {
      if (selectedMedia.contains(media)) {
        selectedMedia.remove(media);
      } else {
        selectedMedia.add(media);
      }
    } else {
      // Show a snackbar or toast about max selection
      Get.snackbar(
        'Maximum Limit Reached',
        'You can select up to 10 media files',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> initializeCameraController() async {
    if (cameras.isNotEmpty) {
      cameraController.value = CameraController(
        cameras[0],
        ResolutionPreset.high,
        enableAudio: true, // Enable audio for video recording
      );

      try {
        await cameraController.value?.initialize();
        isCameraMode.value = true;
      } catch (e) {
        _handleError(e, 'Initializing camera');
        isCameraMode.value = false;
      }
    }
  }

  Future<void> capturePhoto() async {
    if (cameraController.value != null &&
        cameraController.value!.value.isInitialized) {
      try {
        final image = await cameraController.value!.takePicture();
        capturedMedia.value = File(image.path);

        // Add the captured photo to selected media
        final asset = await PhotoManager.editor.saveImageWithPath(image.path);
        if (!isMultiSelectEnabled.value) {
          selectedMedia.clear();
        }

        // Add the new asset to selected media
        if (selectedMedia.length < 10) {
          selectedMedia.add(asset);

          // Update all media list to include the new asset at the beginning
          allMedia.insert(0, asset);
        } else {
          Get.snackbar(
            'Maximum Limit Reached',
            'You can select up to 10 media files',
            snackPosition: SnackPosition.BOTTOM,
          );
        }

        isCameraMode.value = false;
      } catch (e) {
        _handleError(e, 'Capturing photo');
      }
    }
  }

  Future<void> recordVideo() async {
    if (cameraController.value != null &&
        cameraController.value!.value.isInitialized) {
      try {
        // Start video recording
        await cameraController.value!.startVideoRecording();
      } catch (e) {
        _handleError(e, 'Starting video recording');
      }
    }
  }

  Future<void> stopVideoRecording() async {
    if (cameraController.value != null &&
        cameraController.value!.value.isRecordingVideo) {
      try {
        final video = await cameraController.value!.stopVideoRecording();
        capturedMedia.value = File(video.path);

        // Add the captured video to selected media
        final asset = await PhotoManager.editor.saveVideo(capturedMedia.value!);
        if (!isMultiSelectEnabled.value) {
          selectedMedia.clear();
        }

        // Add the new asset to selected media
        if (selectedMedia.length < 10) {
          selectedMedia.add(asset);

          // Update all media list to include the new asset at the beginning
          allMedia.insert(0, asset);
        } else {
          Get.snackbar(
            'Maximum Limit Reached',
            'You can select up to 10 media files',
            snackPosition: SnackPosition.BOTTOM,
          );
        }

        isCameraMode.value = false;
      } catch (e) {
        _handleError(e, 'Stopping video recording');
      }
    }
  }

  void removeCapturedMedia() {
    capturedMedia.value = null;
    selectedMedia.clear();
    isCameraMode.value = false;
  }

  void _handleError(dynamic error, String context) {
    // Log the error
    log('$context: $error');

    // Set user-friendly error message
    errorMessage.value = 'Failed to $context. Please try again.';
  }

  void toggleMultiSelect() {
    isMultiSelectEnabled.toggle();
    if (!isMultiSelectEnabled.value) {
      // Clear selections when multi-select is turned off
      selectedMedia.clear();
    }
  }

  Future<List<MediaFile>> convertAssetsToMediaFiles(
      List<AssetEntity> assets) async {
    List<MediaFile> mediaFiles = [];
    for (var asset in assets) {
      MediaType mediaType =
          asset.type == AssetType.image ? MediaType.image : MediaType.video;

      dynamic file;
      if (mediaType == MediaType.image) {
        // Load the image file as Uint8List
        var fileData = await asset.file;
        if (fileData != null) {
          file = await fileData.readAsBytes(); // Get image bytes (Uint8List)
        }
      } else if (mediaType == MediaType.video) {
        file =
            asset; // For video, you can pass the AssetEntity or video file path
      }

      mediaFiles.add(MediaFile(file: file, type: mediaType));
    }
    return mediaFiles;
  }

  // Proceed to next screen (editing/filtering)
  void proceedToNextScreen() async {
    if (selectedMedia.isNotEmpty) {
      final mediaFiles = await convertAssetsToMediaFiles(selectedMedia);
      Get.to(() => AddPostDetails(
            editedImages: mediaFiles,
          ));
    }
  }

  @override
  void onClose() {
    // Clean up camera controller
    cameraController.value?.dispose();
    super.onClose();
  }
}
