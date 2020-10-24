import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final void Function(PickedFile pickedImage) imagePickedFun;

  UserImagePicker(this.imagePickedFun);

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _images;
  final picker = ImagePicker();

  Future<void> imagePickerFile() async {
    final pickerFile = await picker.getImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150,
    );
    setState(() {
      _images = File(pickerFile.path);
    });
    widget.imagePickedFun(pickerFile);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          backgroundImage: _images == null ? null : FileImage(_images),
        ),
        FlatButton.icon(
          onPressed: imagePickerFile,
          icon: Icon(Icons.image),
          label: Text('Add Image'),
          textColor: Theme.of(context).primaryColor,
        ),
      ],
    );
  }
}
