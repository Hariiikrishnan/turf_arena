import 'package:turf_arena/screens/BookingScreen.dart';
import 'package:turf_arena/screens/IndividualTurf.dart';
import 'package:turf_arena/screens/TurfsList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:turf_arena/constants.dart';
import 'components/ProfileHeader.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen(this.userDetails);
  Map userDetails;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

Route _createRoute(Widget ScreenName) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => ScreenName,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Dhanush Turf"),
      // ),

      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: primaryColor,
        ),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 35.0,
                  right: 35.0,
                  top: 35.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ProfileHeader(widget.userDetails),
                    Padding(
                      padding: const EdgeInsets.only(
                          // left: 35.0,
                          // right: 35.0,
                          // top: 55.0,
                          ),
                      child: Container(
                        child: TextField(
                          style: TextStyle(
                            color: whiteColor,
                          ),
                          onSubmitted: (value) {
                            Navigator.of(context).push(
                              _createRoute(
                                TurfsList(value, widget.userDetails),
                              ),
                            );
                          },
                          textInputAction: TextInputAction.search,
                          decoration: kTextFieldDecoration,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          // backgroundBlendMode: BlendMode.screen,
                          border: Border.all(
                            width: 1.0,
                            color: whiteColor,
                          ),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            opacity: 0.6,
                            image: AssetImage(
                              "images/grass_bg.jpg",
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                  decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50.0),
                      topRight: Radius.circular(50.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 40.0,
                      horizontal: 30.0,
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SportsTile(
                              src: "images/turf_img.jpg",
                              title: "Turf",
                              userDetails: widget.userDetails,
                            ),
                            SizedBox(
                              width: 20.0,
                            ),
                            SportsTile(
                              src: "images/football.png",
                              title: "Football",
                              userDetails: widget.userDetails,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        Row(
                          children: [
                            SportsTile(
                              src: "images/badminton_court.jpg",
                              title: "Badminton",
                              userDetails: widget.userDetails,
                            ),
                            SizedBox(
                              width: 20.0,
                            ),
                            SportsTile(
                              src: "images/tennis_court.jpg",
                              title: "Tennis",
                              userDetails: widget.userDetails,
                            ),
                          ],
                        ),
                      ],
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

class SportsTile extends StatelessWidget {
  SportsTile(
      {required this.src, required this.title, required this.userDetails});

  String src;
  String title;
  Map userDetails;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        // width: MediaQuery.of(context).size.width / 2.5,
        height: MediaQuery.of(context).size.height / 4.2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.0),
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage(src),
          ),
          color: whiteColor,
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: double.infinity,
                  height: 40.0,
                  child: TextButton.icon(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      backgroundColor: whiteColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(16.0),
                          bottomRight: Radius.circular(16.0),
                        ),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        _createRoute(
                          TurfsList(
                            title,
                            userDetails,
                          ),
                        ),
                      );
                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (context) {
                      //   return Individualturf();
                      // }));
                    },
                    icon: Icon(
                      Icons.arrow_circle_right_outlined,
                      color: primaryColor,
                    ),
                    iconAlignment: IconAlignment.end,
                    label: Text(
                      title,
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
