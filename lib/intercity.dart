import 'dart:convert';
import 'package:covid_ui_check/constant.dart';
import 'package:covid_ui_check/shared.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:imei_plugin/imei_plugin.dart';
import 'package:location/location.dart';

class InterCity extends StatefulWidget {
  @override
  _InterCity createState() => _InterCity();
}

class _InterCity extends State<InterCity> {
  String _platformImei = 'Unknown';
  String uniqueId = "Unknown";
  String errFD = '';
  String errTD = '';
  String errS = '';
  bool _validateN = false;
  bool _validateM = false;
  bool _validateA = false;
  bool _validateC = false;
  String _dropDownFDistrictValue, _dropDownStateValue, _dropDownTDistrictValue;
  String name, fdistrict, mobnum, comments, add, tdistrict, state;

  final String surl =
      "https://tailermade.com/savemynation/api/v1/savemynation/state";
  final String durl =
      "https://tailermade.com/savemynation/api/v1/savemynation/district";

  List stdata = List();
  double latitude, longitude;
  final Location location = Location();
  List fdtData = List();
  List tdtData = List();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  void getLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    _locationData = await location.getLocation();
    latitude = _locationData.latitude;
    longitude = _locationData.longitude;
  }

  Future<String> getSTData() async {
    var res = await http
        .get(Uri.encodeFull(surl), headers: {"Accept": "application/json"});
    var resBody = json.decode(res.body)['state'];
    print(resBody);
    List<String> stags = resBody != null ? List.from(resBody) : null;
    setState(() {
      stdata = stags;
    });
    return "Sucess";
  }

  Future<http.Response> postDTRequest() async {
    Map data = {'state': state};
    //encode Map to JSON
    //String body = json.encode(data);
    var response = await http.post(durl,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: data,
        encoding: Encoding.getByName("gzip"));
    var reBody = json.decode(response.body)['district'];
    List<String> dttags = reBody != null ? List.from(reBody) : null;
    setState(() {
      fdtData = dttags;
      tdtData = dttags;
    });
    return response;
  }

  Future<http.Response> postRequest() async {
    Map data = {
      'name': name,
      'from_state': state,
      'mobile': mobnum,
      'deviceType': 'mobile',
      'from_district': fdistrict,
      'to_district': tdistrict,
      'address': add,
      'deviceToken': uniqueId,
      'comments': comments,
      'device_latitude': latitude.toString(),
      'device_longitude': longitude.toString(),
    };
    //encode Map to JSON
    //String body = json.encode(data);
    var sendResponse = await http.post(
        'https://tailermade.com/savemynation/api/v1/savemynation/citytravel',
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: data,
        encoding: Encoding.getByName("gzip"));
    //var reBody = json.decode(response.body)['district'];
    //List<String> dttags = reBody != null ? List.from(reBody) : null;
    setState(() {
      print(sendResponse.body);
      //dtData = dttags;
    });
    return sendResponse;
  }

  Future<void> initPlatformState() async {
    String platformImei;
    String idunique;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformImei =
          await ImeiPlugin.getImei(shouldShowRequestPermissionRationale: true);
      idunique = await ImeiPlugin.getId();
      print(platformImei);
    } catch (e) {
      print(e);
      platformImei = 'Failed to get platform version.';
    }
    if (!mounted) return;

    setState(() {
      print(idunique);
      _platformImei = platformImei;
      uniqueId = idunique;
    });
  }

  @override
  void initState() {
    super.initState();
    this.getSTData();
    initPlatformState();
    getLocation();
  }

  @override
  Widget build(BuildContext context) {
    Widget inputBox(
        String label, String errMsg, int i, bool validate, TextInputType t) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: TextFormField(
          keyboardType: t,
          autofocus: false,
          autovalidate: true,
          onChanged: (value) {
            if (i == 1) {
              _validateN = false;
              name = value;
            }
            if (i == 2) {
              _validateM = false;
              mobnum = value;
            }
            if (i == 3) {
              _validateA = false;
              add = value;
            }
            if (i == 4) {
              _validateC = false;
              comments = value;
            }
          },
          decoration: idInterior.copyWith(
              labelText: label, errorText: validate ? errMsg : null),
        ),
      );
    }

    getdrop(String head, List data, int i, String d) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Container(
          height: 60,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              border: Border.all(color: Colors.black, width: 2)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton(
              hint: d == null
                  ? Text(head)
                  : Text(
                      d,
                      style: TextStyle(color: Colors.black),
                    ),
              isExpanded: true,
              iconSize: 30.0,
              style: TextStyle(color: Colors.black),
              isDense: false,
              items: data.map(
                (val) {
                  return DropdownMenuItem<String>(
                    value: val,
                    child: Text(val),
                  );
                },
              ).toList(),
              onChanged: (val) {
                setState(
                  () {
                    errS = '';
                    errFD = '';
                    errTD = '';
                    if (i == 1) {
                      _dropDownStateValue = val;
                      state = val;
                      this.postDTRequest();
                    }
                    if (i == 2) {
                      _dropDownFDistrictValue = val;
                      fdistrict = val;
                    }
                    if (i == 4) {
                      _dropDownTDistrictValue = val;
                      tdistrict = val;
                    }
                  },
                );
              },
            ),
          ),
        ),
      );
    }

    MediaQueryData queryData = MediaQuery.of(context);
    double ht = queryData.size.height;
    double wt = queryData.size.width;
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
          title: Text('Inter City Travel'),
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, false),
          ),
        ),
        body: Container(
          //decoration: bd,
          height: ht,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: wt / 10,
                ),
                inputBox('Name', 'Name must contains atleast 5 characters', 1,
                    _validateN, TextInputType.text),
                SizedBox(
                  height: wt / 20,
                ),
                inputBox('Mobile Number', 'Invalid Mobile Number', 2,
                    _validateM, TextInputType.number),
                SizedBox(
                  height: wt / 20,
                ),
                inputBox(
                    'Address',
                    'Address must contains atleast 10 characters',
                    3,
                    _validateA,
                    TextInputType.multiline),
                SizedBox(
                  height: wt / 20,
                ),
                headPadding('From State', wt),
                getdrop('From State', stdata, 1, _dropDownStateValue),
                SizedBox(
                  height: wt / 60,
                ),
                errorMsg(errS),
                SizedBox(
                  height: wt / 40,
                ),
                headPadding('From District', wt),
                getdrop('From District', fdtData, 2, _dropDownFDistrictValue),
                SizedBox(
                  height: wt / 40,
                ),
                errorMsg(errFD),
                SizedBox(
                  height: wt / 40,
                ),
                headPadding('To District', wt),
                getdrop('To District', tdtData, 4, _dropDownTDistrictValue),
                SizedBox(
                  height: wt / 40,
                ),
                errorMsg(errTD),
                SizedBox(
                  height: wt / 40,
                ),
                inputBox(
                    'Comments',
                    'Comments must contains atleast 10 characters',
                    4,
                    _validateC,
                    TextInputType.multiline),
                SizedBox(
                  height: wt / 25,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      onPressed: () {
                        setState(() {
                          var i = 0;
                          if (name == null) {
                            _validateN = true;
                            i = 1;
                          }
                          if (mobnum == null || mobnum.length != 10) {
                            _validateM = true;
                            i = 1;
                          }
                          if (add == null || add.length < 10) {
                            _validateA = true;
                            i = 1;
                          }
                          if (comments == null || comments.length < 10) {
                            _validateC = true;
                            i = 1;
                          }
                          if (_dropDownStateValue == null) {
                            errS = 'Please select your state';
                            i = 1;
                          }
                          if (_dropDownFDistrictValue == null) {
                            errFD = 'Please select your district';
                            i = 1;
                          }
                          if (_dropDownTDistrictValue == null) {
                            errTD = 'Please select your district';
                            i = 1;
                          }
                          if (i == 0) {
                            postRequest();
                            Fluttertoast.showToast(
                                msg:
                                    "Great! We have successfully updated your data",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.blue,
                                textColor: Colors.white,
                                fontSize: wt / 25);
                          } else {
                            Fluttertoast.showToast(
                                msg: "Error Found",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.blue,
                                textColor: Colors.white,
                                fontSize: wt / 25);
                          }
                        });
                      },
                      shape: rrb,
                      color: Colors.lightBlueAccent,
                      padding:
                          EdgeInsets.symmetric(horizontal: 45, vertical: 10),
                      child: tSubmit,
                    ),
                  ],
                ),
                SizedBox(
                  height: wt / 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
