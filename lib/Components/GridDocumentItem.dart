import 'package:flutter/material.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';
import 'package:look_me/Data/DocumentInfo.dart';
import 'package:provider/provider.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:look_me/Components/PDFViewer.dart';

const String deleteString = 'delete';
const List<String> onPopupMenu = [deleteString];

class GridDocumentItem extends StatefulWidget {
  final item;
  GridDocumentItem({this.item});
  @override
  _GridDocumentItemState createState() => _GridDocumentItemState();
}

class _GridDocumentItemState extends State<GridDocumentItem> {
  bool showSpinner = false;
  @override
  Widget build(BuildContext context) {
    return Consumer<DocumentInfo>(builder: (context, data, _) {
      // print(widget.item["document"]);
      return ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Card(
          child: Column(children: [
            data.isCurrentUser
                ? Align(
                    alignment: Alignment.topRight,
                    child: PopupMenuButton(
                      elevation: 2,
                      onSelected: (String val) async {
                        if (val == deleteString) {
                          setState(() {
                            showSpinner = true;
                          });
                          await data.deleteFile(widget.item.reference,
                              widget.item.data["document"]);
                          setState(() {
                            showSpinner = false;
                          });
                        }
                      },
                      itemBuilder: (BuildContext build) {
                        return onPopupMenu.map((String choice) {
                          return PopupMenuItem<String>(
                            value: choice,
                            height: 5.0,
                            child: Text(choice),
                          );
                        }).toList();
                      },
                    ),
                  )
                : Container(),
            Flexible(
              // child: Image.asset('images/pdf_icon.png'),
              child: GestureDetector(
                onTap: () async {

                  PDFDocument doc;
                  try{
                    doc =
                    await PDFDocument.fromURL(widget.item["document"]);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context)=>MyPdfViewer(),
                          settings: RouteSettings(
                            arguments: widget.item["document"]
                          )
                        )
                    );
                  }catch(e){
                    print(e);
                  }
                  setState(() {
                    showSpinner = false;
                  });

                },
                child: Image.asset('images/pdf_icon.png'),
              ),
            ),
            SizedBox(
              height: 4.0,
            ),
            Text(
              widget.item["title"],
              style: TextStyle(fontSize: 17.0),
            )
          ]),
        ),
      );
    });
  }
}
