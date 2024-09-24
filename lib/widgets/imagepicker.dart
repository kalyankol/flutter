import 'package:flutter/material.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
class UserImage extends StatefulWidget {
  const UserImage({super.key});

  @override
  State<UserImage> createState() => _UserImageState();
}

class _UserImageState extends State<UserImage> {
  File? PickedImage;

  void _pickImage() async{

    final Image = await ImagePicker().pickImage(source: ImageSource.camera);

    if(Image==null){
      return;
    }

    setState(() {
      PickedImage=File(Image.path);
    });

  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          foregroundImage: PickedImage!=null ? FileImage(PickedImage!) : null,
        ),
        TextButton.icon(onPressed: _pickImage, label: Text("Add Image",style: TextStyle(color: Theme.of(context).primaryColor),),icon: const Icon(Icons.image),)
      ],
    );
  }
}