import 'package:flutter/material.dart';
import 'package:look_me/Utilities/Constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:look_me/Screens/Welcome.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:look_me/Components/LoadingWidget.dart';
import 'package:look_me/Repo/AuthRepo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:look_me/Screens/Profile.dart';
import 'package:look_me/Screens/FindFriend.dart';


class Home extends StatefulWidget {
  static const String id = 'home_screen';
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedIndex = 0;
  bool _showSpinner = false;
  dynamic profileRef;
  List<Widget> _Items;

  @override
  void initState(){
    super.initState();
    setProfileRef();
  }
  getItem(int index) {
    print(this._Items);
    if (this._Items.length > index) {
      return this._Items[index];
    }
    return Center(
      child: Text(
          'Page not exist',
          style:TextStyle(
            color:Colors.grey,
          )
      ),
    );
  }

  Future<void> setProfileRef() async {
    final currentUser = await AuthRepo().getCurrent();

    setState(() {
      this.profileRef = Firestore.instance
          .collection('Profile')
          .document('${currentUser.uid}');
      _Items = [
        FindFriend(),
        Profile(profileRef: this.profileRef)
      ];
    });
  }

  _onTapItem(BuildContext context,int index){
    if (index == 2){
      showMyDialog();
      return;
    }
    setState(() {
      selectedIndex = index;
    });
    // print(selectedIndex);
  }

  Future<void> showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you want to logout?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('NO'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: ()async {
                setState(() {
                  this._showSpinner = true;
                });
                try{
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushNamedAndRemoveUntil(context, Welcome.id,(route) => false);
                  //   Navigator.pushNamed(context, Welcome.id);
                }catch(e){
                  print(e);
                }
                setState(() {
                  this._showSpinner = false;
                });
                // Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return this.profileRef != null ? WillPopScope(
      onWillPop: ()async => false,
      child: ModalProgressHUD(
        inAsyncCall: this._showSpinner,
        child: Scaffold(
          body: getItem(selectedIndex),
          bottomNavigationBar: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                icon:Icon(Icons.search),
                label:'Search'
              ),
              BottomNavigationBarItem(
                  icon:Icon(Icons.account_box),
                  label:'Profile'
              ),
              BottomNavigationBarItem(
                  icon:Icon(Icons.power_settings_new_outlined),
                  label:'Logout'
              ),
            ],
            selectedItemColor: primaryColor,
            onTap: (val)=>_onTapItem(context,val),
            currentIndex: selectedIndex,
          ),
        ),
      ),
    ):LoadingWidget();
  }
}