import 'package:flutter/material.dart';
//import 'package:newstuck/vaishali/datePicker.dart';
//import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class CustomDropdown extends StatefulWidget {
  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  GlobalKey actionKey;
  double height, width, xPosition, yPosition;
  bool isDropdownOpened = false;
  OverlayEntry floatingDropdown;
  String text = "filter";

  void collapse(newText) {
    setState(() {
      text = newText;
      floatingDropdown.remove();
      isDropdownOpened = false;
    });
  }

  void changeText(newText) {
    setState(() {
      text = newText;
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
        child: DropDown(collapse, changeText, height),
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
        width: 160.0,
        height: 35.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Color(0xFF9a2424),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: <Widget>[
            Text(
              text.toUpperCase(),
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
            ),
            Spacer(),
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
  final Function(String) changeText;
  final double itemHeight;
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

  DropDown(this.collapse, this.changeText, this.itemHeight);

  @override
  DropDownState createState() => new DropDownState();
}

class DropDownState extends State<DropDown> {
  /* GlobalKey actionKey;
  double height, width, xPosition, yPosition;
  OverlayEntry datePicker;
  String _date="";

  @override
  void initState() {
    actionKey = LabeledGlobalKey('dropdownState');
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

  OverlayEntry _createdatePicker() {
    return OverlayEntry(builder: (context) {
      return Positioned(
        left: xPosition,
        width: width,
        top: yPosition + height,
        height: height,
        child: MyDatePicker(height),
      );
    });
  }*/

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 5,
        ),
        Material(
          //elevation: 20,
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
                    widget.collapse(widget.options[7]);
                    showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2001),
                            lastDate: DateTime(2021))
                        .then((date) {
                      String d = date.day.toString() +
                          "/" +
                          date.month.toString() +
                          "/" +
                          date.year.toString();
                      print(d);
                      widget.changeText(d);
                    });
                    /*findDropdownData();
                    datePicker = _createdatePicker();
                    Overlay.of(context).insert(datePicker);*/
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
                color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
