import 'package:covid_ui_check/constant.dart';
import 'package:covid_ui_check/widgets/my_header.dart';
import 'package:flutter/material.dart';

class UserProfilePage extends StatelessWidget {
  final String url, name, email, professional, state, street, district, mobnum;
  UserProfilePage(this.url, this.name, this.email, this.professional,
      this.state, this.street, this.district, this.mobnum);

  Widget _buildProfileImage(double ht, double wt) {
    return Center(
      child: Container(
        width: wt / 2.8,
        height: wt / 2.8,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(url),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(80.0),
          border: Border.all(
            color: kPrimaryColor,
            width: 2.0,
          ),
        ),
      ),
    );
  }

  Widget _buildFullName(double wt) {
    TextStyle _nameTextStyle = TextStyle(
      fontFamily: 'Roboto',
      color: Colors.black,
      fontSize: wt / 12,
      fontWeight: FontWeight.w700,
    );

    return Text(
      name,
      style: _nameTextStyle,
    );
  }

  Widget _buildStatus(BuildContext context, double wt) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Text(
        professional,
        style: TextStyle(
          fontFamily: 'Spectral',
          color: Colors.black,
          fontSize: wt / 19,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }

  Widget leftWidget(TextStyle _style, String txt) {
    return Text(
      txt,
      textAlign: TextAlign.center,
      style: _style,
    );
  }

  Widget _buildBio(BuildContext context) {
    TextStyle bioTextStyle = TextStyle(
      fontFamily: 'Spectral',
      fontWeight: FontWeight.w400, //try changing weight to w500 if not thin
      fontStyle: FontStyle.italic,
      color: Color(0xFF799497),
      fontSize: 18.0,
    );

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: EdgeInsets.all(8.0),
      child: Text(
        email,
        textAlign: TextAlign.center,
        style: bioTextStyle,
      ),
    );
  }

  Widget _buildSeparator(Size screenSize) {
    return Container(
      width: screenSize.width / 1.4,
      height: 2.0,
      color: Colors.black54,
      margin: EdgeInsets.only(top: 4.0),
    );
  }

  Widget _buildDetails(BuildContext context, double ht, double wt) {
    TextStyle detailsTextStyle = TextStyle(
      fontFamily: 'Spectral',
      fontWeight: FontWeight.w500, //try changing weight to w500 if not thin
      fontStyle: FontStyle.italic,
      color: Colors.orange,
      fontSize: wt / 20,
    );

    TextStyle detailsLeftTextStyle = TextStyle(
      fontFamily: 'Spectral',
      fontWeight: FontWeight.bold, //try changing weight to w500 if not thin
      fontStyle: FontStyle.italic,
      color: Colors.black,
      letterSpacing: 1,
      fontSize: wt / 20,
    );
    var i = street.length;
    var l;
    if (i > 18) {
      l = ht / 28;
    } else {
      l = ht / 90;
    }
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: EdgeInsets.only(left: ht / 28, top: ht / 70),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              leftWidget(detailsLeftTextStyle, 'Street'),
              SizedBox(height: l),
              leftWidget(detailsLeftTextStyle, 'District'),
              SizedBox(height: ht / 90),
              leftWidget(detailsLeftTextStyle, 'State'),
              SizedBox(height: ht / 90),
              leftWidget(detailsLeftTextStyle, 'Mobile Number')
            ],
          ),
          SizedBox(width: wt / 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  street,
                  textAlign: TextAlign.start,
                  style: detailsTextStyle,
                ),
                SizedBox(height: ht / 90),
                leftWidget(detailsTextStyle, district),
                SizedBox(height: ht / 90),
                leftWidget(detailsTextStyle, state),
                SizedBox(height: ht / 90),
                leftWidget(detailsTextStyle, mobnum),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double ht = screenSize.height;
    double wt = screenSize.width;
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
          title: Text('Profile'),
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, false),
          ),
        ),
        body: Stack(
          children: <Widget>[
            SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: screenSize.height / 35),
                    _buildProfileImage(screenSize.height, screenSize.width),
                    SizedBox(height: ht / 60),
                    _buildFullName(screenSize.width),
                    _buildStatus(context, screenSize.width),
                    SizedBox(height: ht / 180),
                    _buildBio(context),
                    SizedBox(height: ht / 150),
                    _buildSeparator(screenSize),
                    SizedBox(height: wt / 20),
                    _buildDetails(context, ht, screenSize.width),
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
