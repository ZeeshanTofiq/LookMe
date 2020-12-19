import 'package:flutter/material.dart';
import 'package:look_me/Utilities/Constants.dart';
import 'package:look_me/Data/DocumentInfo.dart';

import 'package:provider/provider.dart';


class UploadFileWidget extends StatefulWidget {
  @override
  _UploadFileWidgetState createState() => _UploadFileWidgetState();
}

class _UploadFileWidgetState extends State<UploadFileWidget> {

  @override
  Widget build(BuildContext context) {
    return Consumer<DocumentInfo>(
      builder: (context,data,_){
        return data.getProgressIndicator() !=null ? Padding(
          padding: EdgeInsets.only(right: 10.0, left: 10.0, top: 10.0),
          child: Card(
            child: ListTile(
              leading: Icon(Icons.folder),
              title: Text(data.getTitleOfFile()),
              subtitle: LinearProgressIndicator(
                value: data.getProgressIndicator() / 100,
                valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                backgroundColor: Colors.grey,
              ),
            ),
          ),
        ):Container();
      },
    );
  }
}
