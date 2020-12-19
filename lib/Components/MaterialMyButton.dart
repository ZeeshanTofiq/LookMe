import 'package:flutter/material.dart';

class MaterialMyButton extends StatelessWidget {
  final Color colour;
  final Function onPress;
  final String btnText;
  final Color textColor;
  MaterialMyButton({this.colour = Colors.blue,this.onPress,this.btnText,this.textColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(9.0),
      ),
      elevation: 5.0,
      color: this.colour,
      onPressed: this.onPress,
      child: Text(
           this.btnText,
          style: TextStyle(color: this.textColor),
      ),
    );
  }
}
