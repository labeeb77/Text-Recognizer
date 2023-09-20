import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import 'package:text_recognizer/screens/widgets/change_theme.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controller/recognizer_provider.dart';

Future<void> showBottomSheetWidget(BuildContext context) async {
  final Uri url = Uri.parse('https://play.google.com/store/apps/details?id=in.corporate.text_recognizer');
  const playStoreUrl =
      "https://play.google.com/store/apps/details?id=in.corporate.text_recognizer";
  showModalBottomSheet(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
            ListTile(
              onTap: () {
                Share.share(playStoreUrl);
              },
              leading: const Icon(Icons.share),
              title: const Text('Share app'),
            ),
            ListTile(
              
              leading: Icon(Icons.star),
              title: Text('Rate app on Google play'),
              onTap: () {
               openGooglePlayStore();
              },
            ),
            ListTile(
              leading: const Icon(Icons.restore),
              title: const Text('Reset app'),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                          title: const Text(
                            "Alert!",
                          ),
                          content: const Text("Are you sure to reset app?"),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("No")),
                            TextButton(
                                onPressed: () {
                                  Provider.of<TextRecognizerProvider>(context,
                                          listen: false)
                                      .clearDataFromHive();
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  "Yes",
                                ))
                          ],
                        ));
              },
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Divider(),
            )
          ],
        ),
      );
    },
  );
}

Future<void> openGooglePlayStore() async {
  const playStoreUrls = 'https://play.google.com/store/apps/details?id=in.corporate.text_recognizer';

  if (await canLaunchUrl(Uri.parse(playStoreUrls))) {
    await launchUrl(Uri.parse(playStoreUrls));
  } else {
    throw 'Could not launch $playStoreUrls';
  }
}