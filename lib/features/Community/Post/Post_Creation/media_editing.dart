import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:image_editor_plus/options.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:image/image.dart' as img;

import '../../../../core/Controllers/community_controller/post_creation_controller.dart';
import 'add_post_details.dart';

class ImageEditorWorkflow extends StatefulWidget {
  final List<AssetEntity> selectedImages;

  const ImageEditorWorkflow({Key? key, required this.selectedImages})
      : super(key: key);

  @override
  _ImageEditorWorkflowState createState() => _ImageEditorWorkflowState();
}

class _ImageEditorWorkflowState extends State<ImageEditorWorkflow> {
  final _controller = Get.put(PostCreationController());

  List<EditableImage> _editableImages = [];

  @override
  void initState() {
    super.initState();
    _prepareImagesForEditing();
  }

  Future<void> _prepareImagesForEditing() async {
    final images = await Future.wait(
      widget.selectedImages.map((asset) async {
        final file = await asset.file;
        if (file == null) return null;

        // Read the image file
        Uint8List imageBytes = file.readAsBytesSync();

        // Ensure image is in a compatible format
        img.Image? image = img.decodeImage(imageBytes);
        if (image == null) return null;

        // Encode to PNG to ensure compatibility
        Uint8List convertedBytes = Uint8List.fromList(img.encodePng(image));

        return EditableImage(
          originalFile: file,
          originalBytes: convertedBytes,
        );
      }),
    );

    // Remove any null entries
    setState(() {
      _editableImages = images.whereType<EditableImage>().toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit',
          style: TextStyle(fontSize: 18),
        ),
        actions: [
          TextButton(
            onPressed: _processEditedImages,
            child: Text('Next',
                style: TextStyle(color: Colors.blue, fontSize: 16)),
          ),
        ],
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Icon(
            Icons.close,
            size: 26,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: _editableImages.isEmpty
            ? Center(child: CircularProgressIndicator())
            : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                ),
                itemCount: _editableImages.length,
                itemBuilder: (context, index) {
                  return _buildEditableImageTile(index);
                },
              ),
      ),
    );
  }

  Widget _buildEditableImageTile(int index) {
    final image = _editableImages[index];
    return GestureDetector(
      onTap: () => _editImage(index),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.memory(
            image.editedBytes ?? image.originalBytes,
            fit: BoxFit.fill,
            errorBuilder: (context, error, stackTrace) {
              print('Image load error: $error');
              return Center(child: Icon(Icons.error));
            },
            // height: 100,
          ),
          Positioned(
            top: 8,
            right: 8,
            child: Icon(
              Icons.edit,
              color: Colors.white,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _editImage(int index) async {
    try {
      // Convert File to Uint8List for ImageEditorPlus
      final imageBytes = _editableImages[index].originalBytes;

      final editedImage = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImageEditor(
            image: imageBytes,
            cropOption: CropOption(),
            brushOption: BrushOption(),
            textOption: TextOption(),
            rotateOption: RotateOption(),
            flipOption: FlipOption(),
          ),
        ),
      );

      if (editedImage != null) {
        setState(() {
          _editableImages[index] = EditableImage(
            originalFile: _editableImages[index].originalFile,
            originalBytes: _editableImages[index].originalBytes,
            editedBytes: editedImage,
          );
        });
      }
    } catch (e) {
      print('Error editing image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to edit image: $e')),
      );
    }
  }

  void _processEditedImages() {
    // Update the selectedMedia list in the controller
    _controller.selectedMedia.value = _editableImages.map((image) {
      return MediaFile(
        file: image.editedBytes ?? image.originalBytes,
        type: MediaType.image,
      );
    }).toList();

    // Navigate to AddPostDetails
    Get.to(() => AddPostDetails(editedImages: _controller.selectedMedia));
  }
}

class EditableImage {
  final File originalFile;
  final Uint8List originalBytes;
  final Uint8List? editedBytes;

  EditableImage({
    required this.originalFile,
    required this.originalBytes,
    this.editedBytes,
  });
}
