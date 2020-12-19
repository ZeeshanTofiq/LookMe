import 'package:flutter/material.dart';
import 'package:look_me/Components/AddExperenceSheet.dart';
import 'package:look_me/Components/ExpItem.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:look_me/Components/LoadingWidget.dart';

class Experences extends StatefulWidget {
  DocumentReference profileRef;
  final bool isCurrentUser;
  Experences({this.profileRef,this.isCurrentUser});
  @override
  _ExperencesState createState() => _ExperencesState();
}

class _ExperencesState extends State<Experences> {
  dynamic dataExp;

  // DataExp dataExp;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setDataExp();
  }

  Future<void> setDataExp() async {
    final data =
        await widget.profileRef.collection('Experences').getDocuments();
    setState(() {
      dataExp = data == null ? [] : data;
    });
    print(dataExp);
  }

  @override
  Widget build(BuildContext context) {
    // dataExp = DataExp();
    return this.dataExp != null
        ? Column(
            children: <Widget>[
              StreamBuilder(
                stream:widget.profileRef.collection('Experences').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    // print(this.profileRef);
                    // print('error found');
                    return Center(
                        child: Text(
                      'Something went wrong',
                      style: TextStyle(color: Colors.grey),
                    ));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return LoadingWidget();
                  }
                  print(snapshot.data.documents.length);
                  if (snapshot.hasData) {
                    return Column(
                      children: snapshot.data.documents.map<Widget>((item)=>ExperenceItem(
                          experenceTime: item["expTime"],
                          title:item["title"],
                          expItemRef :item,
                        showDeletebtn:widget.isCurrentUser
                      )).toList(),
                    );
                  } else {
                    return Text('no content');
                  }
                },
              ),
              widget.isCurrentUser ? Padding(
                padding: EdgeInsets.only(top: 10.0, right: 10.0),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: FloatingActionButton(
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) => AddExperenceSheet(
                              CollectionRef:
                                  widget.profileRef.collection('Experences')));
                    },
                    child: Icon(Icons.add),
                  ),
                ),
              ):Container(),
            ],
          )
        : LoadingWidget();
  }
}
