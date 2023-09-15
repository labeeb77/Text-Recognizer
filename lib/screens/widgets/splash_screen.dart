import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
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
    Timer(const Duration(seconds: 3), () {
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
    backgroundColor: Colors.white,
      // You can customize your splash screen's appearance here
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
           SizedBox(height: 200.h,),
          Padding(
            padding:  EdgeInsets.only(left: 15.w),
            child: Image.asset("assets/images/LOGO1.png",height: 320.h),
          ),
          SizedBox(height: 160.h,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/Corparateicon-removebg-preview.png',height: 50.h,),
              Text('Corporate Technologies',style: TextStyle(color: const Color.fromARGB(155, 0, 0, 0),fontWeight: FontWeight.w600))
            ],
          )
          
        ],
      ),
    );
  }
}
