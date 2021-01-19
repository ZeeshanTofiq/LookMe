import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:look_me/Components/MaterialMyButton.dart';
import 'package:look_me/Screens/Login.dart';
import 'package:look_me/Utilities/Constants.dart';
import 'package:look_me/Screens/SignUp.dart';
import 'package:look_me/Repo/AuthRepo.dart';
import 'package:look_me/Components/LoadingWidget.dart';
import 'package:look_me/Screens/Home.dart';

class Welcome extends StatefulWidget {
  static const String id = 'welcome_screen';
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  dynamic isloggedIn;
  @override
  void initState(){
    super.initState();
    getCurrentUser();
  }
  Future<void> getCurrentUser()async {
    var user;
    try{
      user = await AuthRepo().getCurrent();
    }catch(e){
      print(e);
    }
    if (user != null){
      setState(() {
        this.isloggedIn = true;
      });
    }else{
      setState(() {
        this.isloggedIn = false;
      });
    }
    print(this.isloggedIn);
  }

  @override
  Widget build(BuildContext context) {
    return this.isloggedIn !=null ? Scaffold(
        resizeToAvoidBottomPadding: false,
        body: this.isloggedIn == true ? Home():Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/welcomepage.png'),
                fit: BoxFit.cover,
              ),
            ),
            constraints: BoxConstraints.expand(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 38.0,vertical: 105.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Look Me',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Make your profile and connect with friends',
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(
                    height:10.0,
                  ),
                  Flexible(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Hero(
                          tag:'login_btn',
                          child: MaterialMyButton(
                            colour: Colors.blueAccent,
                            btnText: 'Login',
                            onPress: () {
                              Navigator.pushNamed(context, Login.id);
                            },
                          ),
                        ),
                        SizedBox(
                          width:10.0,
                        ),
                        Hero(
                          tag: 'signup_btn',
                          child: MaterialMyButton(
                            colour: Colors.white,
                            textColor: primaryColor,
                            btnText: 'SignUp',
                            onPress: () {
                              Navigator.pushNamed(context, SignUp.id);
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(),
        ),
      ],
    )):LoadingWidget();
  }
}
