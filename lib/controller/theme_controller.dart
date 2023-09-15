import 'dart:developer';

import 'package:flutter/material.dart';

class ThemeNotifier extends ChangeNotifier {
 ThemeMode themeMode = ThemeMode.dark;

 bool get isDarkMode => themeMode == ThemeMode.dark;
void toggleTheme(bool isOn){log('clicked');
  themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
  notifyListeners();
}

}

class MyThemes{


    static final lightTheme = ThemeData(
      
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.light(),
    primaryColor: Colors.white
  );
  
  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.grey.shade900,
primaryColor: Colors.black,
    colorScheme: ColorScheme.dark(),
  );


}
