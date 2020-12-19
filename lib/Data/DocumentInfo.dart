import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:look_me/Repo/StorageRepo.dart';
import 'package:firebase_storage/firebase_storage.dart';
import "package:path/path.dart";


class DocumentInfo with ChangeNotifier {
  final profileRef;
  final bool isCurrentUser;
  File _selectFile;
  double _progressIndicator;
  String _titleOfFile;

  DocumentInfo({this.profileRef, this.isCurrentUser});

  String getTitleOfFile() {
    return this._titleOfFile;
  }


  double getProgressIndicator(){
    return this._progressIndicator;
  }

  Future addNewFile() async {
    if (this._selectFile != null) {
      StorageUploadTask task =
          await StorageRepo().uploadFileStream(this._selectFile, (double val) {
        this._progressIndicator = val;
        notifyListeners();
      });

      try {
        String downUrl = await (await task.onComplete).ref.getDownloadURL();

        await this
            .profileRef
            .collection('Documents')
            .add({"title": this._titleOfFile, "document": downUrl});
      } catch (e) {
        if (e.code == 'permission-denied') {
          print('User does not have permission to upload to this reference.');
        }
        print(e);
      }
      this._selectFile = null;
      this._progressIndicator = null;
      notifyListeners();
    }else{
      print('Not select any file');
    }
  }

  //delete File
  Future<void> deleteFile(DocumentReference docRef, String file) async {
    try {
      await StorageRepo().deleteFile(file);
      await docRef.delete();
    } catch (e) {
      print(e);
    }
  }

  File getSelectFile() {
    return _selectFile;
  }
  String getSelectedFilename(){
    if (this._selectFile == null) {
      return '';
    }
    return basename(this._selectFile.path);
  }

  void changeTitleAndFile(File file,String titleName){
    _selectFile = file;
    this._titleOfFile = titleName;
    notifyListeners();
  }
}
