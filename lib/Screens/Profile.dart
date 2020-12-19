import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:look_me/Utilities/Constants.dart';
import 'package:look_me/Components/ProfileImage.dart';
import 'package:look_me/Components/BasicInfo.dart';
import 'package:flutter/cupertino.dart';
import 'package:look_me/Components/Documents.dart';
import 'package:look_me/Components/Experences.dart';
import 'package:look_me/Repo/AuthRepo.dart';

import 'package:look_me/Components/LoadingWidget.dart';

class Profile extends StatefulWidget {
  final DocumentReference profileRef;
  Profile({this.profileRef});
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  int selectedItem = 0;
  final Color selectedColor = Colors.blueAccent;
  final Color unSelectedColor = Colors.white;
  dynamic profileRef;
  bool isCurrentUser;

  @override
  void initState() {
    super.initState();
    if (widget.profileRef != null){
      profileRef = widget.profileRef;
      setIsCurrentUser();
    }
  }
  Future<void> setIsCurrentUser()async{
    final authUser = await AuthRepo().getCurrent();
    if (authUser.uid == this.profileRef.documentID){
      setState(() {
        isCurrentUser = true;
      });
    }else{
      setState(() {
        isCurrentUser = false;
      });
    }
  }
  Widget _Item(IconData icon, String text, int index) {
    final ItemBackgroundColor =
        selectedItem == index ? selectedColor : unSelectedColor;
    final ItemColor = selectedItem == index ? unSelectedColor : selectedColor;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        color: ItemBackgroundColor,
      ),
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: [
          Icon(icon, color: ItemColor),
          Text(
            text,
            style: TextStyle(color: ItemColor),
          )
        ],
      ),
    );
  }


  Widget currentPage() {
    if (this.profileRef != null && this.isCurrentUser != null) {
      print('Document Reference = ${this.profileRef}');
      print('Current User = ${this.isCurrentUser}');
      if (selectedItem == 0) {
        return BasicInfo(
          profileRef: this.profileRef, isCurrentUser: this.isCurrentUser,);
      } else if (selectedItem == 1) {
        return Experences(
          profileRef: this.profileRef, isCurrentUser: this.isCurrentUser,);
      } else if (selectedItem == 2) {
        return Document(
            profileRef: this.profileRef, isCurrentUser: this.isCurrentUser);
      } else {
        return Text('not Found');
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    if (this.profileRef == null){
      final docProfileRef = ModalRoute
          .of(context)
          .settings
          .arguments;
      setState(() {
        this.profileRef = docProfileRef;
        setIsCurrentUser();
      });
    }
    return this.isCurrentUser != null && this.profileRef != null ?
    Scaffold(
      appBar: widget.profileRef == null ? AppBar(
        backgroundColor: primaryColor,
        title: Text('Profile'),
      ):null,
      body: Column(children: [
        Expanded(
            child: ListView(children: [
              Column(children: [
                //Profile Image
                Container(
                    height: 200.0,
                    color: primaryColor.withOpacity(.8),
                    child: profileImage(profileRef: this.profileRef,showChangerBtn:this.isCurrentUser)),
                CupertinoSegmentedControl(
                  borderColor: Colors.white,
                  // selectedColor: Colors.white,
                  onValueChanged: (val) {
                    setState(() {
                      selectedItem = val;
                    });
                  },
                  children: <int, Widget>{
                    0: this._Item(Icons.contact_page, 'Personal Info', 0),
                    1: this._Item(Icons.school, 'Experences', 1),
                    2: this._Item(Icons.article, 'Documents', 2),
                  },
                ),
                currentPage(),
              ])
            ]))
      ]),
    ) : LoadingWidget();

  }
}
