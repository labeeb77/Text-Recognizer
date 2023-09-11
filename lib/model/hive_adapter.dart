import 'package:hive_flutter/adapters.dart';

import 'hive_model.dart';


class RecognizedTextModelAdapter extends TypeAdapter<RecognizedTextModel> {
  @override
  final int typeId = 0;

 @override
RecognizedTextModel read(BinaryReader reader) {
  final text = reader.readString();
  final timestampString = reader.readString(); // Read the DateTime as a string
  final timestamp = DateTime.parse(timestampString);
  final imagePath = reader.readString(); // Read the image file path as a string
  return RecognizedTextModel(text, timestamp, imagePath);
}

@override
void write(BinaryWriter writer, RecognizedTextModel obj) {
  writer.writeString(obj.text);
  writer.writeString(obj.timestamp.toIso8601String()); 
  writer.writeString(obj.imagePath); // Serialize image file path as a string
}
}
