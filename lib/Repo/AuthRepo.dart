import 'package:firebase_auth/firebase_auth.dart';

class AuthRepo{
  final _auth = FirebaseAuth.instance;

  // getting Currrent User
  Future getCurrent()async {
    return await  this._auth.currentUser();
  }


}