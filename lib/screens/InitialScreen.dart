import 'package:turf_arena/screens/LoginScreen.dart';
import 'package:turf_arena/screens/app.dart';
import 'package:flutter/material.dart';
import 'package:turf_arena/constants.dart';

class InitialScreen extends StatelessWidget {
  const InitialScreen({super.key});

  Route _createRoute(Widget ScreenName) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => ScreenName,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(""),
      // ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            alignment: Alignment.topCenter,
            fit: BoxFit.fitWidth,
            image: AssetImage("images/turf_bg1.png"),
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Container(
                // transform: Matrix4.identity()..scale(1.2),
                width: double.infinity,
                decoration: BoxDecoration(
                    // image: DecorationImage(
                    //   image: AssetImage("images/turf_bg1.png"),
                    // ),
                    ),
                // child: Image(image: AssetImage("images/turf_bg1.png")),
              ),
            ),
            Expanded(
              child: Center(
                child: ClipPath(
                  clipper: TopSCurveClipper(),
                  child: Container(
                    // decoration: new BoxDecoration(
                    //   borderRadius: BorderRadius.vertical(
                    //       bottom: Radius.elliptical(
                    //           MediaQuery.of(context).size.width, 100.0)),
                    // ),
                    color: primaryColor,
                    width: double.infinity,
                    height: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2,
                            height: MediaQuery.of(context).size.height / 14.0,
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Container(
                                    transform: Matrix4.identity()
                                      ..translate(0.0,
                                          0.0) // Move right by 50 and down by 100
                                      ..rotateZ(0.06),
                                    width:
                                        MediaQuery.of(context).size.width / 2.3,
                                    height: MediaQuery.of(context).size.height /
                                        20.0,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(6.0),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width / 2,
                                  height:
                                      MediaQuery.of(context).size.height / 20.0,
                                  decoration: BoxDecoration(
                                    color: secondaryColor,
                                    borderRadius: BorderRadius.circular(6.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15.0, vertical: 8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "BookMyTurf",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20.0,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 30.0,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 1.4,
                            child: Text(
                              'While grass courts are more traditional than other types of tennis courts,',
                              softWrap: true,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30.0,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                _createRoute(
                                  LoginScreen(),
                                ),
                              );
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width / 2,
                              height: MediaQuery.of(context).size.height / 16.0,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50.0),
                                image: DecorationImage(
                                    image: AssetImage("images/turf_bg.png"),
                                    fit: BoxFit.cover),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "Book Now",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                  CircleAvatar(
                                    backgroundColor: Colors.white,
                                    // radius: 20.0,
                                    child: Icon(
                                      Icons.keyboard_double_arrow_right_rounded,
                                      // Icons.double_arrow_rounded,
                                      size: 28.0,
                                      // opticalSize: 20.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 80.0,
                          ),
                        ],
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

class TopSCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    // Start from top-left corner
    path.moveTo(0, 0);

    // First curve (S curve part)
    var firstControlPoint = Offset(size.width / 4, size.height / 6); //6
    var firstEndPoint = Offset(size.width / 2, size.height / 8); //8

    var secondControlPoint = Offset(size.width * 3 / 4, size.height / 12); //12
    var secondEndPoint = Offset(size.width, size.height / 6); //6

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    // Continue along the sides and bottom
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class CurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    int curveHeight = 40;
    Offset controlPoint = Offset(size.width / 2, size.height + curveHeight);
    Offset endPoint = Offset(size.width, size.height - curveHeight);

    Path path = Path()
      ..lineTo(0, size.height - curveHeight)
      ..quadraticBezierTo(
          controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy)
      ..lineTo(size.width, 0)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class SCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(10, size.height * 10.2);

    // First curve
    var firstControlPoint1 = Offset(size.width * 5.25, size.height * 10.05);
    var firstControlPoint2 = Offset(size.width * 8.75, size.height * 8.35);
    var firstEndPoint = Offset(size.width, size.height * 5.2);
    path.cubicTo(
      firstControlPoint1.dx,
      firstControlPoint1.dy,
      firstControlPoint2.dx,
      firstControlPoint2.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    // Second curve
    var secondControlPoint1 = Offset(size.width * 0.25, size.height * 8.65);
    var secondControlPoint2 = Offset(size.width * 5.25, size.height * 10.95);
    var secondEndPoint = Offset(0, size.height * 5.8);
    path.cubicTo(
      secondControlPoint1.dx,
      secondControlPoint1.dy,
      secondControlPoint2.dx,
      secondControlPoint2.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );

    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 2);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
