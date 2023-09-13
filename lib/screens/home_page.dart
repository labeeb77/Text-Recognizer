
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import 'package:text_recognizer/controller/recognizer_provider.dart';

import 'package:text_recognizer/screens/texteditor_screen.dart';

import 'package:text_recognizer/screens/widgets/bottomsheet_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider =
        Provider.of<TextRecognizerProvider>(context);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      provider.retrieveDataFromHive();
    });
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.deepPurple[100],
        title: const Text("Text Recognizer"),
        leading: IconButton(
            onPressed: () {
              showBottomSheetWidget(context);
            },
            icon: const Icon(Icons.menu)),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: provider.recognizedTextList.isEmpty
            ? const Center(
                child: Text(
                  'Please select an image using button below to recognize the text',
                  textAlign: TextAlign.center,
                ),
              )
            : Column(
                children: [
                  Expanded(
                    child: Consumer<TextRecognizerProvider>(
                      builder: (context, value, child) => ListView.builder(
                        itemBuilder: (context, index) {
                          final recognizedTextModel =
                              value.recognizedTextList[index];
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
                                      value.formatTimestamp(
                                          recognizedTextModel.timestamp),
                                      
                                    ),
                                    const Spacer(),
                                    IconButton(
                                      onPressed: () {
                                        Clipboard.setData(ClipboardData(
                                          text: recognizedTextModel.text,
                                        ));
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                "Text copied to clipboard"),
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.copy,
                                          size: 20,),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        Share.share(recognizedTextModel.text);
                                      },
                                      icon: const Icon(Icons.share,
                                          size: 20,),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: value.recognizedTextList.length,
                      ),
                    ),
                  )
                ],
              ),
      )),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.deepPurple[100],
        onPressed: () {
          Provider.of<TextRecognizerProvider>(context, listen: false)
              .pickImage(context);
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Image'),
      ),
    );
  }
}
