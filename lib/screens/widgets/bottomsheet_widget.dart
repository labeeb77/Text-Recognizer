import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:text_recognizer/controller/text_recognizer_provider.dart';

import '../../model/hive_model.dart';

Future<void> showBottomSheetWidget(BuildContext context) async {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return  Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const ListTile(
              leading: Icon(Icons.dark_mode_rounded),
              title: Text('Dark Mode'),
              
            ),
             const ListTile(
              leading: Icon(Icons.email),
              title: Text('Send us a feedback'),
              
            ),
             const ListTile(
              leading: Icon(Icons.play_arrow_rounded),
              title: Text('Rete app on Google Play'),
              
            ),
             const ListTile(
              leading: Icon(Icons.share),
              title: Text('Share app'),
              
              
            ),
             ListTile(
              leading: const Icon(Icons.restore),
              title: const Text('Reset app'),
              onTap: () {
              clearDataFromHive();

              },
              
            ),
             const ListTile(
              leading: Icon(Icons.description),
              title: Text('Open Source Licenses'),
              
            ),
          
          ],
        ),
      );
    },
  );
}
 Future<void> clearDataFromHive() async {
  final box = await Hive.openBox<RecognizedTextModel>('recognizedText');
  await box.clear();
}
