import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:text_recognizer/controller/theme_controller.dart';

class ChangeThemeWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    final themeProvider = Provider.of<ThemeNotifier>(context);
    return Switch.adaptive(value: themeProvider.isDarkMode, 
    onChanged: (value) {
      Provider.of<ThemeNotifier>(context,listen: false).toggleTheme(value);
    },);
  }
}