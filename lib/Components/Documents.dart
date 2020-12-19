import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:look_me/Components/AddDocument.dart';
import 'package:look_me/Components/Uploading Widget.dart';
import 'package:look_me/Components/GridDocuments.dart';
import 'package:provider/provider.dart';
import 'package:look_me/Data/DocumentInfo.dart';


class Document extends StatefulWidget{
  final bool isCurrentUser;
  DocumentReference profileRef;
  Document({this.profileRef, this.isCurrentUser});
  @override
  _DocumentState createState() => new _DocumentState();
}

class _DocumentState extends State<Document> with SingleTickerProviderStateMixin{


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DocumentInfo>(
      create:(context)=>DocumentInfo(isCurrentUser: widget.isCurrentUser,profileRef: widget.profileRef),
      child: Column(
        children: <Widget>[
          widget.isCurrentUser ? Consumer<DocumentInfo>(builder:(context,data,_)=>UploadFileWidget()): Container(),
          Padding(
            padding: EdgeInsets.only(right: 10.0, left: 10.0, top: 10.0),
            child: GridDocument(profileRef:widget.profileRef),
          ),
          widget.isCurrentUser
              ? Column(children: [
    Consumer<DocumentInfo>(
    builder: (context,data,_)=>Padding(
              padding: EdgeInsets.only(top: 10.0, right: 10.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) =>  AddDocument(data:data),
                    );
                  },
                  child: Icon(Icons.add),
                ),
              ),
            )
    ),
          ])
              : Container()
        ],
      ),
    );
  }
}

