import 'package:contacts_service/contacts_service.dart';
import 'package:covid_ui_check/constant.dart';
import 'package:covid_ui_check/loading.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class SearchBox extends StatefulWidget {
  @override
  _SearchBoxState createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  var f = 0;
  bool loading = true;
  Iterable<Item> phones1 = [];
  Iterable<Contact> _contacts;
  static bool _validate = false;
  var i = 0;

  @override
  void initState() {
    super.initState();
    getContacts();
    setState(() {
      loading = true;
    });
  }

  getContacts() async {
    var status = await Permission.camera.status;
    if (status.isUndetermined) {
      print('no');
      // We didn't ask for permission yet.
    }
    if (await Permission.location.isRestricted) {}
    if (await Permission.contacts.request().isGranted) {}
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.storage,
      Permission.contacts,
    ].request();
    print(statuses[Permission.contacts]);
    if (statuses[Permission.contacts] == PermissionStatus.granted) {
      var contacts = await ContactsService.getContacts();
      print(contacts);
      print('hi');
      setState(() {
        _contacts = contacts;
      });
    }
  }

  String flattenPhoneNumber(String phoneStr) {
    return phoneStr.replaceAllMapped(RegExp(r'^(\+)|\D'), (Match m) {
      return m[0] == "+" ? "+" : "";
    });
  }

  String mobile;
  Contact c;
  
  String selectedValue = 'hi';
  final List<DropdownMenuItem> items = [];
  TextEditingController _textFieldController = TextEditingController();

  getContact() {
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
    print(items.length);
    setState(() {
      
      loading = false;
    });
  }

  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Enter Phone Number'),
            content: TextField(
              keyboardType: TextInputType.number,
              controller: _textFieldController,
              decoration: InputDecoration(hintText: "Phone Number"),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Done'),
                onPressed: () {
                  setState(() {
                    f = 1;
                  });
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  Widget card(double ht, double wt) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Card(
        borderOnForeground: true,
        elevation: 3,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.black, width: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(7),
          child: Stack(children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 5, top: 5, bottom: 5),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: wt / 5,
                        height: wt / 5,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage('kl'),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(80.0),
                          border: Border.all(
                            color: Colors.white,
                            width: 1.0,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: wt / 18,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Arun Kumar K',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: wt / 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(
                            height: wt / 400,
                          ),
                          Text(
                            'Medical',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              color: Colors.black,
                              fontSize: wt / 25,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(
                            height: ht / 150,
                          ),
                          Text(
                            'Trichy',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              color: Colors.black,
                              fontSize: wt / 27,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(
                            height: ht / 150,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      FlatButton.icon(
                        label: Text('Add to Watch List'),
                        onPressed: () {},
                        icon: Icon(Icons.star),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //getContact();
    items.add(DropdownMenuItem(
      child: Text('Select Contact'),
      value: 'Select con',
    ));
    MediaQueryData queryData = MediaQuery.of(context);
    double ht = queryData.size.height;
    double wt = queryData.size.width;
    //get();
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: kBackgroundColor,
        fontFamily: "Poppins",
        textTheme: TextTheme(
          body1: TextStyle(color: kBodyTextColor),
        ),
        primaryColor: kPrimaryColor,
      ),
      home: Scaffold(
              appBar: AppBar(
                title: Text('Contact Search'),
                automaticallyImplyLeading: true,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context, false),
                ),
              ),
              body: loading
          ? Loading()
          : new Container(
                child: Column(
                  children: <Widget>[
                    FlatButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 0.0),
                            child: Text(
                              'Search Phone Number Globally',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 17,
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Icon(
                              Icons.search,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                      color: Colors.white60,
                      onPressed: () => _displayDialog(context),
                    ),
                    SizedBox(
                      height: wt / 90,
                    ),
                    Divider(
                      height: 0.5,
                      thickness: 0.5,
                      color: Colors.black38,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 7),
                      child: SearchableDropdown.single(
                        items: items,
                        displayClearIcon: true,
                        value: selectedValue,
                        hint: "Search Phone number in Contacts",
                        onChanged: (value) {
                          setState(() {
                            print(value);
                            selectedValue = value;
                          });
                        },
                        //closeButton: InkWell(child: Text('Search Globally',style: TextStyle(color:Colors.green),),onTap: (){},),
                        dialogBox: true,
                        isExpanded: true,
                      ),
                    ),
                    Divider(
                      height: 0.5,
                      thickness: 0.5,
                      color: Colors.black38,
                    ),
                    (f == 1) ? card(ht, wt) : Text(''),
                  ],
                ),
              ),
            ),
    );
  }
}
