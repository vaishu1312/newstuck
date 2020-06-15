import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HeaderRow extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HeaderRowState();
}

class HeaderRowState extends State<HeaderRow> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: MyLink('HeadLines go here'),
      subtitle: Text('Mon Jun 15 2020 09:39:37  | The Hindu - News |'),
      trailing: IconButton(
          icon: Icon(Icons.done_outline),
          color: (isPressed) ? Color(0xff00AA00) : Color(0xff9A9A9A),
          onPressed: () {
            setState(() {
              isPressed = !isPressed;
            });
          }),
    );
  }
}

class MyLink extends StatelessWidget {
  MyLink(this.val);
  final String val;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: launchURL,
      child: Text(
        val,
        style: TextStyle(
          decoration: TextDecoration.underline,
          color: Colors.blue[700],
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  launchURL() async {
    const url = 'https://www.thehindu.com/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
