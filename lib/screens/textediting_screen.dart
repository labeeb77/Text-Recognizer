// text_edit_screen.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:text_recognizer/model/hive_model.dart';

class TextEditScreen extends StatefulWidget {
  final String initialText;

  TextEditScreen({required this.initialText});

  @override
  _TextEditScreenState createState() => _TextEditScreenState();
}

class _TextEditScreenState extends State<TextEditScreen> {
  TextEditingController textEditingController = TextEditingController();
  

  @override
  void initState() {
    super.initState();
    textEditingController.text = widget.initialText;
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Text"),
        actions: [
          IconButton(
            onPressed: () {
              updateTextAndSave();
              Navigator.of(context).pop(textEditingController.text);
            },
            icon: Icon(Icons.done),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: textEditingController,
          textAlign: TextAlign.start, // Align text to the left (start)
  textAlignVertical: TextAlignVertical.top,
          maxLines: null, // Allow multiple lines
          expands: true,
          decoration: InputDecoration(
             labelText: "Edit text...",
 border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[400]!),
          borderRadius: const BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(color: Colors.grey[400]!),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(color: Colors.grey[400]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(color: Colors.grey[400]!),
        ),
          ),
           style: const TextStyle(height: 2)
          
        ),
      ),
    );
  }


  // update Text

  void updateTextAndSave() async {
  // Get the edited text from the textEditingController
  final editedText = textEditingController.text;

  // Check if the edited text is different from the initial text
  if (editedText != widget.initialText) {
    // Open the Hive box
    final box = await Hive.openBox<RecognizedTextModel>('recognizedText');

    // Find the index of the record with the initial text
    final index = box.values.toList().indexWhere((record) {
      return record.text == widget.initialText;
    });

    if (index != -1) {
      final oldRecord = box.getAt(index);
      if (oldRecord != null) {
        // Create a new record with the updated text
        final newRecord = RecognizedTextModel(editedText, oldRecord.timestamp, oldRecord.imagePath);

        // Replace the old record with the new one in Hive
        await box.putAt(index, newRecord);
      }
    }
  }

  // Return to the previous screen and pass the edited text
  Navigator.of(context).pop(editedText);
}

}