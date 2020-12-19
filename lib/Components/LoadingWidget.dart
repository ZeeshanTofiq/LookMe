import 'package:flutter/material.dart';
import 'package:look_me/Utilities/Constants.dart';

class LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 3,
      child: Center(
        child: CircularProgressIndicator(
            valueColor:
            AlwaysStoppedAnimation<Color>(primaryColor)),
      ),
    );
  }
}
