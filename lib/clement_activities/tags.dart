import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class TagBuild extends StatefulWidget {
  _TagBuild createState() {
    return _TagBuild();
  }
}

class _TagBuild extends State<TagBuild> {
  var eduSelected = false;
  var polSelected = false;
  var covSelected = false;
  var cheSelected = false;
  var tnSelected = false;
  var ecoSelected = false;
  final RoundedLoadingButtonController _btnController1 =
      new RoundedLoadingButtonController();
  final RoundedLoadingButtonController _btnController2 =
      new RoundedLoadingButtonController();
  final RoundedLoadingButtonController _btnController3 =
      new RoundedLoadingButtonController();
  final RoundedLoadingButtonController _btnController4 =
      new RoundedLoadingButtonController();
  final RoundedLoadingButtonController _btnController5 =
      new RoundedLoadingButtonController();
  final RoundedLoadingButtonController _btnController6 =
      new RoundedLoadingButtonController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GridView.count(
      crossAxisCount: 3,
      padding: EdgeInsets.all(50),
      children: [
        RoundedLoadingButton(
          width: 100,
          color: eduSelected ? Colors.green : Colors.red,
          child: Text('Education', style: TextStyle(color: Colors.white)),
          controller: _btnController1,
          onPressed: () {
            setState(() {
              eduSelected = !eduSelected;
            });
            tagEdu("Education", _btnController1);
          },
        ),
        RoundedLoadingButton(
          color: polSelected ? Colors.green : Colors.red,
          width: 100,
          child: Text('Politics', style: TextStyle(color: Colors.white)),
          controller: _btnController2,
          onPressed: () {
            setState(() {
              polSelected = !polSelected;
            });
            tagEdu("Education", _btnController2);
          },
        ),
        RoundedLoadingButton(
          color: covSelected ? Colors.green : Colors.red,
          width: 100,
          child: Text('COVID-19', style: TextStyle(color: Colors.white)),
          controller: _btnController3,
          onPressed: () {
            setState(() {
              covSelected = !covSelected;
            });
            tagEdu("Education", _btnController3);
          },
        ),
        RoundedLoadingButton(
          color: cheSelected ? Colors.green : Colors.red,
          width: 100,
          child: Text('Chennai', style: TextStyle(color: Colors.white)),
          controller: _btnController4,
          onPressed: () {
            setState(() {
              cheSelected = !cheSelected;
            });
            tagEdu("Education", _btnController4);
          },
        ),
        RoundedLoadingButton(
          color: tnSelected ? Colors.green : Colors.red,
          width: 100,
          child: Text('Tamilnadu', style: TextStyle(color: Colors.white)),
          controller: _btnController5,
          onPressed: () {
            setState(() {
              tnSelected = !tnSelected;
            });
            tagEdu("Education", _btnController5);
          },
        ),
        RoundedLoadingButton(
          color: ecoSelected ? Colors.green : Colors.red,
          width: 100,
          child: Text('Economy', style: TextStyle(color: Colors.white)),
          controller: _btnController6,
          onPressed: () {
            setState(() {
              ecoSelected = !ecoSelected;
            });
            tagEdu("Education", _btnController6);
          },
        ),
      ],
    ));
  }

  void tagEdu(String tag, RoundedLoadingButtonController controller) async {
    Timer(Duration(seconds: 1), () {
      controller.reset();
      // controller.reset();
      //   Timer(Duration(seconds: 2), () {
      //   controller.reset();
      //   // controller.reset();

      // });
    });
  }
}
