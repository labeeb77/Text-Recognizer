import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:text_recognizer/controller/ads_controller.dart';
import 'package:text_recognizer/controller/recognizer_provider.dart';
import 'package:text_recognizer/controller/theme_controller.dart';

import 'package:path_provider/path_provider.dart' as path_provider;

import 'package:text_recognizer/screens/widgets/splash_screen.dart';
import 'model/hive_adapter.dart';
import 'model/hive_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(RecognizedTextModelAdapter().typeId)) {
    Hive.registerAdapter(RecognizedTextModelAdapter());
  }

  await Hive.openBox<RecognizedTextModel>('recognizedText');
  MobileAds.instance.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeNotifier()),
          ChangeNotifierProvider(create: (_) => TextRecognizerProvider()),
          ChangeNotifierProvider(create: (_) => AdsProvider()),
        ],
        child: const AppWrapper(),
      ),
    );
  }
}

class AppWrapper extends StatelessWidget {
  const AppWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return MaterialApp(
      
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      themeMode: themeNotifier.themeMode,
      theme: MyThemes.lightTheme,
      
      darkTheme: MyThemes.darkTheme,
      home: SplashScreen(),
      builder: EasyLoading.init(),
    );
  }
}
