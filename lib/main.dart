import 'package:flutter/material.dart';
import 'package:look_me/Screens/Welcome.dart';
import 'package:look_me/Screens/Login.dart';
import 'package:look_me/Screens/SignUp.dart';
import 'package:look_me/Screens/Home.dart';

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
        initialRoute: Welcome.id,
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