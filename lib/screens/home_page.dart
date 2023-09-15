import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import 'package:text_recognizer/controller/recognizer_provider.dart';

import 'package:text_recognizer/screens/texteditor_screen.dart';

import 'package:text_recognizer/screens/widgets/bottomsheet_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TextRecognizerProvider>(context);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      provider.retrieveDataFromHive();
    });

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.deepPurple[100],
        title: Text(
          "Text Recognizer",
          style: GoogleFonts.prompt(fontSize: 20),
        ),
        leading: IconButton(
          onPressed: () {
            showBottomSheetWidget(context);
          },
          icon: const Icon(Icons.menu),
        ),
      ),
      body: SafeArea(
        child: provider.recognizedTextList.isEmpty
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.image,
                      size: 60,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No recognized text found. \nPlease select an image',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: provider.recognizedTextList.length,
                itemBuilder: (context, index) {
                  final recognizedTextModel =
                      provider.recognizedTextList[index];
                  final imageFile = File(recognizedTextModel.imagePath);

                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => TextEditorScreen(
                            recognizedText: recognizedTextModel.text,
                            selectedImage: imageFile,
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              12), // Adjust the radius as needed
                        ),
                        elevation: 5,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: FileImage(imageFile),
                                fit: BoxFit.cover,
                              ),
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
                                provider.formatTimestamp(
                                    recognizedTextModel.timestamp),
                                style: const TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                onPressed: () {
                                  Clipboard.setData(ClipboardData(
                                    text: recognizedTextModel.text,
                                  ));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Text copied to clipboard",
                                      ),
                                    ),
                                  );
                                },
                                icon: Icon(
                                  Icons.copy,
                                  size: 20,
                                  color: Colors.deepPurple[100],
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  Share.share(recognizedTextModel.text);
                                },
                                icon: Icon(
                                  Icons.share,
                                  size: 20,
                                  color: Colors.deepPurple[100],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.deepPurple[100],
        onPressed: () {
          Provider.of<TextRecognizerProvider>(context, listen: false)
              .pickImage(context);
        },
        icon: const Icon(
          Icons.add_a_photo,
          size: 24,
          color: Colors.deepPurple,
        ),
        label: const Text(
          'Add Image',
          style: TextStyle(
            fontSize: 16,
            color: Colors.deepPurple,
          ),
        ),
      ),
    );
  }
}
