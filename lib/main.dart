import 'dart:async';
import 'package:contacts_service/contacts_service.dart';
import 'package:covid_ui_check/Intro1.dart';
import 'package:covid_ui_check/concerns.dart';
import 'package:covid_ui_check/constant.dart';
import 'package:covid_ui_check/grocery.dart';
import 'package:covid_ui_check/intercity.dart';
import 'package:covid_ui_check/interstate.dart';
import 'package:covid_ui_check/profile_page.dart';
import 'package:covid_ui_check/search_box.dart';
import 'package:covid_ui_check/shared.dart';
import 'package:covid_ui_check/support_us.dart';
import 'package:covid_ui_check/volunteer.dart';
import 'package:covid_ui_check/widgets/my_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  //SystemChrome.setEnabledSystemUIOverlays([]);
  WidgetsFlutterBinding.ensureInitialized();
  runApp(new MaterialApp(
    title: 'Save My Nation',
    home: new SplashScreen(),
    routes: <String, WidgetBuilder>{
      '/HomePage': (BuildContext context) => new HomeScreen(), //Homepage
      '/WelcomePage': (BuildContext context) => new Login(),
    },
  ));
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool firstTime = prefs.getBool('first_time');
    String deviceTokenShared = prefs.getString('deviceTokenShared');
    String emailShared = prefs.getString('emailShared');
    print(deviceTokenShared);
    print(emailShared);
    var _duration = new Duration(seconds: 2);
    if (firstTime != null && !firstTime) {
      // Not first time
      
      return new Timer(_duration, navigationPageHome);
    } else {
      // First time

      return new Timer(_duration, navigationPageWel);
    }
  }

  void navigationPageHome() {
    Navigator.of(context).pushReplacementNamed('/HomePage');
  }

  void navigationPageWel() {
    Navigator.of(context).pushReplacementNamed('/WelcomePage');
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double wt = screenSize.width;
    TextStyle ts = TextStyle(
      fontSize: wt / 10,
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.italic,
      letterSpacing: 1,
    );
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: bd,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Save My Nation',
                    style: ts,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Save My Nation',
      theme: ThemeData(
          scaffoldBackgroundColor: kBackgroundColor,
          fontFamily: "Poppins",
          textTheme: TextTheme(
            body1: TextStyle(color: kBodyTextColor),
          )),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = ScrollController();
  double offset = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.addListener(onScroll);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  void onScroll() {
    setState(() {
      offset = (controller.hasClients) ? controller.offset : 0;
    });
  }

  Widget getWidget(double ht, double wt, LinearGradient lg, int i, String tit) {
    return InkWell(
      onTap: () {
        print(i);
        if (i == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => InterState()),
          );
        }
        if (i == 2)
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => InterCity()),
          );
        if (i == 3)
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Grocery()),
          );
        if (i == 4)
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SupportUs()),
          );
        if (i == 5)
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Volunteer()),
          );
      },
      child: Container(
        height: wt / 6,
        width: wt / 4.1,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black87, width: 1.5),
          //gradient: lg,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            getIcon(i, ht, wt),
            Text(tit,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: wt / 35,
                    fontFamily: 'Poppins')),
          ],
        ),
        //color: Colors.orange,
      ),
    );
  }

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            elevation: 5,
            contentPadding: EdgeInsets.all(20),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              new GestureDetector(
                onTap: () => Navigator.of(context).pop(false),
                child: Text("NO"),
              ),
              SizedBox(height: 16),
              new GestureDetector(
                onTap: () => Navigator.of(context).pop(true),
                child: Text("YES"),
              ),
              SizedBox(width: 16),
            ],
          ),
        ) ??
        false;
  }

  Widget getIcon(int i, double ht, double wt) {
    if (i == 1)
      return Image.asset(
        'assets/v2.png',
        height: wt / 16,
        color: Colors.black,
        width: wt / 16,
      );
    if (i == 2)
      return Image.asset(
        'assets/i1.png',
        height: wt / 12,
        color: Colors.black87,
        width: wt / 12,
      );
    if (i == 3)
      return Image.asset(
        'assets/i3.png',
        height: wt / 14,
        color: Colors.black87,
        width: wt / 14,
      );
    if (i == 4)
      return Image.asset(
        'assets/i4.png',
        height: wt / 14,
        color: Colors.black,
        width: wt / 14,
      );
    if (i == 5)
      return Image.asset(
        'assets/i7.png',
        height: wt / 12,
        color: Colors.black87,
        width: wt / 12,
      );
  }

  LinearGradient lg1 = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [Colors.green[700], Colors.green[400], Colors.green[700]],
  );
  
  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    double ht = queryData.size.height;
    double wt = queryData.size.width;
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        body: SingleChildScrollView(
          controller: controller,
          child: Column(
            children: <Widget>[
              MyHeader(
                image: "assets/icons/Drcorona.svg",
                textTop: "All you need",
                textBottom: "is stay at home.",
                offset: offset,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Dashboard\n",
                                style: kTitleTextstyle,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 4),
                            blurRadius: 30,
                            color: kShadowColor,
                          ),
                        ],
                      ),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              getWidget(ht, wt, lg1, 1, 'Inter State Travel'),
                              getWidget(ht, wt, lg1, 2, 'Inter City Travel'),
                              getWidget(ht, wt, lg1, 3, 'Grocery/Food/Medical'),
                            ],
                          ),
                          SizedBox(
                            height: wt / 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              getWidget(ht, wt, lg1, 4, 'Support Us'),
                              getWidget(ht, wt, lg1, 5, 'Volunteer'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: wt / 80),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 20),
                        Text("Watchlist", style: kTitleTextstyle),
                        SizedBox(height: 20),
                        PreventCCard(
                          address: "11, Sannathi Street, Cheyyar",
                          image: "assets/i4.png",
                          title: "Sakthivel M",
                          subtitle: "Grocery",
                          distance: "110km",
                          ht: ht,
                          wt: wt,
                        ),
                        PreventCCard(
                          address: "Thanjavur",
                          image: "assets/images/wash_hands.png",
                          title: "Arun Kumar M",
                          subtitle: "Medical",
                          distance: "310km",
                          ht: ht,
                          wt: wt,
                        ),
                        SizedBox(height: wt / 60),
                      ],
                    ),
                    SizedBox(height: wt / 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Your Profile",
                          style: kTitleTextstyle,
                        ),
                        InkWell(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UserProfilePage(
                                    'url',
                                    'name',
                                    'email',
                                    'professional',
                                    'state',
                                    'street',
                                    'district',
                                    'mobnum')),
                          ),
                          child: Text(
                            "See details",
                            style: TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Contact Search",
                          style: kTitleTextstyle,
                        ),
                        InkWell(
                          onTap: () async {
                            //await getContact();
                            //dynamic l = getContactDetails();
                            //print(l);                           

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SearchBox()),
                            );
                          },
                          child: Text(
                            "See details",
                            style: TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    /* Container(
                      margin: EdgeInsets.only(top: 20),
                      padding: EdgeInsets.all(20),
                      height: 178,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 10),
                            blurRadius: 30,
                            color: kShadowColor,
                          ),
                        ],
                      ),
                      child: Image.asset(
                        "assets/images/map.png",
                        fit: BoxFit.contain,
                      ),
                    ), */
                    SizedBox(
                      height: wt / 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Symptoms",
                              style: kTitleTextstyle,
                            ),
                            SizedBox(height: 20),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  SymptomCard(
                                    image: "assets/images/headache.png",
                                    title: "Headache",
                                    isActive: true,
                                  ),
                                  SymptomCard(
                                    image: "assets/images/caugh.png",
                                    title: "Caugh",
                                  ),
                                  SymptomCard(
                                    image: "assets/images/fever.png",
                                    title: "Fever",
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            Text("Prevention", style: kTitleTextstyle),
                            SizedBox(height: 20),
                            PreventCard(
                              text:
                                  "Since the start of the coronavirus outbreak some places have fully embraced wearing facemasks",
                              image: "assets/images/wear_mask.png",
                              title: "Wear face mask",
                            ),
                            PreventCard(
                              text:
                                  "Since the start of the coronavirus outbreak some places have fully embraced wearing facemasks",
                              image: "assets/images/wash_hands.png",
                              title: "Wash your hands",
                            ),
                            SizedBox(height: 50),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
    
  }
  
}

class PreventCard extends StatelessWidget {
  final String image;
  final String title;
  final String text;
  const PreventCard({
    Key key,
    this.image,
    this.title,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        height: 156,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: <Widget>[
            Container(
              height: 136,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 8),
                    blurRadius: 24,
                    color: kShadowColor,
                  ),
                ],
              ),
            ),
            Image.asset(image),
            Positioned(
              left: 130,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                height: 136,
                width: MediaQuery.of(context).size.width - 170,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      title,
                      style: kTitleTextstyle.copyWith(
                        fontSize: 16,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        text,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SymptomCard extends StatelessWidget {
  final String image;
  final String title;
  final bool isActive;
  const SymptomCard({
    Key key,
    this.image,
    this.title,
    this.isActive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        boxShadow: [
          isActive
              ? BoxShadow(
                  offset: Offset(0, 10),
                  blurRadius: 20,
                  color: kActiveShadowColor,
                )
              : BoxShadow(
                  offset: Offset(0, 3),
                  blurRadius: 6,
                  color: kShadowColor,
                ),
        ],
      ),
      child: Column(
        children: <Widget>[
          Image.asset(image, height: 90),
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
