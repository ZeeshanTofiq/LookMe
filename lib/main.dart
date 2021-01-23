import 'package:flutter/material.dart';
import 'package:look_me/Screens/Welcome.dart';
import 'package:look_me/Screens/Login.dart';
import 'package:look_me/Screens/SignUp.dart';
import 'package:look_me/Screens/Home.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:look_me/Utilities/Constants.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
      return MaterialApp(
        // initialRoute: Welcome.id,
        home:new SplashScreen(
          seconds: 5,
          navigateAfterSeconds: new Welcome(),
          title: new Text(
            'Look Me',
            style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0,color: primaryColor),
          ),
          image: new Image.asset('images/logo.png'),
          backgroundColor: Colors.white,
          loaderColor: primaryColor,
        ),
        routes: {
          Welcome.id:(context)=>Welcome(),
          Login.id:(context)=>Login(),
          SignUp.id:(context)=>SignUp(),
          Home.id:(context)=>Home(),
          // LoadingWidget.id:(context)=>LoadingWidget(),
        },
      );
    }

}