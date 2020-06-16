import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HeaderRow extends StatefulWidget {
  var feed = new Map<String, dynamic>();
  HeaderRow(this.feed);
  @override
  State<StatefulWidget> createState() => HeaderRowState();
}

class HeaderRowState extends State<HeaderRow> {
  bool isPressed = false;

  var feedItem = new Map<String, dynamic>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    feedItem = widget.feed;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: MyLink(feedItem["title"]),
        subtitle: Text('Mon Jun 15 2020 09:39:37  | The Hindu - News |'),
        trailing: ClipOval(
          child: Material(
            color: (isPressed)
                ? Color(0xff00AA00)
                : Color(0xff9A9A9A), // button color
            child: InkWell(
              splashColor: (isPressed)
                  ? Color(0x6600AA00)
                  : Color(0x669A9A9A), // inkwell color
              child: SizedBox(
                  width: 56, height: 56, child: Icon(Icons.done_outline)),
              onTap: () {
                setState(() {
                  isPressed = !isPressed;
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
          fontSize: 20.0,
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
