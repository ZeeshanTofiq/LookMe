import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExperenceItem extends StatelessWidget {
  final String title;
  final bool showDeletebtn;
  final int experenceTime;
  final DocumentSnapshot expItemRef;

  ExperenceItem({this.experenceTime,this.title,this.expItemRef,this.showDeletebtn});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
      child: Material(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        elevation: 2,
        child: ListTile(
           trailing:this.showDeletebtn == true ? GestureDetector(
            onTap: ()async{
              try{
                await expItemRef.reference.delete();
              }
              catch(e){
                print('error found');
                print(e);
              }
              print('successfull deleted');
            },
              child: Icon(Icons.delete)
          ):null,
          title: Text(this.title),
          subtitle: Text('Experences: ${this.experenceTime} years'),
        ),
      ),
    );
  }
}