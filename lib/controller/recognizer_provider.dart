import 'dart:io';

import 'package:flutter/cupertino.dart';

import '../model/hive_model.dart';

class TextRecognizerProvider with ChangeNotifier{
   List<RecognizedTextModel> recognizedTextList = [];
  File? selectedImage;
  String recognizedText = '';
  
   

}