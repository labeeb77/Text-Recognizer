import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:share_plus/share_plus.dart';
import 'package:text_recognizer/screens/textediting_screen.dart';
import 'package:text_recognizer/screens/widgets/fullscreen_image.dart';

class TextEditorScreen extends StatefulWidget {
  final String recognizedText;
  final File? selectedImage;
  const TextEditorScreen(
      {super.key, required this.recognizedText, required this.selectedImage});

  @override
  State<TextEditorScreen> createState() => _TextEditorScreenState();
}

class _TextEditorScreenState extends State<TextEditorScreen> {
  String allText = '';
  @override
  void initState() {
    super.initState();
    allText = widget.recognizedText;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[100],
        title: Text("Details", style: GoogleFonts.prompt(fontSize: 20)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(children: [
              Positioned(
                bottom: 30,
                right: 10,
                child: widget.selectedImage != null
                    ? Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.purple,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: InkWell(
                            onTap: () {
                              log('Tapped');
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => FullScreenImage(
                                      imageFile: widget.selectedImage!),
                                ),
                              );
                            },
                            child: Image.file(
                              widget.selectedImage!,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      )
                    : Container(),
              ),
              Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                      width: 320,
                      child: Text(
                        allText,
                        style: const TextStyle(height: 2, fontSize: 17),
                      ))),
            ]),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () async {
                  final editedText = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          TextEditScreen(initialText: allText),
                    ),
                  );

                  if (editedText != null) {
                    setState(() {
                      allText = editedText;
                    });
                  }
                },
                icon: const Icon(Icons.edit),
              ),
              IconButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: allText));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Text copied to clipboard"),
                    ),
                  );
                },
                icon: const Icon(Icons.copy),
              ),
              IconButton(
                onPressed: () {
                  Share.share(allText);
                },
                icon: const Icon(Icons.share),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
