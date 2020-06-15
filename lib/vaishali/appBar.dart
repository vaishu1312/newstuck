import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String appTitle = "NEWSTUCK";
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        appTitle,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 25.0,
        ),
      ),
      backgroundColor: Color(0xFF9a2424),
      elevation: 0.0,
      actions: <Widget>[
        IconButton(
          onPressed: () {
            //print('object');
          },
          icon: Icon(Icons.account_circle),
          iconSize: 45,
          splashColor: Colors.red,
        ),
      ],
    );
  }
}
