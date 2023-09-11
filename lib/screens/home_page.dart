import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:text_recognizer/model/hive_model.dart';
import 'package:text_recognizer/screens/texteditor_screen.dart';

import 'package:text_recognizer/screens/widgets/bottomsheet_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<RecognizedTextModel> recognizedTextList = [];
  File? selectedImage;
  String recognizedText = '';
  @override
  void initState() {
    retrieveDataFromHive();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Text Recognizer"),
        leading: IconButton(
            onPressed: () {
              showBottomSheetWidget(context);
            },
            icon: const Icon(Icons.menu)),
      ),
      body:  SafeArea(
          child: Column(
        children: [
          Expanded(
            child:ListView.builder(
  itemBuilder: (context, index) {
    final recognizedTextModel = recognizedTextList[index];
    final imageFile = File(recognizedTextModel.imagePath);

    return GestureDetector(
      onTap: () {
        // Navigate to the TextEditorScreen and pass the recognized text
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => TextEditorScreen(
              recognizedText: recognizedTextModel.text,
              selectedImage: imageFile,
            ),
          ),
        );
      },
      child: Card(
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.file(imageFile),
            ),
          ),
          title: Text(
            recognizedTextModel.text,
            style: const TextStyle(fontSize: 16),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Row(
            children: [
              Text(
                formatTimestamp(recognizedTextModel.timestamp),
                style: TextStyle(color: Colors.grey[700]),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(
                    text: recognizedTextModel.text,
                  ));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Text copied to clipboard"),
                    ),
                  );
                },
                icon: Icon(Icons.copy, size: 20, color: Colors.grey[700]),
              ),
              IconButton(
                onPressed: () {
                  Share.share(recognizedTextModel.text);
                },
                icon: Icon(Icons.share, size: 20, color: Colors.grey[700]),
              ),
            ],
          ),
        ),
      ),
    );
  },
  itemCount: recognizedTextList.length,
)
,
          )
        ],
      )),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          pickImage();
        },
        icon: const Icon(Icons.add),
        label: const Text('Add New'),
      ),
    );
  }

  // Select Image

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      cropImage(pickedFile.path);
    }
  }

 Future<void> cropImage(String imagePath) async {
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
    setState(() {
      selectedImage = imageFile ;
    });
    recognizeText();
    
  }
}


  // Recognize text

  Future<void> recognizeText() async {
    log('entered to recognizer');
    if (selectedImage != null) {
      final inputImage = InputImage.fromFilePath(selectedImage!.path);
      final textRecognizer = GoogleMlKit.vision.textRecognizer();

      try {
        final RecognizedText visionText =
            await textRecognizer.processImage(inputImage);

        final recognizedText = visionText.text;
        saveRecognizedText(recognizedText,selectedImage!);
      

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
  setState(() {
    recognizedTextList = reversedRecords.cast<RecognizedTextModel>();
  });
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


 
}