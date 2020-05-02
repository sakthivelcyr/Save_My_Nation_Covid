import 'package:covid_ui_check/constant.dart';
import 'package:covid_ui_check/widgets/my_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Concerns extends StatefulWidget {
  @override
  _ConcernsState createState() => _ConcernsState();
}

class _ConcernsState extends State<Concerns> {
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

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    double ht = queryData.size.height;
    double wt = queryData.size.width;
    return Scaffold(
      body: SingleChildScrollView(
        controller: controller,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            MyHeader(
              image: "assets/icons/coronadr.svg",
              textTop: "Get to know",
              textBottom: "all Concerns",
              offset: offset,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 20),
                  Text("Concerns", style: kTitleTextstyle),
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
                  SizedBox(height: 50),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PreventCCard extends StatelessWidget {
  final String image;
  final String title;
  final String address;
  final String subtitle;
  final String distance;
  final double ht;
  final double wt;
  const PreventCCard(
      {Key key,
      this.image,
      this.subtitle,
      this.distance,
      this.title,
      this.address,
      this.ht,
      this.wt})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        height: wt/3.5,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: <Widget>[
            Container(
              height: wt/3.5,
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
            Padding(
              padding: const EdgeInsets.only(left:12.0),
              child: Container(height: wt/5, width: wt/5, child: Image.asset(image)),
            ),
            Positioned(
              left: wt/4,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                height: 136,
                width: MediaQuery.of(context).size.width - 170,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      title,
                      style: kTitleTextstyle.copyWith(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: kTitleTextstyle.copyWith(
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      address,
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(height: 3),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Icon(
                          Icons.location_on,
                          size: 18,
                        ),
                        SizedBox(width: 10),
                        Text(
                          distance,
                          style: kTitleTextstyle.copyWith(
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(width: wt/4),
                        Align(
                          alignment: Alignment.topRight,
                          child: SvgPicture.asset("assets/icons/forward.svg",width: wt/50,),
                        ),
                      ],
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
