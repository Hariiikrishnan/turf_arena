import 'package:turf_arena/constants.dart';
import 'package:turf_arena/screens/RegisterScreen.dart';
import 'package:turf_arena/screens/app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  bool loadGoogleSign = false;
  bool isLoaded = false;
  late String username;
  late String password;
  late Map userDetails;

  List<String> scopes = <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ];

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    // Optional clientId
    // clientId: 'your-client_id.apps.googleusercontent.com',
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  Future<dynamic> signInWithGoogle() async {
    try {
      setState(() {
        loadGoogleSign = true;
      });
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // Get the Firebase User object from the UserCredential
      final User? user = userCredential.user;

      if (user != null) {
        // Access and print the user's display name (username) and email
        print('Username: ${user.displayName}');
        print('Email: ${user.email}');
        setState(() {
          loadGoogleSign = false;
          isLoaded = true;
        });
        await fetchUser(user);

        Navigator.of(context).push(
          _createRoute(
            App(userDetails),
          ),
        );
      }

      return user;
    } on Exception catch (e) {
      // TODO
      print('exception->$e');
    }
  }

  Future<void> fetchUser(User user) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    Query query = users.where('uid', isEqualTo: user.uid);

    try {
      QuerySnapshot snapshot = await query.get();

      setState(() {
        // loadingData = false;
        // _isLoading = false;
        snapshot.docs.forEach((doc) {
          print(doc.data());
          setState(() {
            userDetails = doc.data() as Map<String, dynamic>;
          });
          // turfList.add(doc.data() as Map<String, dynamic>);
        });
      });
    } catch (error) {
      print("Error getting documents: $error");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoaded = false;
    loadGoogleSign = false;
    showSpinner = false;
  }

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
      resizeToAvoidBottomInset: false,
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
              flex: 4,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(),
              ),
            ),
            Expanded(
              flex: 7,
              child: Center(
                child: ClipPath(
                  clipper: TriangleClipper(),
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      color: primaryColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Login",
                            style: TextStyle(
                              color: whiteColor,
                              fontSize: 30.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(
                            height: 30.0,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              TextField(
                                onChanged: (value) {
                                  username = value;
                                },
                                textInputAction: TextInputAction.search,
                                decoration: kLoginFieldDecoration.copyWith(
                                  hintText: 'Username',
                                ),
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              TextField(
                                obscureText: true,
                                onChanged: (value) {
                                  password = value;
                                },
                                // textInputAction: TextInputAction.search,
                                decoration: kLoginFieldDecoration.copyWith(
                                  hintText: 'Password',
                                ),
                              ),
                              SizedBox(
                                height: 30.0,
                              ),
                              TextButton(
                                onPressed: () async {
                                  setState(() {
                                    showSpinner = true;
                                  });
                                  try {
                                    final loggedInUser =
                                        await _auth.signInWithEmailAndPassword(
                                            email: username,
                                            password: password);

                                    if (loggedInUser != null) {
                                      print("Logged");
                                      Navigator.of(context).push(
                                        _createRoute(
                                          App({
                                            'userid': loggedInUser.user?.uid,
                                            'username':
                                                loggedInUser.user?.displayName,
                                            'email': loggedInUser.user?.email,
                                          }),
                                        ),
                                      );
                                    }
                                    setState(() {
                                      showSpinner = false;
                                    });
                                  } catch (e) {
                                    print(e);
                                  }
                                },
                                style: TextButton.styleFrom(
                                    fixedSize: Size(100.0, 55.0),
                                    // padding:
                                    // EdgeInsets.symmetric(vertical: 10.0),
                                    backgroundColor: secondaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    )
                                    // fixedSize: Size(double.infinity, 50.0),
                                    ),
                                child: showSpinner
                                    ? CircularProgressIndicator(
                                        // value: 0.5,
                                        color: whiteColor,
                                      )
                                    : Text(
                                        "Login",
                                        style: TextStyle(
                                          color: whiteColor,
                                          fontSize: 20.0,
                                        ),
                                      ),
                              ),
                              SizedBox(
                                height: 30.0,
                              ),
                              TextButton(
                                onPressed: () async {
                                  setState(() {
                                    showSpinner = true;
                                  });
                                  try {
                                    signInWithGoogle();
                                    setState(() {
                                      showSpinner = false;
                                    });
                                  } catch (e) {
                                    print(e);
                                  }
                                },
                                style: TextButton.styleFrom(
                                    fixedSize: Size(100.0, 55.0),
                                    // padding:
                                    // EdgeInsets.symmetric(vertical: 10.0),
                                    backgroundColor: secondaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    )
                                    // fixedSize: Size(double.infinity, 50.0),
                                    ),
                                child: loadGoogleSign
                                    ? CircularProgressIndicator(
                                        color: whiteColor,
                                      )
                                    : isLoaded
                                        ? Text(
                                            "Logging In..",
                                            style: TextStyle(
                                              color: whiteColor,
                                              fontSize: 18.0,
                                            ),
                                          )
                                        : Text(
                                            "Sign in With Google",
                                            style: TextStyle(
                                              color: whiteColor,
                                              fontSize: 18.0,
                                            ),
                                          ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    _createRoute(
                                      Registerscreen(),
                                    ),
                                  );
                                },
                                style: TextButton.styleFrom(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 10.0),
                                    // backgroundColor: secondaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    )
                                    // fixedSize: Size(double.infinity, 50.0),
                                    ),
                                child: Text(
                                  "Don't have an Account?",
                                  style: TextStyle(
                                    color: whiteColor,
                                    fontSize: 18.0,
                                  ),
                                ),
                              ),
                            ],
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

// Define the TriangleClipper for the top triangle
class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    double triangleHeight = size.height * 0.2; // Height of the triangle
    double radius = 15.0; // Radius to round the tip of the triangle

    // Start at top-left corner
    path.moveTo(0, triangleHeight);

    // Draw line towards the top-center but add a smooth curve using quadraticBezierTo
    path.quadraticBezierTo(
      size.width / 2, radius, // Control point (smooth curve towards the tip)
      size.width / 2, radius, // Tip of the triangle
    );
// path.arcToPoint(
    // Offset(size.width / 2 + curveRadius, triangleHeight),
    // radius: Radius.circular(curveRadius),
    // clockwise: false, // This ensures the arc is convex (rounded outward)
    // );
    // Draw line to the top-right corner with a curve
    path.quadraticBezierTo(
      size.width / 2,
      radius, // Control point for the smooth curve on the right side
      size.width, triangleHeight, // Top-right corner
    );

    // Draw the rest of the rectangle
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    // Close the path
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
