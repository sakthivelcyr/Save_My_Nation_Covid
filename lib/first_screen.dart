import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covid_ui_check/Intro1.dart';
import 'package:covid_ui_check/loading.dart';
import 'package:covid_ui_check/main.dart';
import 'package:covid_ui_check/shared.dart';
import 'package:covid_ui_check/sign_in.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:imei_plugin/imei_plugin.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirstScreen extends StatefulWidget {
  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String _platformImei = 'Unknown';
  bool _validateM = false;
  String uniqueId = "Unknown";
  String mobnum;
  String firebaseToken;
  double latitude, longitude;
  final Location location = Location();
  bool _serviceEnabled;
  bool loading = false;
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

  Future<http.Response> postRequest() async {
    Map data = {
      'name': name,
      'mobile': mobnum,
      'email': email,
      'firebaseToken': firebaseToken,
      'imei': uniqueId,
      'homeLatitude': latitude.toString(),
      'homeLongitude': longitude.toString(),
    };
    //encode Map to JSON
    //String body = json.encode(data);
    var sendResponse = await http.post(
        'https://tailermade.com/savemynation/api/v1/savemynation/register',
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: data,
        encoding: Encoding.getByName("gzip"));
    //print(sendResponse);
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
    this.initPlatformState();
    getLocation();
    //postRequest();
    print(mobnum);
    print(name);
    print(email);
    print(firebaseToken);
    print(uniqueId);
    print(latitude.toString());
    print(longitude.toString());
  }

  @override
  Widget build(BuildContext context) {
    firebaseCloudMessaging() async {
      String token = await _firebaseMessaging.getToken();
      var g = FieldValue.serverTimestamp();
      firebaseToken = token;
    }

    if (name == null) {
      print('no');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    }
    MediaQueryData queryData = MediaQuery.of(context);
    double wt = queryData.size.width;
    return loading
        ? LoadingIntro()
        : new Scaffold(
            body: Container(
              decoration: bd,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                        imageUrl,
                      ),
                      radius: 60,
                      backgroundColor: Colors.transparent,
                    ),
                    SizedBox(height: 40),
                    Text(
                      'NAME',
                      style: TextStyle(
                          fontSize: wt / 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white70),
                    ),
                    SizedBox(
                      height: wt / 120,
                    ),
                    Text(
                      name,
                      style: TextStyle(
                          fontSize: wt / 15,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: wt / 20),
                    Text(
                      'EMAIL',
                      style: TextStyle(
                          fontSize: wt / 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white70),
                    ),
                    SizedBox(height: 10),
                    Text(
                      email,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: wt / 17,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        autofocus: false,
                        cursorColor: Colors.pink,
                        autovalidate: true,
                        onChanged: (value) {
                          //_validateM = false;
                          // print(value);

                          _validateM = false;
                          mobnum = value;
                        },
                        decoration: idInterior2.copyWith(
                            labelText: 'Mobile Number',
                            errorText:
                                _validateM ? 'Invalid Mobile Number' : null),
                      ),
                    ),
                    SizedBox(
                      height: wt / 20,
                    ),
                    RaisedButton(
                      onPressed: () async {
                        await firebaseCloudMessaging();

                        var i = 0;
                        setState(() {
                          if (mobnum == null || mobnum.length != 10) {
                            _validateM = true;
                            i = 1;
                          }
                        });
                        if (i == 0) {
                          setState(() {
                            loading = false;
                          });

                          print(mobnum);
                          print(name);
                          print(email);
                          print(firebaseToken);
                          print(uniqueId);
                          print(latitude.toString());
                          print(longitude.toString());
                          if (mobnum != null &&
                              name != null &&
                              email != null &&
                              firebaseToken != null &&
                              uniqueId != null &&
                              latitude.toString() != null &&
                              longitude.toString() != null) {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.setBool('first_time', false);
                            print('bool value changed');
                            await postRequest().whenComplete(() {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeScreen()),
                              );
                            });
                          }
                          SharedPreferences storePrefs =
                              await SharedPreferences.getInstance();
                          String deviceTokenShared =
                              storePrefs.getString('deviceTokenShared');
                          String emailShared = storePrefs.getString('emailShared');
                          storePrefs.setString('deviceTokenShared', uniqueId);
                          storePrefs.setString('emailShared', email);
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.setBool('first_time', false);
                          print('bool value changed');
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen()),
                          );
                          //print(a.body);
                          /* var reBody = json.decode(a.body)['messages'];
                    print(reBody);
                    if(reBody.toString()=='[This email has already been registered.]'||reBody.toString()=='[Added Successfully]') {
                    print('kl');
                    Fluttertoast.showToast(
                          msg: reBody.toString(),
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black,
                          textColor: Colors.white,
                          fontSize: wt/30
                           );
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.setBool('first_time', false);
                      print('bool value changed');  
                    Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                    } 
                    else {
                      Fluttertoast.showToast(
                          msg: reBody.toString(),
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.blue,
                          textColor: Colors.white,
                          fontSize: wt/30
                           );
                    Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                  );  
                    } */

                        }

                        //
                        /* await postRequest().whenComplete(
                    (){                      
                      Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                    }
                  ); */
                      },
                      color: Colors.lightBlueAccent,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 30),
                        child: Text(
                          'Next',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                      elevation: 5,
                      shape: rrb,
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
