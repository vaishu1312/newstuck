import 'package:flutter/material.dart';
import 'package:newstuck/vaishali/webview.dart';
import 'package:newstuck/clement_activities/ranks.dart';
import 'package:newstuck/clement_activities/tags.dart';

class ExpandRow extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ExpandRowState();
}

class ExpandRowState extends State<ExpandRow> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      // key: PageStorageKey<Entry>(root),
      title: MyLink('HeadLines go here'),
      subtitle: Text('Mon Jun 15 2020 09:39:37  | The Hindu - News |'),
      trailing: Icon(Icons.done_outline,
          color: isExpanded ? Colors.green : Colors.grey),
      //backgroundColor: Colors.pink,
      children: [
        Column(
          children: [
            SizedBox(height:200.0,child:rankBar()),
            SizedBox(height:200.0,child:TagBuild())
          ],
        ),
      ],
      onExpansionChanged: (value) {
        //call to api
        setState(() {
          isExpanded = value;
        });
      },
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