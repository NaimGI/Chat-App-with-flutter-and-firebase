import 'dart:ffi';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';

class imgPiker extends StatefulWidget {
  imgPiker(this.ImgPikerFn);
  Function(File piketImg) ImgPikerFn;

  @override
  State<imgPiker> createState() => _imgPikerState();
}

class _imgPikerState extends State<imgPiker> {
  File? _piketImg = null;
  void _pikeImage() async {
    print("hello");
    final Img = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 50, maxWidth: 150);
    setState(() {
      _piketImg = File(Img!.path);
    });
    widget.ImgPikerFn(_piketImg!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          backgroundImage: _piketImg != null ? FileImage(_piketImg!) : null,
        ),
        OutlinedButton(
          onPressed: _pikeImage,
          child: const Text("add image"),
        ),
      ],
    );
  }
}
