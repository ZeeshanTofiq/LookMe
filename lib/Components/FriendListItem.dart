import 'package:flutter/material.dart';
import 'package:look_me/Components/MaterialMyButton.dart';
import 'package:look_me/Screens/Profile.dart';

class FriendListItem extends StatelessWidget {
  final data;
  FriendListItem({this.data});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(data["name"] == null || data["name"] == ''
            ? '---'
            : data["name"]),
        subtitle: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              data["Experences"].length != 0
                  ? data["Experences"].join(',')
                  : 'No added any experences',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            MaterialMyButton(
              colour: Colors.blueAccent,
              btnText: 'View Profile',
              onPress: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context)=>Profile(),
                        settings: RouteSettings(
                            arguments: data["profileRef"]
                        )
                    )
                );
              },
            ),
          ],
        ),
        leading: CircleAvatar(
          radius: 25,
          backgroundImage:
              data["profileImg"] == null || data["profileImg"] == ''
                ? AssetImage('images/profileImg.png')
                : NetworkImage('${data["profileImg"]}'),
        ),
      ),
    );
  }
}
