import 'package:flutter/material.dart';
import 'package:look_me/Components/LoadingWidget.dart';
import 'package:look_me/Components/GridDocumentItem.dart';

class GridDocument extends StatefulWidget {
  final profileRef;
  GridDocument({this.profileRef});
  @override
  _GridDocumentState createState() => _GridDocumentState();
}

class _GridDocumentState extends State<GridDocument> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: widget.profileRef.collection('Documents').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
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
          // print(snapshot.data.documents[0]["title"]);
          print('I am GridDocuments');
          if (snapshot.hasData) {
            final file = snapshot.data.documents;
            return file.length != 0
                ? GridView.count(
              shrinkWrap: true,
              crossAxisSpacing: 20.0,
              mainAxisSpacing: 20.0,
              physics: ScrollPhysics(),
              crossAxisCount: 2,
              children: file.map<Widget>((item) {
                return GridDocumentItem(item: item,);
              }).toList(),
            )
                : Container();
          } else {
            return Text('no content');
          }
        });
  }
}
