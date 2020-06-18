import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:newstuck/clement_activities/const.dart';
import 'package:newstuck/clement_activities/filters.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class CustomDropdown extends StatefulWidget {
  final Function(List<dynamic>) dropFilter;
  bool isSelected;
  final Function(String text) setText;
  CustomDropdown(this.dropFilter, this.isSelected, this.setText);
  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  GlobalKey actionKey;
  double height, width, xPosition, yPosition;
  bool isDropdownOpened = false;
  OverlayEntry floatingDropdown;
  String text = "Last 24 hours";
  var feedItems = new List<dynamic>();
  bool isDateChosen = false;

  void justCollapse(){
    setState(() {
      floatingDropdown.remove();
      isDropdownOpened = false;
    });
  }

  void collapse(newText) {
    setState(() {
      text = newText;
      widget.setText(newText);
      print(text);
      
      isDropdownOpened = false;
      print("Insie Collapse");
      if (text != 'Choose Date' && !text.contains("/")) {
        filter(text, widget.isSelected).then((response) => {
              // print("Inside Collapse"),

              feedItems = json.decode(response.body),
              print("Response Length : " + feedItems[0]["count"].toString()),
              feedItems = feedItems[0]["feedItemViewModel"],
              print("Inside Filter : " + feedItems.length.toString()),
              // print(feedItems);
              widget.dropFilter(feedItems)
            });
      }
    });
  }

  void changeText(newText) {
    setState(() {
      text = newText;
      widget.setText(newText);
    });
  }

  @override
  void initState() {
    actionKey = LabeledGlobalKey(text);
    super.initState();
  }

  void findDropdownData() {
    RenderBox renderBox = actionKey.currentContext.findRenderObject();
    height = renderBox.size.height;
    width = renderBox.size.width;
    Offset offset = renderBox.localToGlobal(Offset.zero);
    xPosition = offset.dx;
    yPosition = offset.dy;
    print(height);
    print(width);
    print(xPosition);
    print(yPosition);
  }

  OverlayEntry _createFloatingDropdown() {
    return OverlayEntry(builder: (context) {
      return Positioned(
        left: xPosition,
        width: width,
        top: yPosition + height,
        height: 8 * height + 80,
        child: DropDown(
            collapse, changeText, height, widget.dropFilter, widget.isSelected,justCollapse),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: actionKey,
      onTap: () {
        setState(() {
          if (isDropdownOpened) {
            floatingDropdown.remove();
          } else {
            findDropdownData();
            floatingDropdown = _createFloatingDropdown();
            Overlay.of(context).insert(floatingDropdown);
          }
          isDropdownOpened = !isDropdownOpened;
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Color(0xFF9a2424),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              text.toUpperCase(),
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.bold),
            ),
            Icon(
              Icons.arrow_drop_down,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

class DropDown extends StatefulWidget {
  final Function(String) collapse;
  final Function() justCollapse;
  final Function(String) changeText;
  final double itemHeight;
  final Function(List<dynamic>) dropFilter;
  bool isSelected;
  final List<String> options = [
    'Last 3 days',
    'Last 24 hours',
    'Last 5 hours',
    'Last 4 hours',
    'Last 3 hours',
    'Last 2 hours',
    'Last 1 hour',
    'Choose Date'
  ];

  DropDown(this.collapse, this.changeText, this.itemHeight, this.dropFilter,
      this.isSelected,this.justCollapse);

  @override
  DropDownState createState() => new DropDownState();
}

class DropDownState extends State<DropDown> {
  void filterfeedCurrent(String FromDate, String pageNumber,
      bool selectedArticles, String ToDate) async {
    http.Response response;
    final prefs = await SharedPreferences.getInstance();

    String token = prefs.getString("token");
    // print(token);
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      "Authorization": "Bearer " + token
    };

    String uid = prefs.getString("u_id");
    response = await http.get(
        returnDomain() +
            "api/Feed/GetFeedItems?SelectedArticles=$selectedArticles&UserId=$uid&FromDate=$FromDate&ToDate=$ToDate&PageNumber=$pageNumber",
        headers: requestHeaders);

    var feedItems = new List<dynamic>();
    feedItems = json.decode(response.body);
    feedItems = feedItems[0]["feedItemViewModel"];
    print("After Print");
    print(feedItems);
    widget.dropFilter(feedItems);
    // return response;
  }

  void filterfeedreviewCurrent(String FromDate, String pageNumber,
      bool selectedArticles, String ToDate) async {
    http.Response response;
    final prefs = await SharedPreferences.getInstance();

    String token = prefs.getString("token");
    print(token);
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      "Authorization": "Bearer " + token
    };

    String uid = prefs.getString("u_id");
    response = await http.get(
        returnDomain() +
            "api/Feed/GetReviewedArticles?SelectedArticles=$selectedArticles&UserId=$uid&FromDate=$FromDate&ToDate=$ToDate&PageNumber=$pageNumber",
        headers: requestHeaders);
    var feedItems = new List<dynamic>();
    feedItems = json.decode(response.body);
    feedItems = feedItems[0]["feedItemViewModel"];
    print("After Print");
    print(feedItems);
    widget.dropFilter(feedItems);

    // return response;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 5,
        ),
        Material(
          child: Container(
            height: 8 * widget.itemHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    widget.collapse(widget.options[0]);
                  },
                  child: DropDownItem.first(
                    text: widget.options[0],
                    isSelected: false,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    widget.collapse(widget.options[1]);
                  },
                  child: DropDownItem(
                    text: widget.options[1],
                    isSelected: false,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    widget.collapse(widget.options[2]);
                  },
                  child: DropDownItem(
                    text: widget.options[2],
                    isSelected: false,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    widget.collapse(widget.options[3]);
                  },
                  child: DropDownItem(
                    text: widget.options[3],
                    isSelected: false,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    widget.collapse(widget.options[4]);
                  },
                  child: DropDownItem(
                    text: widget.options[4],
                    isSelected: false,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    widget.collapse(widget.options[5]);
                  },
                  child: DropDownItem(
                    text: widget.options[5],
                    isSelected: false,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    widget.collapse(widget.options[6]);
                  },
                  child: DropDownItem(
                    text: widget.options[6],
                    isSelected: false,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // widget.collapse(widget.options[7]);
                    widget.justCollapse();
                    showDatePicker(
                            builder: (BuildContext context, Widget child) {
                              return Theme(
                                data: ThemeData.light().copyWith(
                                  colorScheme: ColorScheme.light(
                                      primary: Color(0xFF9a2424)),
                                  buttonTheme: ButtonThemeData(
                                      textTheme: ButtonTextTheme
                                          .primary), //OK/Cancel button text color
                                  primaryColor:
                                      Color(0xFF9a2424), //Head background
                                  accentColor:
                                      Color(0xFF9a2424), //selection color
                                  //dialogBackgroundColor: Colors.white,//Background color
                                ),
                                child: child,
                              );
                            },
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2001),
                            lastDate: DateTime(2021))
                        .then((date) {
                      if (date != null) {
                        String d = date.year.toString() +
                            "-" +
                            date.month.toString() +
                            "-" +
                            date.day.toString();
                        var formatter2 = new DateFormat('yyyy-MM-dd');
                        String formattedDate = formatter2.format(date);

                        widget.changeText(formattedDate);

                        var formatter1 =
                            new DateFormat('EEE, d MMM y 18:30:00 ');
                        var subDt = date.toUtc().subtract(Duration(days: 1));
                        subDt = subDt.add(Duration(days: 1));
                        String formatted1 = formatter1.format(subDt);
                        String FromDate = formatted1 + "GMT";
                        print(FromDate);
                        print("After Date Selected");

                        var now = new DateTime.now();
                        var formatter = new DateFormat('EEE MMM d y HH:mm:ss ');
                        String ToDate = formatter.format(now);
                        ToDate = ToDate + "GMT 0530 (India Standard Time)";
                        print(ToDate + "GMT 0530 (India Standard Time)");

                        if (widget.isSelected) {
                          filterfeedreviewCurrent(
                              FromDate, "1", widget.isSelected, ToDate);
                        } else {
                          filterfeedCurrent(
                              FromDate, "1", widget.isSelected, ToDate);
                        }
                      }
                    });
                  },
                  child: DropDownItem.last(
                    text: widget.options[7],
                    isSelected: false,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class DropDownItem extends StatelessWidget {
  final String text;
  final bool isSelected;
  final bool isFirstItem;
  final bool isLastItem;

  const DropDownItem(
      {Key key,
      this.text,
      this.isSelected = false,
      this.isFirstItem = false,
      this.isLastItem = false})
      : super(key: key);

  factory DropDownItem.first({String text, bool isSelected}) {
    return DropDownItem(
      text: text,
      isSelected: isSelected,
      isFirstItem: true,
    );
  }

  factory DropDownItem.last({String text, bool isSelected}) {
    return DropDownItem(
      text: text,
      isSelected: isSelected,
      isLastItem: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(
          top: isFirstItem ? Radius.circular(20) : Radius.zero,
          bottom: isLastItem ? Radius.circular(20) : Radius.zero,
        ),
        //color: isSelected ? Color(0xFF9a2424) : Color(0xCC9a2424),
        color: Color(0xCC9a2424),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            text.toUpperCase(),
            style: TextStyle(
                color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
