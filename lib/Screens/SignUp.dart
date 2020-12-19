import 'package:flutter/material.dart';
import 'package:look_me/Utilities/Constants.dart';
import 'package:look_me/Components/MaterialMyButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:look_me/Screens/Home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:look_me/Repo/AuthRepo.dart';

class SignUp extends StatefulWidget {
  static const String id = 'signup_screen';
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String email;
  String password;
  String reTypePass;
  bool hidePass = true;
  bool _showSpinner = false;
  String _errorMsg='';



  final _signupForm = GlobalKey<FormState>();
  void togglePass() {
    hidePass = !hidePass;
  }

  String validateEmail(String value) {
    Pattern pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value) || value == null)
      return 'Enter a valid email address';
    else
      return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: _showSpinner,
        child: Form(
          autovalidateMode: AutovalidateMode.always,
          key: _signupForm,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  'Look Me',
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  validator: (value)=>validateEmail(value),
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    email = value;
                  },
                  decoration:
                      kTextFieldDecoration.copyWith(hintText: 'Enter your email'),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: TextField(
                  obscureText: this.hidePass,
                  onChanged: (value) {
                    password = value;
                  },
                  textAlign: TextAlign.center,
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your password'),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: TextFormField(
                  validator: (value) {
                    if (value != password) {
                      return 'Password not match';
                    }
                    return null;
                  },
                  obscureText: this.hidePass,
                  onChanged: (value) {
                    reTypePass = value;
                  },
                  textAlign: TextAlign.center,
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your password'),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  children: [
                    Checkbox(
                      value: !this.hidePass,
                      hoverColor: primaryColor,
                      onChanged: (val) {
                        // print(val);
                        setState(() {
                          togglePass();
                        });
                      },
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          togglePass();
                        });
                      },
                      child: Text(
                        'Show Password',
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                _errorMsg,
                style: TextStyle(color: Colors.red),
              ),
              Hero(
                tag: 'signup_btn',
                child: MaterialMyButton(
                  btnText: 'SignUp',
                  textColor: primaryColor,
                  colour: Colors.white,
                  onPress: ()async{

                    if (_signupForm.currentState.validate()) {
                      setState(() {
                        _showSpinner = true;
                      });
                      try{
                        final user = await  FirebaseAuth.instance.createUserWithEmailAndPassword(
                          email: this.email,
                          password: this.password,
                        );
                        // print(user);
                        if (user!=null){
                          final db = Firestore.instance;
                          final currentUser = await AuthRepo().getCurrent();
                          final profileRef = db.collection('Profile').document(user.user.uid);
                          await profileRef.setData({
                            'email':'${user.user.email}',
                            'name':'',
                            'Dob':'',
                            'Gender':'',
                            'phone':'',
                            'profileImg':'',
                          });
                          Navigator.pushNamed(context, Home.id);
                        }
                      } catch(e){
                          if(e.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
                            /// `foo@bar.com` has alread been registered.
                            setState(() {
                              _errorMsg = 'Email already use try another email.';
                            });
                          }
                          else if (e.code == 'weak-password'){
                            setState(() {
                              _errorMsg = 'The password provided is too weak.';
                            });
                          }
                      }

                      setState(() {
                        _showSpinner = false;
                      });
                    }

                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
