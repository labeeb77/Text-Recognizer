import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FullScreenImage extends StatelessWidget {
  final File imageFile;

  FullScreenImage({required this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: Center(
        child: Image.file(
          imageFile,
          // You can customize the width, height, and fit properties here
        ),
      ),
    );
  }
}
