import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Modals {
  static final ImagePicker _picker = ImagePicker();

  static Future<XFile?> openModalForImageSource(
    BuildContext context, {
    int? imageQuality,
    double? maxHeight,
    double? minWidth,
  }) async {
    ImageSource? imageSource = await showModalBottomSheet<ImageSource?>(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () => Navigator.pop(context, ImageSource.camera)),
          ListTile(
              leading: const Icon(Icons.browse_gallery),
              title: const Text('Gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery)),
        ],
      ),
    );
    if (imageSource != null) {
      final XFile? image = await _picker.pickImage(
        source: imageSource,
        imageQuality: imageQuality,
        maxHeight: maxHeight,
        maxWidth: minWidth,
      );
      return image;
    }
    return null;
  }
}
