import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:look_me/Components/MaterialMyButton.dart';
import 'package:look_me/Utilities/Constants.dart';
import 'package:look_me/Screens/Home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class Login extends StatefulWidget {
  static const String id = 'login_screen';
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool hidePass = true;
  String email;
  String password;
  IconData showPassIcon = Icons.visibility_off;
  bool _showSpinner = false;
  String _errMsg = '';

  final _signInForm = GlobalKey<FormState>();

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

  void toggleShowPass() {
      if (hidePass){
        showPassIcon = Icons.visibility;
      }else{
        showPassIcon = Icons.visibility_off;
      }
      hidePass = !hidePass;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: _showSpinner,
        child: Form(
          key: _signInForm,
          autovalidateMode: AutovalidateMode.always,
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
                  validator: (value)=>validateEmail(value),
                  keyboardType: TextInputType.emailAddress,
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
                    hintText: 'Enter your password',
                    suffixIcon: GestureDetector(
                      onTap: (){
                        setState(() {
                          toggleShowPass();
                        });
                      },
                      child: Icon(
                        showPassIcon,
                      ),
                    ),
                  ),
                ),
              ),
              Text(
                _errMsg,
                style: TextStyle(color:Colors.red),
              ),
              Hero(
                tag: 'login_btn',
                child: MaterialMyButton(
                  btnText: 'Login',
                  colour: Colors.blueAccent,
                  onPress: () async {
                    if (_signInForm.currentState.validate()){

                      setState(() {
                        this._showSpinner = true;
                      });
                      try {
                        final user = await FirebaseAuth.instance.signInWithEmailAndPassword(
                            email: this.email,
                            password: this.password
                        );
                        if (user != null){
                          // user.user.profile = Firestore.instance.collection('Profile').document(user.user.uid).snapshots();
                          print(user);
                          Navigator.pushNamed(context, Home.id);
                        }
                      } catch (e) {

                        // print('Error started');
                        // print(e);
                        // print(e.code);
                        if (e.code == 'ERROR_INVALID_EMAIL'){
                          setState(() {
                            this._errMsg = 'Invalid Email';
                          });
                        }
                        else if (e.code == 'ERROR_USER_NOT_FOUND') {
                          setState(() {
                            this._errMsg = 'No user found for that email.';
                          });
                        }
                        else if (e.code == 'ERROR_WRONG_PASSWORD') {
                          setState(() {
                            this._errMsg = 'Wrong password provided for that user.';
                          });
                        }
                        // print('Error ending');
                      }
                      setState(() {
                        this._showSpinner = false;
                      });

                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
