import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  UserImagePicker(this.imagePicker);
  final Function imagePicker;
  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File pickedImage;

  Future<PickedFile> _selectionDialog(BuildContext context) async {
    final imagePicker = ImagePicker();
    PickedFile pickedFile;
    await showDialog(
        context: context,
        builder: (ctx) {
          return SimpleDialog(
            title: Text('Select your preferred method'),
            children: <Widget>[
              FlatButton.icon(
                onPressed: () async {
                  pickedFile = await imagePicker.getImage(
                    source: ImageSource.gallery,
                    imageQuality: 50,
                  );
                  Navigator.pop(context);
                },
                icon: Icon(Icons.image),
                label: Text('Gallery'),
              ),
              FlatButton.icon(
                onPressed: () async {
                  pickedFile =
                      await imagePicker.getImage(source: ImageSource.camera);
                  Navigator.pop(context);
                },
                icon: Icon(Icons.camera),
                label: Text('Take a Picture'),
              ),
            ],
          );
        });
    return pickedFile;
  }

  void _pickImage(BuildContext context) async {
    final pickedImageFile = await _selectionDialog(context);
    // final imagePicker = ImagePicker();
    // final pickedImageFile = await imagePicker.getImage(source: ImageSource.camera);
    setState(() {
      pickedImage = File(pickedImageFile.path);
    });
    widget.imagePicker(pickedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 40,
          backgroundImage: pickedImage == null ? null : FileImage(pickedImage),
        ),
        FlatButton.icon(
          textColor: Theme.of(context).primaryColor,
          onPressed: () {
            _pickImage(context);
          },
          icon: Icon(Icons.image),
          label: Text('Select Image'),
        ),
      ],
    );
  }
}
