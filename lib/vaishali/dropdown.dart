import 'package:flutter/material.dart';

class MyDropDown extends StatefulWidget {
  @override
  MyDropDownState createState() => MyDropDownState();
}

class MyDropDownState extends State<MyDropDown> {
  List<String> options = ['Last 3 days', 'Last 24 hours', 'Last 5 hours', 'Last 4 hours','Last 3 hours','Last 2 hours','Last 1 hour','Choose Date']; 
  String selectedOption; 
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35.0,
                  padding: EdgeInsets.symmetric(horizontal: 6.0,vertical: 0.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(
                        color: Colors.black,
                        style: BorderStyle.solid,
                        width: 0.50),
                  ),
                  child:DropdownButtonHideUnderline(
                  child:DropdownButton(
                    hint: Text(
                        'Filter'), 
                    value: selectedOption,
                    icon: Icon(Icons.keyboard_arrow_down),
                    onChanged: (newOption) {
                      setState(() {
                        selectedOption = newOption;
                      });
                    },
                    items: options.map((option) {
                      return DropdownMenuItem(
                        child: Text(option),
                        value: option,                        
                      );
                    }).toList(),
                  ),
                    
    ),
                );
  }
}





