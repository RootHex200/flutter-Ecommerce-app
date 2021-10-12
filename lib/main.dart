import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecomarce/ui/splashscreen.dart';
import 'package:flutter_ecomarce/ui/userform.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'const/AppColors.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var currentUser = FirebaseAuth.instance.currentUser;

    return ScreenUtilInit(
      designSize: Size(375,812),
        builder: ()=>MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Flutter E-Commerce",
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home:splashscreen(),
        ));
  }
}
