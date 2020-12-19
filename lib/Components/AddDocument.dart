import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:look_me/Utilities/Constants.dart';
import 'package:look_me/Components/MaterialMyButton.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';



class AddDocument extends StatefulWidget {

  var data;
  AddDocument({this.data});
  @override
  _AddDocumentState createState() => _AddDocumentState();
}

class _AddDocumentState extends State<AddDocument> {
  final _addDoc = GlobalKey<FormState>();
  String errMsg;
  String title;
  File _result;
  bool showSpinner = false;
  File fileSelected;

  Future<void> getFile() async {
    final File filePick = await FilePicker.getFile(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc'],
    );
    setState(() {
      fileSelected = filePick;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Container(
        color: Color(0xff757575),
        child: Container(
          // height:MediaQuery.of(context).size.height
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
          ),
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Form(
              key: _addDoc,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10.0, bottom: 10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        this.fileSelected != null
                            ? SizedBox(
                            child: Column(
                              children: [
                                Container(
                                  width:
                                  MediaQuery.of(context).size.width / 1.5,
                                  child: Text(basename(fileSelected.path)),
                                )
                              ],
                            ))
                            : Container(),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              showSpinner = true;
                            });
                            getFile();
                            setState(() {
                              showSpinner = false;
                            });
                          },
                          child: Icon(Icons.attach_file),
                        )
                      ],
                    ),
                  ),
                  TextFormField(
                    textInputAction: TextInputAction.go,
                    decoration: InputDecoration(
                        hintText: 'Title of Document',
                        hintStyle: TextStyle(color: Colors.grey)),
                    onChanged: (val) {

                      setState(() {
                        title = val;
                      });
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  this.errMsg != null
                      ? Text(
                    '${this.errMsg}',
                    style: TextStyle(color: Colors.red),
                  )
                      : Container(),
                  MaterialMyButton(
                    btnText: 'Add',
                    colour: primaryColor,
                    onPress: () {
                      if (this.fileSelected == null) {
                        setState(() {
                          this.errMsg = 'Attach the file first';
                        });
                      } else if (title == null) {
                        setState(() {
                          this.errMsg = 'Provide the title name to document';
                        });
                      } else {
                        widget.data.changeTitleAndFile(this.fileSelected,this.title);
                        widget.data.addNewFile();
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}