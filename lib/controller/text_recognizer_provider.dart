// import 'dart:developer';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:google_ml_kit/google_ml_kit.dart';
// import 'package:hive_flutter/adapters.dart';
// import 'package:image_cropper/image_cropper.dart';
// import 'package:image_picker/image_picker.dart';

// import '../model/hive_model.dart';
// import '../screens/texteditor_screen.dart';

// class TextRecognizerProvider with ChangeNotifier {
//   List<RecognizedTextModel> recognizedTextList = [];
//   File? selectedImage;
//   String recognizedText = '';

//   Future<void> pickImage(BuildContext conntext) async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);

//     if (pickedFile != null) {
//     await  cropImage(conntext, pickedFile.path);
//     }
//   }

  

//   Future<void> cropImage(BuildContext context, String imagePath) async {
//     CroppedFile? croppedImage = await ImageCropper().cropImage(
//       sourcePath: imagePath,
//       aspectRatio: const CropAspectRatio(
//           ratioX: 1, ratioY: 1), // Adjust aspect ratio as needed
//       compressQuality: 100, // Image quality (0 - 100)
//       maxHeight: 500, // Maximum cropped image height
//       maxWidth: 500, // Maximum cropped image width
//     );

//     if (croppedImage != null) {
//       File imageFile = File(croppedImage.path);
//       selectedImage = imageFile;
//     recognizeText(context);
//       Navigator.of(context).push(
//           MaterialPageRoute(
//             builder: (context) =>  TextEditorScreen(recognizedText: recognizedText,selectedImage: imageFile),
//           ),
//         );
//     }
//   }

//   Future<void> recognizeText(BuildContext context) async {
//     log('entered to recognizer');
//     if (selectedImage != null) {
//       final inputImage = InputImage.fromFilePath(selectedImage!.path);
//       final textRecognizer = GoogleMlKit.vision.textRecognizer();

//       try {
//         final RecognizedText visionText =
//             await textRecognizer.processImage(inputImage);

//         final recognizedText = visionText.text;
       
//         saveRecognizedText(recognizedText, selectedImage!);
//         retrieveDataFromHive();
//         notifyListeners();

//         textRecognizer.close();

//         // Navigate to the TextEditorScreen and pass the recognized text
      
//       } catch (e) {
//         log('Error recognizing text: $e');
//       }
//     }
//   }

//   Future<void> saveRecognizedText(String text, File selectedImage) async {
//     final recognizedText = text;
//     final timestamp = DateTime.now();

//     final recognizedTextModel =
//         RecognizedTextModel(recognizedText, timestamp, selectedImage.path);

// // Open the Hive box
//     final box = await Hive.openBox<RecognizedTextModel>('recognizedText');

// // Add the recognized text to Hive
//     await box.add(recognizedTextModel);
//     notifyListeners();
//   }

//   Future<void> retrieveDataFromHive() async {
//     // Open the Hive box
//     final box = await Hive.openBox<RecognizedTextModel>('recognizedText');

//     // Retrieve the stored records from the box
//     final savedRecords = box.values.toList();

//     final reversedRecords = savedRecords.reversed.toList();
//     recognizedTextList = reversedRecords.cast<RecognizedTextModel>();
//     // Update recognizedTextList with the retrieved records
//     notifyListeners();
//   }

//   String formatTimestamp(DateTime timestamp) {
//     final now = DateTime.now();
//     final difference = now.difference(timestamp);

//     if (difference.inMinutes < 1) {
//       return 'just now';
//     } else if (difference.inMinutes < 60) {
//       return '${difference.inMinutes} min ago';
//     } else if (difference.inHours < 24) {
//       return '${difference.inHours} hours ago';
//     } else {
//       return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
//     }
//   }
// Future<void> clearDataFromHive() async {
//   // Open the Hive box
//   final box = await Hive.openBox<RecognizedTextModel>('recognizedText');

//   // Clear all records in the box
//   await box.clear();

//   // Update recognizedTextList to an empty list
//   recognizedTextList.clear();
// log('app is reseted');
//   // Notify listeners to update the UI
//   notifyListeners();
// }

 


  
// }
