import 'package:flutter/material.dart';

class ReadOnlyInputField extends StatelessWidget {

  ReadOnlyInputField({this.label});
  String label = 'Name';

  TextStyle labelStyle = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children:[
            Text(
              'Name',
              style: labelStyle,
            ),
            SizedBox(
              height:8.0
            ),
            Padding(
              padding:EdgeInsets.symmetric(horizontal: 10.0),
              child: TextFormField(
                initialValue: 'zeeshan',
                readOnly: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor:Colors.white,
                  suffixIcon: Icon(Icons.navigate_next),
                  border:OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    borderSide: BorderSide(
                      color: Colors.grey
                    )
                  ),
                ),
              ),
            )
          ]
      ),
    );
  }
}
