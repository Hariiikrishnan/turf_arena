import 'package:turf_arena/constants.dart';
import 'package:turf_arena/screens/LoginScreen.dart';
import 'package:turf_arena/screens/OtpScreen.dart';
import 'package:turf_arena/screens/app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Registerscreen extends StatefulWidget {
  const Registerscreen({super.key});

  @override
  State<Registerscreen> createState() => _RegisterscreenState();
}

class _RegisterscreenState extends State<Registerscreen> {
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  bool loadGoogleSign = false;
  late String username;
  late String password;

  List<String> scopes = <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ];

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

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    // Optional clientId
    // clientId: 'your-client_id.apps.googleusercontent.com',
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  var acs = ActionCodeSettings(
      // URL you want to redirect back to. The domain (www.example.com) for this
      // URL must be whitelisted in the Firebase Console.
      // dynamicLinkDomain: "example.com.link",
      url: 'https://www.example.com/finishSignUp?cartId=1234',
      // This must be true
      handleCodeInApp: true,
      iOSBundleId: 'com.example.ios',
      androidPackageName: 'com.example.turf_arena',
      // installIfNotAvailable
      androidInstallApp: true,
      // minimumVersion
      androidMinimumVersion: '12');

  Future<User?> registerWithEmail(String email, String password) async {
    try {
      _auth.sendSignInLinkToEmail(email: email, actionCodeSettings: acs);
      // UserCredential userCredential =
      //     await _auth.createUserWithEmailAndPassword(
      //   email: email,
      //   password: password,
      // );
      // return userCredential.user;
    } catch (e) {
      print('Error in Email/Password Registration: $e');
      return null;
    }
  }

  Future<void> addUserToFirestore(User user) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (!userDoc.exists) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'email': user.email,
          'displayName': user.displayName ?? '',
          'photoURL': user.photoURL ?? '',
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print('Error adding user to Firestore: $e');
    }
  }

  void registerAndAddToFirestore(String email, String password) async {
    // if (_formKey.currentState!.validate()) {
    // String email = _emailController.text.trim();
    // String password = _passwordController.text.trim();

    User? user = await registerWithEmail(email, password);
    if (user != null) {
      await addUserToFirestore(user);
      print('User registered and added to Firestore');
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return App({
          'u_id': user.uid,
          'username': user.displayName,
          'email': user.email,
        });
      }));
    }
  }

  // void signInAndCreateUser(String email, String password) async {
  //   User? user = await signInWithEmail(email, password);
  //   if (user != null) {
  //     await addUserToFirestore(user);
  //   }
  // }

  Future<void> addGoogleUserToFirestore(User user) async {
    try {
      // Check if user already exists in Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!userDoc.exists) {
        // If the user doesn't exist, add them to Firestore
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'email': user.email,
          'displayName': user.displayName,
          'photoURL': user.photoURL,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print('Error adding Google user: $e');
    }
  }

  void signInWithGoogleAndAddToFirestore() async {
    User? user = await signInWithGoogle();
    if (user != null) {
      await addUserToFirestore(user);
      print('User signed in with Google and added to Firestore');
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return App({
          'u_id': user.uid,
          'username': user.displayName,
          'email': user.email,
        });
      }));
    }
  }

  // Future<dynamic> signInWithGoogle() async {
  //   try {
  //     setState(() {
  //       loadGoogleSign = true;
  //     });
  //     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  //     final GoogleSignInAuthentication? googleAuth =
  //         await googleUser?.authentication;

  //     final credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth?.accessToken,
  //       idToken: googleAuth?.idToken,
  //     );

  //     final UserCredential userCredential =
  //         await FirebaseAuth.instance.signInWithCredential(credential);

  //     // Get the Firebase User object from the UserCredential
  //     final User? user = userCredential.user;

  //     if (user != null) {
  //       // Access and print the user's display name (username) and email
  //       print('Username: ${user.displayName}');
  //       print('Email: ${user.email}');
  //       setState(() {
  //         loadGoogleSign = false;
  //       });
  //     }

  //     return user;
  //   } on Exception catch (e) {
  //     // TODO
  //     print('exception->$e');
  //   }
  // }

  void verifyPhoneNumber() {
    _auth.verifyPhoneNumber(
        phoneNumber: "+91 9384926154",
        timeout: Duration(seconds: 60),
        verificationCompleted: (phoneCredential) {
          print(phoneCredential);
        },
        verificationFailed: (error) {
          print(error.toString());
        },
        codeSent: (verificationId, forceResending) {
          print(verificationId);
          Navigator.of(context).push(_createRoute(
            Otpscreen(
              verificationId: verificationId,
            ),
          ));
        },
        codeAutoRetrievalTimeout: (verificationId) {
          print("Auto Retrieval Timeout");
        });
  }

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  String? _verificationId;

  void _sendOtp() async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneController.text,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Auto sign-in if verification is successful
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        print("Verification Failed: ${e.message}");
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
        });
        print("Code sent to phone number.");
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          _verificationId = verificationId;
        });
        print("Auto retrieval timeout.");
      },
    );
    setState(() {
      showSpinner = false;
    });
  }

  void _verifyOtp() async {
    String otp = otpController.text.trim();

    // Create PhoneAuthCredential with OTP
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: _verificationId!,
      smsCode: otp,
    );

    // Sign in the user
    try {
      await _auth.signInWithCredential(credential);
      print("Phone number verified and user signed in.");
    } catch (e) {
      print("Failed to sign in: ${e.toString()}");
    }
  }

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        return null; // User canceled the sign-in
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        // Access and print the user's display name (username) and email
        print('Username: ${user.displayName}');
        print('Email: ${user.email}');
        setState(() {
          loadGoogleSign = false;
        });
      }
      return user;
    } catch (e) {
      print('Error during Google Sign-In: $e');
      return null;
    }
  }

  bool _isEmailSent = false;

  // Method to send the email verification link
  Future<void> sendEmailVerificationLink(String email) async {
    // final String email = _emailController.text;

    // Configure ActionCodeSettings for web-based email verification
    ActionCodeSettings actionCodeSettings = ActionCodeSettings(
      url: 'https://dhanush-turf-262de.firebaseapp.com/finishSignUp',
      handleCodeInApp: true,
    );

    try {
      await _auth.sendSignInLinkToEmail(
        email: email,
        actionCodeSettings: actionCodeSettings,
      );
      setState(() {
        _isEmailSent = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Verification link sent to $email')),
      );
    } catch (e) {
      print("Failed to send verification link: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send verification link')),
      );
    }
  }

  // Method to set a password and complete sign-up
  Future<void> setPasswordAndSignUp(String email, String password) async {
    // final String email = _emailController.text;
    // final String password = _passwordController.text;

    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign-up complete!')),
      );
      Navigator.pop(
          context); // Navigate away from this screen or to home screen
    } catch (e) {
      print("Error signing up with email and password: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing up')),
      );
    }
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
                    color: primaryColor,
                    width: double.infinity,
                    height: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Register",
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
                                  setState(() {
                                    username = value;
                                  });
                                },
                                controller: phoneController,
                                // textInputAction: TextInputAction.search,
                                decoration: kLoginFieldDecoration.copyWith(
                                  hintText: 'Phone No.',
                                ),
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              TextField(
                                obscureText: true,
                                onChanged: (value) {
                                  setState(() {
                                    password = value;
                                  });
                                },
                                controller: otpController,
                                // textInputAction: TextInputAction.,
                                decoration: kLoginFieldDecoration.copyWith(
                                  hintText: 'Password',
                                ),
                              ),
                              SizedBox(
                                height: 30.0,
                              ),
                              TextButton(
                                onPressed: () async {
                                  print(username);
                                  print(password);

                                  setState(() {
                                    showSpinner = true;
                                  });
                                  _verificationId == null
                                      ? _sendOtp()
                                      : _verifyOtp();

                                  // verifyPhoneNumber();
                                  // sendEmailVerificationLink(username);
                                  // registerAndAddToFirestore(username, password);
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
                                    ? CircularProgressIndicator()
                                    : Text(
                                        "Register",
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
                                    signInWithGoogleAndAddToFirestore();
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
                                    : Text(
                                        "Sign in With Google",
                                        style: TextStyle(
                                          color: whiteColor,
                                          fontSize: 18.0,
                                        ),
                                      ),
                              ),
                              SizedBox(
                                height: 30.0,
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return LoginScreen();
                                  }));
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
                                  "Already have an Account?",
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
    double triangleHeight =
        size.height * 0.2; // Adjust this to control the height of the triangle

    // Start at top-left corner
    path.moveTo(0, triangleHeight);
    // Draw line to the top-center (forming the tip of the triangle)
    path.lineTo(size.width / 2, 0);
    // Draw line to the top-right corner
    path.lineTo(size.width, triangleHeight);
    // Continue drawing down the rectangle sides
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
