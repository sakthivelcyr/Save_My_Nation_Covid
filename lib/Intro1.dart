import 'package:covid_ui_check/first_screen.dart';
import 'package:covid_ui_check/loading.dart';
import 'package:covid_ui_check/shared.dart';
import 'package:covid_ui_check/sign_in.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

Position position;

class _LoginState extends State<Login> {
  final Location location = Location();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;
  bool loading = true;

  getSignIn() async {
    await signInWithGoogle().whenComplete(() {
      if (name == null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) {
              return Login();
            },
          ),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) {
              return FirstScreen();
            },
          ),
        );
      }
    });
  }

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
    print(_locationData.latitude);
  }

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  @override
  Widget build(BuildContext context) {
    getLocation();
    getSignIn();
    MediaQueryData queryData = MediaQuery.of(context);
    double ht = queryData.size.height;
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: Scaffold(
        body: loading
            ? LoadingIntro()
            : new Container(
                height: ht,
                width: queryData.size.width,
                decoration: bd,
                child: Column(
                  children: <Widget>[
                    Container(height: ht / 2, child: img()),
                    SizedBox(
                      height: ht / 2.5,
                    ),
                    Container(
                      child: Text(
                        'Welcome to Save My Nation',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1,
                          fontStyle: FontStyle.italic,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
