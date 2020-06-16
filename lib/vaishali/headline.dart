import 'package:flutter/material.dart';
import 'package:newstuck/vaishali/webview.dart';
import 'package:newstuck/clement_activities/ranks.dart';
import 'package:newstuck/clement_activities/tags.dart';

class HeaderRow extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HeaderRowState();
}

class HeaderRowState extends State<HeaderRow> {
  bool isPressed = false;
  bool isReviewed = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      //mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
            title: MyLink('HeadLines go here'),
            subtitle: Text('Mon Jun 15 2020 09:39:37  | The Hindu - News |'),
            trailing: ClipOval(
              child: Material(
                color: (isPressed)
                    ? Color(0xff00AA00)
                    : Colors.transparent, //Color(0xff9A9A9A), // button color
                child: InkWell(
                  splashColor: (isPressed)
                      ? Color(0x6600AA00)
                      : Color(0x669A9A9A), // inkwell color
                  child: SizedBox(
                      width: 56, height: 56, child: Icon(Icons.done_outline)),
                  onTap: () {
                    setState(() {
                      isPressed = !isPressed;
                      if (isReviewed == false) isReviewed = true;
                    });
                  },
                ),
              ),
            )
            /*trailing: IconButton(
          tooltip: 'Review article',
          icon: Icon(Icons.done_outline),
          highlightColor: (isPressed) ? Color(0x6600AA00) : Color(0x669A9A9A),
          color: (isPressed) ? Color(0xff00AA00) : Color(0xff9A9A9A),
          onPressed: () {
            setState(() {
              isPressed = !isPressed;
            });
          }),*/
            ),
        isReviewed
            ? SizedBox(height: 200.0, child: rankBar())
            : Container(height: 0),
        isReviewed
            ? SizedBox(height: 200.0, child: TagBuild())
            : Container(height: 0),
      ],
    );
  }
}

class MyLink extends StatelessWidget {
  MyLink(this.val);
  final String val;
  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.contain,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) =>
                  MyWebView('https://www.thehindu.com/')));
        },
        child: Text(
          val,
          style: TextStyle(
            decoration: TextDecoration.underline,
            color: Colors.blue[700],
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
      ),
    );
  }

}