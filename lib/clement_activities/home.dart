import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class Home extends StatefulWidget {
  @override
  _Home createState() {
    // TODO: implement createState
    return _Home();
  }
}

class _Home extends State<Home> {
  var map = new Map<String, dynamic>();
  final uri = "http://104.211.200.236:8080/Users/Login";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Center(
          child: Text(
            "NewsTuck",
            style: new TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: new Color(0xff9a2424),
      ),
      body: Center(
          child: Container(
        margin: EdgeInsets.all(20),
        child: Center(
            child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 70, left: 10, right: 10),
              child: TextFormField(
                decoration: const InputDecoration(
                  icon: Icon(Icons.account_circle),
                  labelText: 'Username',
                ),
                onSaved: (String value) {
                  // This optional block of code can be used to run
                  // code when the user saves the form.
                },
                onChanged: (value) {
                  map["username"] = value;
                },
                // validator: (String value) {
                //   return value.contains('@') ? 'Do not use the @ char.' : null;
                // },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 70, left: 10, right: 10),
              child: TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                  icon: Icon(Icons.device_hub),
                  labelText: 'Password',
                ),
                onSaved: (String value) {
                  // This optional block of code can be used to run
                  // code when the user saves the form.
                },
                onChanged: (value) {
                  map["password"] = value;
                },
                // validator: (String value) {
                //   return value.contains('@') ? 'Do not use the @ char.' : null;
                // },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(50),
              child: OutlineButton(
                onPressed: () => {login()},
                child: Text("Login"),
                highlightedBorderColor: new Color(0xff9a2424),
                highlightColor: new Color(0xff9a2424),
              ),
            )
          ],
        )),
        width: MediaQuery.of(context).size.width * 0.95,
        height: 450,
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(width: 1.0, color: Color(0xff9a2424)),
            left: BorderSide(width: 1.0, color: Color(0xff9a2424)),
            right: BorderSide(width: 1.0, color: Color(0xff9a2424)),
            bottom: BorderSide(width: 1.0, color: Color(0xff9a2424)),
          ),
        ),
      )),
    );
  }

  void login() async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json'
    };
    print(map);
    http.Response response = await http.post(uri, body: json.encode(map),headers: {'Content-type': 'application/json'});
    print(response.body);
  }
}
