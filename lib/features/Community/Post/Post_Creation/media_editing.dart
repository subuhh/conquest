// import 'dart:io';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:image_editor_plus/image_editor_plus.dart';
// import 'package:photo_manager/photo_manager.dart';
// import 'package:video_player/video_player.dart';
// import 'package:video_trimmer/video_trimmer.dart';
//
// class MediaEditingWorkflow extends StatefulWidget {
//   final List<AssetEntity> selectedMedia;
//
//   const MediaEditingWorkflow({Key? key, required this.selectedMedia})
//       : super(key: key);
//
//   @override
//   _MediaEditingWorkflowState createState() => _MediaEditingWorkflowState();
// }
//
// class _MediaEditingWorkflowState extends State<MediaEditingWorkflow> {
//   late List<EditableMediaItem> _editableMedia = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _prepareMediaForEditing();
//   }
//
//   void _prepareMediaForEditing() async {
//     _editableMedia = await Future.wait(widget.selectedMedia.map((asset) async {
//       final file = await asset.file;
//       return EditableMediaItem(
//         originalFile: file!,
//         type: asset.type == AssetType.video ? MediaType.video : MediaType.image,
//       );
//     }).toList());
//     setState(() {});
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _editableMedia.isEmpty
//           ? Center(child: CircularProgressIndicator())
//           : MediaSelectionEditingScreen(
//         editableMedia: _editableMedia,
//         onMediaEdited: (editedMedia) {
//           setState(() {
//             _editableMedia = editedMedia;
//           });
//         },
//       ),
//     );
//   }
// }
//
// class MediaSelectionEditingScreen extends StatefulWidget {
//   final List<EditableMediaItem> editableMedia;
//   final Function(List<EditableMediaItem>) onMediaEdited;
//
//   const MediaSelectionEditingScreen({
//     Key? key,
//     required this.editableMedia,
//     required this.onMediaEdited,
//   }) : super(key: key);
//
//   @override
//   _MediaSelectionEditingScreenState createState() =>
//       _MediaSelectionEditingScreenState();
// }
//
// class _MediaSelectionEditingScreenState
//     extends State<MediaSelectionEditingScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Selected Media'),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => MediaDetailScreen(
//                     editableMedia: widget.editableMedia,
//                     onMediaEdited: widget.onMediaEdited,
//                   ),
//                 ),
//               );
//             },
//             child: Text('Next', style: TextStyle(color: Colors.white)),
//           ),
//         ],
//       ),
//       body: GridView.builder(
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 3,
//           crossAxisSpacing: 4,
//           mainAxisSpacing: 4,
//         ),
//         itemCount: widget.editableMedia.length,
//         itemBuilder: (context, index) {
//           final media = widget.editableMedia[index];
//           return GestureDetector(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => MediaEditScreen(
//                     mediaItem: media,
//                     onMediaEdited: (editedMedia) {
//                       setState(() {
//                         widget.editableMedia[index] = editedMedia;
//                         widget.onMediaEdited(widget.editableMedia);
//                       });
//                     },
//                   ),
//                 ),
//               );
//             },
//             child: Stack(
//               fit: StackFit.expand,
//               children: [
//                 media.type == MediaType.image
//                     ? Image.file(
//                   media.editedFile ?? media.originalFile,
//                   fit: BoxFit.cover,
//                 )
//                     : VideoPlayerWidget(videoFile: media.originalFile),
//                 if (media.editedFile != null)
//                   Positioned(
//                     top: 8,
//                     right: 8,
//                     child: Icon(
//                       Icons.edit,
//                       color: Colors.white,
//                       size: 20,
//                     ),
//                   ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
//
// class MediaEditScreen extends StatefulWidget {
//   final EditableMediaItem mediaItem;
//   final Function(EditableMediaItem) onMediaEdited;
//
//   const MediaEditScreen({
//     Key? key,
//     required this.mediaItem,
//     required this.onMediaEdited,
//   }) : super(key: key);
//
//   @override
//   _MediaEditScreenState createState() => _MediaEditScreenState();
// }
//
// class _MediaEditScreenState extends State<MediaEditScreen> {
//   VideoPlayerController? _videoPlayerController;
//   Trimmer? _videoTrimmer;
//   Uint8List? _editedImageData;
//   bool _isEdited = false;
//
//   @override
//   void initState() {
//     super.initState();
//     if (widget.mediaItem.type == MediaType.video) {
//       _initVideoController();
//     }
//   }
//
//   void _initVideoController() {
//     _videoPlayerController = VideoPlayerController.file(widget.mediaItem.originalFile)
//       ..initialize().then((_) {
//         setState(() {});
//         _videoPlayerController?.setVolume(0);
//       });
//
//     _videoTrimmer = Trimmer();
//     _videoTrimmer!.loadVideo(videoFile: widget.mediaItem.originalFile);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Edit Media'),
//         actions: [
//           if (_isEdited)
//             TextButton(
//               onPressed: _saveEdits,
//               child: Text('Save', style: TextStyle(color: Colors.white)),
//             ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             // Media Preview
//             widget.mediaItem.type == MediaType.image
//                 ? _buildImageEditor()
//                 : _buildVideoEditor(),
//
//             // Editing Options
//             _buildEditingOptions(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildImageEditor() {
//     return Image.memory(
//       _editedImageData ?? Uint8List.fromList(widget.mediaItem.originalFile.readAsBytesSync()),
//       height: 400,
//       fit: BoxFit.contain,
//     );
//   }
//
//   Widget _buildVideoEditor() {
//     return _videoTrimmer == null
//         ? CircularProgressIndicator()
//         : Column(
//       children: [
//         VideoPlayer(_videoPlayerController!),
//         VideoProgressIndicator(
//           _videoPlayerController!,
//           allowScrubbing: true,
//         ),
//       ],
//     );
//   }
//
//   Widget _buildEditingOptions() {
//     return Wrap(
//       spacing: 8,
//       runSpacing: 8,
//       children: [
//         // Image Specific Edits
//         if (widget.mediaItem.type == MediaType.image) ...[
//           ElevatedButton.icon(
//             onPressed: _cropImage,
//             icon: Icon(Icons.crop),
//             label: Text('Crop'),
//           ),
//           ElevatedButton.icon(
//             onPressed: _adjustImage,
//             icon: Icon(Icons.brightness_6),
//             label: Text('Adjust'),
//           ),
//           ElevatedButton.icon(
//             onPressed: _addTextToImage,
//             icon: Icon(Icons.text_fields),
//             label: Text('Add Text'),
//           ),
//         ],
//
//         // Video Specific Edits
//         if (widget.mediaItem.type == MediaType.video) ...[
//           ElevatedButton.icon(
//             onPressed: _trimVideo,
//             icon: Icon(Icons.cut),
//             label: Text('Trim'),
//           ),
//           ElevatedButton.icon(
//             onPressed: _applyVideoFilter,
//             icon: Icon(Icons.filter),
//             label: Text('Filter'),
//           ),
//         ],
//       ],
//     );
//   }
//
//   void _cropImage() async {
//     Uint8List imageBytes = _editedImageData ?? Uint8List.fromList(widget.mediaItem.originalFile.readAsBytesSync());
//
//     // Replace with the correct usage of ImageEditorPlus
//     Uint8List? editedImage = await ImageEditor(image: imageBytes).editImage({
//       ImageEditorOption.crop(
//         CropOption(x: 0, y: 0, width: 100, height: 100),
//       ),
//     });
//
//     if (editedImage != null) {
//       setState(() {
//         _editedImageData = editedImage;
//         _isEdited = true;
//       });
//     }
//   }
//
//   void _adjustImage() async {
//     Uint8List imageBytes = _editedImageData ?? Uint8List.fromList(widget.mediaItem.originalFile.readAsBytesSync());
//
//     // Replace with the correct usage of ImageEditorPlus
//     Uint8List? editedImage = await ImageEditor(image: imageBytes).editImage({
//       ImageEditorOption.adjust(
//         BrightnessOption(0.5),
//       ),
//     });
//
//     if (editedImage != null) {
//       setState(() {
//         _editedImageData = editedImage;
//         _isEdited = true;
//       });
//     }
//   }
//
//   void _addTextToImage() async {
//     Uint8List imageBytes = _editedImageData ?? Uint8List.fromList(widget.mediaItem.originalFile.readAsBytesSync());
//
//     // Replace with the correct usage of ImageEditorPlus
//     Uint8List? editedImage = await ImageEditor(image: imageBytes,textOption: TextOption(
//       text: 'Sample Text',
//       x: 50,
//       y: 50,
//     ),,)
//     });
//
//     if (editedImage != null) {
//       setState(() {
//         _editedImageData = editedImage;
//         _isEdited = true;
//       });
//     }
//   }
//
//   void _trimVideo() {
//     if (_videoTrimmer != null) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => TrimmerView(trimmer: _videoTrimmer!),
//         ),
//       ).then((trimmedFile) {
//         if (trimmedFile != null) {
//           setState(() {
//             widget.onMediaEdited(
//               EditableMediaItem(
//                 originalFile: widget.mediaItem.originalFile,
//                 type: MediaType.video,
//                 editedFile: trimmedFile,
//               ),
//             );
//             _isEdited = true;
//           });
//         }
//       });
//     }
//   }
//
//   void _applyVideoFilter() {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Video filter functionality coming soon!')),
//     );
//   }
//
//   void _saveEdits() {
//     if (widget.mediaItem.type == MediaType.image && _editedImageData != null) {
//       File editedImageFile = File('${widget.mediaItem.originalFile.parent.path}/edited_image.png')
//         ..writeAsBytesSync(_editedImageData!);
//
//       widget.onMediaEdited(
//         EditableMediaItem(
//           originalFile: widget.mediaItem.originalFile,
//           type: MediaType.image,
//           editedFile: editedImageFile,
//         ),
//       );
//     }
//
//     Navigator.pop(context);
//   }
//
//   @override
//   void dispose() {
//     _videoPlayerController?.dispose();
//     super.dispose();
//   }
// }
//
// class MediaDetailScreen extends StatelessWidget {
//   final List<EditableMediaItem> editableMedia;
//   final Function(List<EditableMediaItem>) onMediaEdited;
//
//   const MediaDetailScreen({
//     Key? key,
//     required this.editableMedia,
//     required this.onMediaEdited,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Media Details'),
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Media Preview
//             _buildMediaPreview(),
//
//             SizedBox(height: 16),
//
//             // Caption Input
//             TextField(
//               decoration: InputDecoration(
//                 labelText: 'Write a caption...',
//                 border: OutlineInputBorder(),
//               ),
//               maxLines: 3,
//             ),
//
//             SizedBox(height: 16),
//
//             // Location
//             ListTile(
//               leading: Icon(Icons.location_on),
//               title: Text('Add Location'),
//               trailing: Icon(Icons.add),
//               onTap: () {
//                 // TODO: Implement location selection
//               },
//             ),
//
//             // Tag People
//             ListTile(
//               leading: Icon(Icons.people),
//               title: Text('Tag People'),
//               trailing: Icon(Icons.add),
//               onTap: () {
//                 // TODO: Implement people tagging
//               },
//             ),
//
//             // Post Button
//             SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () {
//                 // TODO: Implement post creation
//                 // Access the edited media through editableMedia
//               },
//               child: Text('Post'),
//               style: ElevatedButton.styleFrom(
//                 minimumSize: Size(double.infinity, 50),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildMediaPreview() {
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: Row(
//         children: editableMedia
//             .map((media) => Container(
//           margin: EdgeInsets.all(8),
//           width: 100,
//           height: 100,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(10),
//             image: DecorationImage(
//               image: FileImage(media.editedFile ?? media.originalFile),
//               fit: BoxFit.cover,
//             ),
//           ),
//         ))
//             .toList(),
//       ),
//     );
//   }
// }
//
// class VideoPlayerWidget extends StatefulWidget {
//   final File videoFile;
//
//   const VideoPlayerWidget({Key? key, required this.videoFile}) : super(key: key);
//
//   @override
//   _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
// }
//
// class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
//   late VideoPlayerController _controller;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.file(widget.videoFile)
//       ..initialize().then((_) {
//         setState(() {});
//         _controller.setVolume(0);
//       });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return _controller.value.isInitialized
//         ? AspectRatio(
//       aspectRatio: _controller.value.aspectRatio,
//       child: VideoPlayer(_controller),
//     )
//         : CircularProgressIndicator();
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
// }
//
// enum MediaType { image, video }
//
// class EditableMediaItem {
//   final File originalFile;
//   final MediaType type;
//   final File? editedFile;
//
//   EditableMediaItem({
//     required this.originalFile,
//     required this.type,
//     this.editedFile,
//   });
// }
//
// class TrimmerView extends StatelessWidget {
//   final Trimmer trimmer;
//
//   const TrimmerView({Key? key, required this.trimmer}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Trim Video'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: VideoEditor(
//               trimmer: trimmer,
//               trimStyle: TrimStyle(
//                 lineWidth: 4,
//                 borderRadius: 10,
//                 iconColor: Colors.white,
//                 iconSize: 30,
//               ),
//             ),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               await trimmer.saveTrimmedVideo(
//                 startValue: trimmer.startValue,
//                 endValue: trimmer.endValue,
//                 onSave: (outputFile) {
//                   Navigator.pop(context, outputFile);
//                 },
//               );
//             },
//             child: Text('Save Trimmed Video'),
//           ),
//         ],
//       ),
//     );
//   }
// }
