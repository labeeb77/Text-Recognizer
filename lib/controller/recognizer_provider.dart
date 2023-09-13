import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:text_recognizer/screens/texteditor_screen.dart';

import '../model/hive_model.dart';
import 'ads_controller.dart';

class TextRecognizerProvider with ChangeNotifier{
   List<RecognizedTextModel> recognizedTextList = [];
  File? selectedImage;
  String recognizedText = '';
   String allText = '';
   

   void setRecognizedTextList(List<RecognizedTextModel> newList) {
    recognizedTextList = newList;
    notifyListeners();
  }


   void setSelectedImage(File? imageFile) {
    selectedImage = imageFile;
    notifyListeners();
  }

  void setAllText(String newText) {
    allText = newText;
    notifyListeners();
  }


   Future<void> pickImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      cropImage(context,pickedFile.path);
    }
  }

 Future<void> cropImage(BuildContext context, String imagePath) async {
  final adsProvider = Provider.of<AdsProvider>(context,listen: false);
  adsProvider.loadInterstitialAd();
  CroppedFile? croppedImage = await ImageCropper().cropImage(
    sourcePath: imagePath,
    aspectRatio: const CropAspectRatio(
        ratioX: 1, ratioY: 1), // Adjust aspect ratio as needed
    compressQuality: 100, // Image quality (0 - 100)
    maxHeight: 500, // Maximum cropped image height
    maxWidth: 500, // Maximum cropped image width
  );

  if (croppedImage != null) {
    File imageFile = File(croppedImage.path); // Convert CroppedFile to File
  setSelectedImage(imageFile);

   // Show the ad before navigating to the TextEditorScreen
    if (adsProvider.isAdLoaded) {
    await adsProvider. interstitialAd.show();
    }
    recognizeText(context);
  
    
  }
}



Future<void> recognizeText(BuildContext context) async {
    log('entered to recognizer');
    if (selectedImage != null) {
      final inputImage = InputImage.fromFilePath(selectedImage!.path);
      final textRecognizer = GoogleMlKit.vision.textRecognizer();

      try {
        final RecognizedText visionText =
            await textRecognizer.processImage(inputImage);

        final recognizedText = visionText.text;
        saveRecognizedText(recognizedText,selectedImage!);
       
    retrieveDataFromHive();

        textRecognizer.close();

        

        

        // Navigate to the TextEditorScreen and pass the recognized text
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                TextEditorScreen(recognizedText: recognizedText,selectedImage: selectedImage!),
          ),
        );
      } catch (e) {
        log('Error recognizing text: $e');
      }
    }
  }


    // Save to Hive

  Future<void> saveRecognizedText(String text, File selectedImage) async {
 final recognizedText = text;
final timestamp = DateTime.now();

final recognizedTextModel = RecognizedTextModel(recognizedText, timestamp,selectedImage.path);

// Open the Hive box
final box = await Hive.openBox<RecognizedTextModel>('recognizedText');

// Add the recognized text to Hive
await box.add(recognizedTextModel);




}



Future<void> retrieveDataFromHive() async {
  // Open the Hive box
  final box = await Hive.openBox<RecognizedTextModel>('recognizedText');

  // Retrieve the stored records from the box
  final savedRecords = box.values.toList();
final reversedRecords = savedRecords.reversed.toList();
  // Update recognizedTextList with the retrieved records
setRecognizedTextList(reversedRecords);
}





String formatTimestamp(DateTime timestamp) {
  final now = DateTime.now();
  final difference = now.difference(timestamp);

  if (difference.inMinutes < 1) {
    return 'just now';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes} min ago';
  } else if (difference.inHours < 24) {
    return '${difference.inHours} hours ago';
  } else {
    return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
  }
}

Future<void> clearDataFromHive() async {
  final box = await Hive.openBox<RecognizedTextModel>('recognizedText');
  await box.clear();

  retrieveDataFromHive();
}


  


}