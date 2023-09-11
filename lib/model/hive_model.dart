import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class RecognizedTextModel extends HiveObject {
  @HiveField(0)
  final String text;
  
  @HiveField(1)
  final DateTime timestamp;

  @HiveField(2)
  final String imagePath;

  RecognizedTextModel(this.text, this.timestamp,this.imagePath);
}
