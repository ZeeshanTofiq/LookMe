import 'package:flutter/material.dart';
import 'package:look_me/Utilities/Constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:look_me/Components/LoadingWidget.dart';
import 'package:look_me/Components/FriendListItem.dart';

class FindFriend extends StatefulWidget {
  @override
  _FindFriendState createState() => _FindFriendState();
}

class _FindFriendState extends State<FindFriend> {
  String Usersearch;
  List resultSearch = [];
  bool showSpinner = false;
  addResultSearch(DocumentSnapshot doc,List<String> exp){
    var data =doc.data;
    data["Experences"] = exp;
    data["profileRef"]=doc.reference;
    setState(() {
      resultSearch.add(data);
    });
  }
  Future<List<String>> expList(DocumentSnapshot item)async{
    List<String> expList = [];
    final expRes = await item.reference.collection('Experences').getDocuments();
    if (expRes.documents.length != 0 ){
      for(var item in expRes.documents){
        expList.add(item.data["title"]);
      }
    }
    return expList;
  }
  @override
  Widget build(BuildContext context) {
    return ListView(children: <Widget>[
      Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: TextFormField(
              textInputAction: TextInputAction.search,
              onFieldSubmitted: (value)async {
                if (value == null && value == ''){return;}
                setState(() {
                  this.Usersearch = value;
                  this.resultSearch = [];
                  this.showSpinner = true;
                });
                final profileRef = Firestore.instance.collection('Profile');
                var profileData;
                try{
                  profileData = await profileRef.getDocuments();
                }catch(e){
                  print(e);
                }
                if (profileData.documents.length !=0){
                  for (DocumentSnapshot item in profileData.documents){
                    List<String> myExpList;
                    if (item["name"] == value){
                      myExpList = await this.expList(item);
                      this.addResultSearch(item, myExpList);
                    }
                    else if (item["email"] == value){
                      myExpList = await this.expList(item);
                      this.addResultSearch(item, myExpList);
                    }
                    else if (item["phone"] == value){
                      myExpList = await this.expList(item);
                      this.addResultSearch(item, myExpList);
                    }
                    else{
                      myExpList = await this.expList(item);
                      if(myExpList.length !=0){
                       print('Exp Result = ');
                       print( myExpList);
                       if (myExpList.contains(value)){
                         this.addResultSearch(item, myExpList);
                       }
                      }
                    }
                  }
                }
                setState(() {
                  showSpinner = false;
                });
              },
              textAlign: TextAlign.start,
              decoration: kTextFieldDecoration.copyWith(
                hintText: 'Find your User....',
                prefixIcon: Icon(Icons.search, color: Colors.grey),
              ),
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              // width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'View Results',
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 25.0,
                    ),
                  ),
                  Text(
                    Usersearch == null ? '' : 'Results: $Usersearch',
                    style: TextStyle(
                        color: Colors.grey, fontStyle: FontStyle.italic),
                  ),
                  Column(
                    // children: FriendList.friendList,
                    children: this.resultSearch.map((e) => FriendListItem(data: e,)).toList(),
                  ),
                  showSpinner== true?LoadingWidget():Container(),
                ],
              ))
        ],
      ),
    ]);
  }
}
