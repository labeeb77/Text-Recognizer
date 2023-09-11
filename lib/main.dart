import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:text_recognizer/controller/text_recognizer_provider.dart';
import 'package:text_recognizer/screens/home_page.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'model/hive_adapter.dart';
import 'model/hive_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(RecognizedTextModelAdapter().typeId)) {
    Hive.registerAdapter(RecognizedTextModelAdapter());
  }

  await Hive.openBox<RecognizedTextModel>('recognizedText');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const HomePage(),
      ),
    );
  }
}
