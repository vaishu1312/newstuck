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
  var user = new Map<String, dynamic>();
  var user_error = false;
  var pass_error = false;
  String password_error = "";
  String username_error = "";
  bool showPass = false;

  void initState() {
    map["username"] = "";
    map["password"] = "";
  }

  final uri = "http://104.211.200.236:8080/Users/Login";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Center(
          child: Text(
            "NEWSTUCK",
            style: new TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: new Color(0xff9a2424),
      ),
      body: Builder(
        builder: (context) => SingleChildScrollView(
          child: Center(
              child: Container(
            margin: EdgeInsets.all(20),
            child: Center(
                child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 70, left: 10, right: 80),
                  child: TextFormField(
                    decoration: InputDecoration(
                      icon: Icon(Icons.account_circle),
                      errorText: user_error ? username_error : null,
                      labelText: 'Username',
                      // errorText: username_empty ? "Username is "
                    ),
                    onSaved: (String value) {
                      // This optional block of code can be used to run
                      // code when the user saves the form.
                    },
                    onChanged: (value) {
                      if (user_error) {
                        setState(() {
                          user_error = false;
                        });
                      }
                      setState(() {
                        map["username"] = value;
                      });
                    },
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding:
                            const EdgeInsets.only(top: 70, left: 10, right: 10),
                        child: TextFormField(
                          obscureText: !showPass,
                          decoration: InputDecoration(
                              icon: Icon(Icons.device_hub),
                              labelText: 'Password',
                              errorText: pass_error ? password_error : null),
                          onSaved: (String value) {
                            // This optional block of code can be used to run
                            // code when the user saves the form.
                          },
                          onChanged: (value) {
                            if (pass_error) {
                              setState(() {
                                pass_error = false;
                              });
                            }
                            setState(() {
                              map["password"] = value;
                            });
                          },
                          // validator: (String value) {
                          //   return value.contains('@') ? 'Do not use the @ char.' : null;
                          // },
                        ),
                      ),
                    ),
                    Padding(
                        child: IconButton(
                            icon: Icon(Icons.remove_red_eye),
                            onPressed: () {
                              setState(() {
                                showPass = !showPass;
                              });
                            }),
                        padding: EdgeInsets.only(top: 80, right: 20))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(50),
                  child: OutlineButton(
                    onPressed: () => {login(context)},
                    child: Text("Login"),
                    highlightedBorderColor: new Color(0xff9a2424),
                    highlightColor: new Color(0xff9a2424),
                  ),
                ),
              ],
            )),
            
            
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(width: 1.0, color: Color(0xff9a2424)),
                left: BorderSide(width: 1.0, color: Color(0xff9a2424)),
                right: BorderSide(width: 1.0, color: Color(0xff9a2424)),
                bottom: BorderSide(width: 1.0, color: Color(0xff9a2424)),
              ),
            ),
          )),
        ),
      ),
    );
  }

  void login(BuildContext context) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json'
    };
    http.Response response = await http.post(uri,
        body: json.encode(map), headers: {'Content-type': 'application/json'});
    user = json.decode(response.body);
    print(user);
    if (response.statusCode == 400) {
      if (user["errors"] != null) {
        if (user["errors"]["Username"] != null &&
            user["errors"]["Password"] != null) {
          print("Both Username And Password Required");

          setState(() {
            username_error = "Username is Required";
            password_error = "Password is Required";
            user_error = true;
            pass_error = true;
          });
        } else if (user["errors"]["Username"] != null) {
          setState(() {
            username_error = "Username is Required";
            user_error = true;
          });
        } else {
          setState(() {
            password_error = "Password is Required";
            pass_error = true;
          });
        }
      } else if (user["message"] != null) {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('Invalid Credentials'),
        ));
      } else {
        print(user);
      }
    }
  }
}
