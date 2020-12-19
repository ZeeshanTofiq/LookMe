import 'package:flutter/material.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';
import 'package:look_me/Utilities/Constants.dart';

class MyPdfViewer extends StatefulWidget {
  @override
  _MyPdfViewerState createState() => _MyPdfViewerState();
}

class _MyPdfViewerState extends State<MyPdfViewer> {
  PDFDocument doc;
  bool showSpinner;
  String docUrl;

  @override
  void initState() {
    super.initState();
  }

  Future<void> setMyPdfViewer() async {
    setState(() {
      showSpinner = true;
    });

    var document ;
    try {
      document = await PDFDocument.fromURL(this.docUrl);
    }catch(e){
      print(e);
    }
    setState(() {
      this.doc = document;
      showSpinner = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (docUrl == null) {
      final docUrlString = ModalRoute
          .of(context)
          .settings
          .arguments;
      setState(() {
        this.docUrl = docUrlString;
        setMyPdfViewer();
      });
    }
    return this.doc != null && this.docUrl != null
        ? PDFViewer(
            document: this.doc,
            indicatorBackground: primaryColor,
            showIndicator: false,
            showPicker: false,
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }
}
