import 'package:turf_arena/constants.dart';
import 'package:turf_arena/screens/EditProfile.dart';
import 'package:turf_arena/screens/LoginScreen.dart';
import 'package:turf_arena/screens/MyBookings.dart';
import 'package:turf_arena/screens/OtpScreen.dart';
import 'package:turf_arena/screens/SetProfile.dart';
import 'package:turf_arena/screens/VerifyPhone.dart';
import 'package:turf_arena/screens/booking_success.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Profilescreen extends StatefulWidget {
  Profilescreen(this.details);
  Map details;
  @override
  State<Profilescreen> createState() => _ProfilescreenState();
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

class _ProfilescreenState extends State<Profilescreen> {
  Future<bool> signOutFromGoogle() async {
    try {
      await FirebaseAuth.instance.signOut();
      return true;
    } on Exception catch (_) {
      return false;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // print(widget.details);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: primaryColor,
        ),
        child: Column(
          children: [
            Expanded(
                child: Container(
              decoration: BoxDecoration(
                color: primaryColor,
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 40.0,
                  left: 40.0,
                  right: 40.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image(image: AssetImage("images/logo.png")),
                        IconButton(
                          onPressed: () {
                            signOutFromGoogle();

                            Navigator.of(context).push(
                              _createRoute(
                                LoginScreen(),
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.logout,
                            color: whiteColor,
                            size: 30.0,
                          ),
                        ),
                      ],
                    ),
                    CircleAvatar(
                      radius: 74.0,
                      backgroundColor: whiteColor,
                      child: CircleAvatar(
                        radius: 70.0,
                        backgroundImage:
                            NetworkImage(widget.details['photoURL']),
                      ),
                    ),
                    Row(
                      children: [
                        TextButton.icon(
                          style: TextButton.styleFrom(
                              backgroundColor: whiteColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  8.0,
                                ),
                              )),
                          onPressed: () {
                            Navigator.of(context).push(
                              _createRoute(
                                VerifyPhone(widget.details),
                              ),
                            );
                          },
                          icon: Icon(Icons.edit),
                          iconAlignment: IconAlignment.end,
                          label: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Text("Edit Profile"),
                          ),
                        ),
                        Spacer(),
                        TextButton.icon(
                          style: TextButton.styleFrom(
                              backgroundColor: whiteColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  8.0,
                                ),
                              )),
                          onPressed: () {},
                          icon: Icon(Icons.share),
                          iconAlignment: IconAlignment.end,
                          label: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Text("Share Profile"),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50.0),
                      topRight: Radius.circular(50.0),
                    )),
                child: Column(
                  children: [
                    Container(
                      height: 60.0,
                      decoration: BoxDecoration(
                          color: greyColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50.0),
                            topRight: Radius.circular(50.0),
                          )),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            // "hello",
                            "Hello, " +
                                (widget.details['displayName'] ??
                                    widget.details['email'] ??
                                    ""),
                            style: TextStyle(
                              color: secondaryColor,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          // Text("Saved"),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 50.0,
                          horizontal: 40.0,
                        ),
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton(
                                  style: TextButton.styleFrom(
                                      backgroundColor: whiteColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      )),
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      _createRoute(
                                        // Editprofile(widget.details),
                                        SetProfile(widget.details),
                                      ),
                                    );
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Edit Profile",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20.0,
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_right_rounded,
                                        size: 40.0,
                                        color: Colors.black,
                                      )
                                    ],
                                  )),
                              TextButton(
                                  style: TextButton.styleFrom(
                                      backgroundColor: whiteColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      )),
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      _createRoute(
                                        BookingSuccess(),
                                      ),
                                    );
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "My Bookings",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20.0,
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_right_rounded,
                                        size: 40.0,
                                        color: Colors.black,
                                      )
                                    ],
                                  )),
                              TextButton(
                                  style: TextButton.styleFrom(
                                      backgroundColor: whiteColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      )),
                                  onPressed: () {
                                    signOutFromGoogle();

                                    Navigator.of(context).push(
                                      _createRoute(
                                        LoginScreen(),
                                      ),
                                    );
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Logout",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20.0,
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_right_rounded,
                                        size: 40.0,
                                        color: Colors.black,
                                      )
                                    ],
                                  )),
                            ],
                          ),
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
