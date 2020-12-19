import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:look_me/Repo/StorageRepo.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class profileImage extends StatefulWidget {
  final DocumentReference profileRef;
  final bool showChangerBtn;
  profileImage({this.profileRef,this.showChangerBtn});
  @override
  _profileImageState createState() => _profileImageState();
}

class _profileImageState extends State<profileImage> {
  dynamic _image;
  final picker = ImagePicker();
  String _profileImg;
  bool showSpiner = false;
  final storageRepo = StorageRepo();

  @override
  void initState() {
    super.initState();
    getProfileImg();
  }

  Future<void> getProfileImg() async {
    var data;
    try{
      data = await widget.profileRef.get();
    }catch(e){
      print('Error in fetching data');
      print(e);
    }
    print('done');
    if (data.data["profileImg"] != ""){
      setState(() {
        this._profileImg = data.data["profileImg"];
      });
    }
    print(this._profileImg);
  }


  Future getSnapData() async {
    // print(await widget.snapShotData.data);
  }
  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> removePhoto()async {
    try{
      await StorageRepo().deleteFile(this._profileImg);
      await widget.profileRef.updateData({'profileImg':FieldValue.delete()});
    }catch(e){
      print(e);
    }
    print('Successfully delete');
    setState(() {
      _image = null;
      _profileImg = null;
    });
  }

  Future getImageByGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
  }

  Future<void> uploadAndShowImg(type) async{
    if (type=='camera'){
      print('getting pic from camera');
      await getImage();
    }else if (type == 'gallery'){
      print('getting pic from gallery');
      await getImageByGallery();
    }
    print('pic seleted successfully');
    setState(() {
      showSpiner = true;
    });
    final downloadUrl = await storageRepo.uploadProfileImg(this._image);
    print('== download url == $downloadUrl');
    try{
      await widget.profileRef.updateData({
        "profileImg":'$downloadUrl'
      });
      print('ProfileImg Updated');
    }catch(e){
     print(e);
    }
    setState(() {
      this._profileImg = '$downloadUrl';
      showSpiner = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 120.0,
        height: 120.0,
        child: Stack(
          children: [
              ModalProgressHUD(
                inAsyncCall: showSpiner,
              child: Container(
                margin: EdgeInsets.only(top: 10.0),
                width: 120.0,
                height: 120.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: _profileImg == null
                        ? AssetImage('images/profileImg.png')
                        : NetworkImage(_profileImg),
                  ),
                ),
              ),
            ),
            widget.showChangerBtn ? Align(
                alignment: Alignment.bottomRight,
                child: GestureDetector(
                  onTap: () async {
                    // print('You click me');
                    // bottomAnimateList();
                    profileChangerListPop(
                            context: context,
                            changeImg: () async {
                             await uploadAndShowImg('camera');
                            },
                            changeImgByGallery: ()async {
                              await uploadAndShowImg('gallery');
                            },
                            removeImg: removePhoto)
                        .show();
                  },
                  child: CircleAvatar(
                    child: Icon(Icons.camera_alt),
                  ),
                )):Container(),
          ],
        ),
      ),
    );
  }
}

//Profile Change Option Modal Shows
class profileChangerListPop {
  final BuildContext context;
  final Function changeImg;
  final Function changeImgByGallery;
  final Function removeImg;

  profileChangerListPop(
      {this.context, this.changeImg, this.changeImgByGallery, this.removeImg});

  void show() {
    final profileImgAct = CupertinoActionSheet(
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: Text('Take profile image'),
          onPressed: () {
            changeImg();
            Navigator.pop(context);
          },
        ),
        CupertinoActionSheetAction(
          child: Text('Upload profile image'),
          onPressed: () {
            changeImgByGallery();
            Navigator.pop(context);
          },
        ),
        CupertinoActionSheetAction(
          child: Text('Remove my profile image'),
          onPressed: ()async {
            await removeImg();
            Navigator.pop(context);
          },
        )
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text('Cancel'),
        onPressed: () {
          // Navigator.of(context).pop;
          Navigator.pop(context);
        },
      ),
    );

    showCupertinoModalPopup(
        context: context, builder: (context) => profileImgAct);
  }
}
