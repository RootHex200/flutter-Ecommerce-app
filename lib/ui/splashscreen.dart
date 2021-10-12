
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecomarce/const/AppColors.dart';
import 'package:flutter_ecomarce/ui/buttomnavcontrolar.dart';
import 'package:flutter_ecomarce/ui/login_screen.dart';
import 'package:flutter_ecomarce/ui/userform.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class splashscreen extends StatefulWidget {
  const splashscreen({Key? key}) : super(key: key);

  @override
  _splashscreenState createState() => _splashscreenState();
}

class _splashscreenState extends State<splashscreen> {
  void initState(){
    super.initState();
    var currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      print(currentUser.uid);
      Timer(Duration(seconds: 1),()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>BottomNavControlar())));
    }else{
      Timer(Duration(seconds: 1),()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen())));
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deep_orange,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("E-Commerce",style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 44.sp,
                color: Colors.white,
              ),),
              SizedBox(height: 20.h,),
              CircularProgressIndicator(
                color: Colors.white,
              )
            ],
          ),
        ),
      ),
    );
  }
}


