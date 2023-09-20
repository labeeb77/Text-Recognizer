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
   
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomePage(), 
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
    backgroundColor: Colors.white,
    
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
           SizedBox(height: 230.h,),
          Padding(
            padding:  EdgeInsets.only(left: 15.w),
            child: Image.asset("assets/images/LOGO1.png",height: 320.h),
          ),
          SizedBox(height: 160.h,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Image.asset('assets/images/corperatelogo-removebg-preview.png',height: 50.h,),
               
              ],
            ),
          )
          
        ],
      ),
    );
  }
}
