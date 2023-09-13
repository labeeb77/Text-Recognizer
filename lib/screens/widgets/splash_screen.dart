import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:text_recognizer/screens/home_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Delay for 2 seconds before navigating to the next screen
    Timer(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomePage(), // Replace with your main screen
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
    
      // You can customize your splash screen's appearance here
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset("assets/images/Corparateicon-removebg-preview.png",height: 90),
            const SizedBox(height: 20,),
            const Text('Text Recognizer',style: TextStyle(fontSize: 27,fontWeight: FontWeight.bold,),)
          ],
        ),
      ),
    );
  }
}
