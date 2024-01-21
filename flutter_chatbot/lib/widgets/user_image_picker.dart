//THis is not a screen here
//This code will be used to upload an image for the authenticated users
//THis widget will help to upload image for our app
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({super.key, required this.onPickImage});
  final void Function(File pickedImage) onPickImage;
  @override
  State<UserImagePicker> createState() {
    return _UserImageState();
  }
}

class _UserImageState extends State<UserImagePicker> {
  File? PickedImageFile;
  void _imagePick() async {
    final pickedImage = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 50, maxWidth: 130);
    if (pickedImage == null) {
      return;
    }
    setState(() {
      PickedImageFile = File(pickedImage.path);
    });

    widget.onPickImage(PickedImageFile!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          foregroundImage:
              PickedImageFile != null ? FileImage(PickedImageFile!) : null,
        ),
        TextButton.icon(
          onPressed: _imagePick,
          icon: const Icon(Icons.image),
          label: Text(
            'Add Image',
            style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
        )
      ],
    );
  }
}
