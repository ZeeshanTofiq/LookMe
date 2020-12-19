import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:look_me/Utilities/Constants.dart';
import 'package:look_me/Components/MaterialMyButton.dart';

class AddExperenceSheet extends StatefulWidget {
  final CollectionRef;
  AddExperenceSheet({this.CollectionRef});
  @override
  _AddExperenceSheetState createState() => _AddExperenceSheetState();
}

class _AddExperenceSheetState extends State<AddExperenceSheet> {
  String expName;
  String expYear;
  final _addExp = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Text(
                  'Add Experence',
                  style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0),
                ),
              ),
              Form(
                key:_addExp,
                child: Column(
                  children: [
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      validator: (val){
                        if (val == null){
                          return 'Required Field';
                        }
                        return null;
                      },
                      onChanged: (val) {
                        setState(() {
                          expName = val;
                        });
                      },
                      decoration: InputDecoration(
                          hintText: 'Experence Name',
                          hintStyle: TextStyle(color: Colors.grey)),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text('How many Experence?(In years)'),
                    TextFormField(
                      validator: (val){
                        if (val == null){
                          return 'Required Field';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.go,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(2),
                      ],
                      onChanged: (val) {
                        setState(() {
                          expYear = val;
                        });
                      },
                    ),
                    MaterialMyButton(btnText: 'Add',colour: primaryColor,onPress: ()async{
                          if (_addExp.currentState.validate()){
                            try{
                              await widget.CollectionRef.add({
                                "expTime":int.parse(this.expYear),
                                "title":this.expName
                              });
                            }
                            catch(e){
                              print(e);
                            }
                            print('Successfully added');
                            Navigator.of(context).pop();
                          }
                    },),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
