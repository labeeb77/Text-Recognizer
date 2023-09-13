import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:text_recognizer/controller/recognizer_provider.dart';

import 'package:text_recognizer/screens/widgets/change_theme.dart';

Future<void> showBottomSheetWidget(BuildContext context) async {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.dark_mode_rounded),
              title: const Text('Dark Mode'),
              trailing: ChangeThemeWidget(),
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
                Provider.of<TextRecognizerProvider>(context, listen: false)
                    .clearDataFromHive();
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
