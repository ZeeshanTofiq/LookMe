import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:date_field/date_field.dart';
import 'package:look_me/Components/MaterialMyButton.dart';
import 'package:look_me/Utilities/Constants.dart';
import 'package:intl/intl.dart';
import 'package:look_me/Components/LoadingWidget.dart';

enum Gender { Male, Female }

class BasicInfo extends StatefulWidget {
  final bool isCurrentUser;
  DocumentReference profileRef;
  BasicInfo({this.profileRef,this.isCurrentUser});
  @override
  _BasicInfoState createState() => _BasicInfoState();
}

class _BasicInfoState extends State<BasicInfo> {
  DateTime selectedDate;
  String name;
  String email;
  String phone;
  String selectedGender;


  Widget Label(String labelVal) {
    return Text(labelVal, style: TextStyle(color: Colors.grey));
  }


  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: widget.profileRef.snapshots(),
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
            // showSpinner = true;
            // print('In Waiting');
            return LoadingWidget();
          }
          // print('=== 1data ===: ${snapshot.data.data}');

          if (snapshot.hasData) {
            // setGender(snapshot.data.data["Gender"]);
            name = snapshot.data.data["name"];
            email = snapshot.data.data["email"];
            phone = snapshot.data.data["phone"];
            selectedGender = snapshot.data.data["Gender"];
            // print(data["Dob"]);
            selectedDate = snapshot.data.data["Dob"]!='' ? new DateFormat("yyyy-mm-dd").parse(snapshot.data.data["Dob"]) :null ;
            return Padding(
              padding: EdgeInsets.only(top: 17.0, left: 15.0, right: 15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  this.Label('Name'),
                  TextFormField(
                    enabled: widget.isCurrentUser,
                    initialValue: snapshot.data.data["name"],
                    onChanged: (value) {
                      name = value;
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  this.Label('Email'),
                  TextFormField(
                    enabled: widget.isCurrentUser,
                    initialValue: snapshot.data.data["email"],
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {
                      email = value;
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  this.Label('Phone'),
                  TextFormField(
                    enabled: widget.isCurrentUser,
                    initialValue: snapshot.data.data["phone"],
                    keyboardType: TextInputType.phone,
                    onChanged: (value) {
                      phone = value;
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  this.Label('Date of Birth'),
                  DateTimeFormField(
                      enabled: widget.isCurrentUser,
                      mode: DateFieldPickerMode.date,
                      initialValue: snapshot.data.data["Dob"] != ''
                          ? new DateFormat("yyyy-mm-dd")
                              .parse(snapshot.data.data["Dob"])
                          : null,
                      onDateSelected: (DateTime date) {
                        selectedDate = date;
                      }),
                  SizedBox(
                    height: 10.0,
                  ),
                  this.Label('Gender'),
                  widget.isCurrentUser ?
                  GenderWidget(initialVal: selectedGender,onChange:(String val){
                     selectedGender = val;
                     // print('i am changed');
                     print(selectedGender);
                  }):TextFormField(
                    initialValue: selectedGender,
                    enabled: false,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  widget.isCurrentUser ?
                  MaterialMyButton(
                    btnText: 'Save',
                    colour: primaryColor,
                    onPress: () async {
                      // print(selectedGender);
                      try {
                        await widget.profileRef.updateData({
                          'email': email,
                          'name': name,
                          'Dob': selectedDate != null
                              ? selectedDate.toString()
                              : '',
                          'Gender': selectedGender,
                          'phone': phone
                        });
                      } catch (e) {
                        print(e);
                      }
                      print('successfully saved');
                    },
                  ):Container()
                ],
              ),
            );
          } else {
            return Text('no dataset');
          }
        });
  }
}

class GenderWidget extends StatefulWidget {
  String  initialVal;
  Function onChange;
  GenderWidget({this.initialVal,this.onChange});
  @override
  _GenderWidgetState createState() => _GenderWidgetState();
}

class _GenderWidgetState extends State<GenderWidget> {
  Gender selectedGender;

  @override
  void initState(){
      super.initState();
      selectedGender = widget.initialVal =='Male' ? Gender.Male : Gender.Female;
  }

  setChangeSelected(){
    final String genderString =selectedGender == Gender.Male? 'Male':'Female';
    widget.onChange(genderString);
  }
  //GenderItem
  Widget genderItem(Gender val, String label) {
    return ListTile(
      title: Text(label),
      leading: Radio(
        value: val,
        groupValue: selectedGender,
        onChanged: (Gender value) {
          setState(() {
            selectedGender = value;
          // print(selectedGender);
          });
          setChangeSelected();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Expanded(child: this.genderItem(Gender.Male, 'Male')),
        Expanded(child: this.genderItem(Gender.Female, 'Female')),
      ],
    );
  }
}
