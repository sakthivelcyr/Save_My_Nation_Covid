import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';

var id = new InputDecoration(
  enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
      borderSide: BorderSide(color: Colors.black, width: 2)),
  focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
      borderSide: BorderSide(color: Colors.white, width: 2)),
  errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
      borderSide: BorderSide(color: Colors.red, width: 1)),
);

var idInterior = new InputDecoration(
  labelStyle: TextStyle(color: Colors.black),
  enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
      borderSide: BorderSide(color: Colors.black, width: 2)),
  focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
      borderSide: BorderSide(color: Colors.blue, width: 2)),
  errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
      borderSide: BorderSide(color: Colors.red, width: 1.2)),
);
var idInterior1 = new InputDecoration(
  labelStyle: TextStyle(color: Colors.black),
  contentPadding: EdgeInsets.symmetric(vertical: 5),
  enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
      borderSide: BorderSide(color: Colors.black, width: 2)),
  focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
      borderSide: BorderSide(color: Colors.blue, width: 2)),
  errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
      borderSide: BorderSide(color: Colors.red, width: 1.2)),
);
var idInterior2 = new InputDecoration(
  labelStyle: TextStyle(color: Colors.black),
  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
  enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
      borderSide: BorderSide(color: Colors.black, width: 1.5)),
  focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
      borderSide: BorderSide(color: Colors.white, width: 2)),
  errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
      borderSide: BorderSide(color: Colors.red, width: 1.2)),
);
var bd = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [Colors.blue[600], Colors.blue[400], Colors.blue[700]],
  ),
);

Widget img() {
  return Padding(
    padding: const EdgeInsets.only(top: 60.0, left: 15, right: 15),
    child: Image.asset(
      'assets/v6.png',
    ),
  );
}

RoundedRectangleBorder rrb = RoundedRectangleBorder(
  borderRadius: BorderRadius.all(Radius.circular(40.0)),
  side: BorderSide(color: Colors.black, width: 2),
);

Text tNext = Text(
  'Next',
  style: TextStyle(
      fontSize: 16.0,
      fontFamily: "Poppins",
      color: Colors.white,
      fontWeight: FontWeight.w700),
);

Text tSubmit = Text(
  'Submit',
  style: TextStyle(
      fontSize: 16.0,
      color: Colors.white,
      fontFamily: "Poppins",
      fontWeight: FontWeight.w700),
);

Widget headPadding(String head, double wt) {
  return Padding(
    padding: const EdgeInsets.only(left: 23, bottom: 8),
    child: Text(
      head,
      style: TextStyle(
          fontSize: wt / 26, color: Colors.black, fontWeight: FontWeight.w700),
    ),
  );
}

Widget errorMsg(String err) {
  return Padding(
    padding: const EdgeInsets.only(left: 22),
    child: Text(
      err,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.red,
      ),
    ),
  );
}

String mobile;
Contact c;
Iterable<Item> phones1 = [];
Iterable<Contact> _contacts;
String selectedValue = 'hi';
final List<DropdownMenuItem> items = [];

dynamic getContactDetails() {
  items.clear();
  String name;
  for (var i = 0; i < _contacts.length; i++) {
    c = _contacts?.elementAt(i);
    if (c.phones.length > 0) {
      var n = c.phones.length;
      for (var i = 0; i < n; i++) {
        // String cut = flattenPhoneNumber(c.phones.elementAt(i).value);
        if (name != c.displayName) {
          //print(c.phones.elementAt(i).value);
          items.add(DropdownMenuItem(
            child: Text(c.displayName),
            value: c.displayName,
          ));
          name = c.displayName;
        }
        //print(c.phones.elementAt(i).value);
      }
    }
  }
  List l = items;
  print(items.length);
  return l;
}
