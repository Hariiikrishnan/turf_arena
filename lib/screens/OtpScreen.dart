import 'package:turf_arena/constants.dart';
import 'package:turf_arena/screens/app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Otpscreen extends StatefulWidget {
  const Otpscreen({required this.verificationId});
  final String verificationId;
  @override
  State<Otpscreen> createState() => _OtpscreenState();
}

class _OtpscreenState extends State<Otpscreen> {
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  bool loadGoogleSign = false;
  late String username;
  late String password;

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

  Future<User?> registerWithEmail(String email, String password) async {
    try {
      // _auth.sendSignInLinkToEmail(email: email, actionCodeSettings: acs);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Container(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 50.0,
                  left: 20.0,
                  right: 20.0,
                ),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image(
                        image: AssetImage("images/logo.png"),
                      ),
                      Text(
                        "Verification",
                        style: TextStyle(
                          color: whiteColor,
                          fontSize: 30.0,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: secondaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50.0),
                    topRight: Radius.circular(50.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 50.0,
                    bottom: 20.0,
                    left: 20.0,
                    right: 20.0,
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                decoration: kOtpDecoration,
                              ),
                            ),
                            SizedBox(
                              width: 20.0,
                            ),
                            Expanded(
                              child: TextField(
                                decoration: kOtpDecoration,
                              ),
                            ),
                            SizedBox(
                              width: 20.0,
                            ),
                            Expanded(
                              child: TextField(
                                decoration: kOtpDecoration,
                              ),
                            ),
                            SizedBox(
                              width: 20.0,
                            ),
                            Expanded(
                              child: TextField(
                                decoration: kOtpDecoration,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 30.0,
                        ),
                        child: TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                              // padding: Ede
                              ),
                          child: Text(
                            "Resend the code?",
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          try {
                            final cred = PhoneAuthProvider.credential(
                                verificationId: widget.verificationId,
                                smsCode: "123456");

                            print(cred);
                          } catch (error) {}
                        },
                        style: TextButton.styleFrom(
                            backgroundColor: primaryColor,
                            fixedSize: Size(
                              150.0,
                              30.0,
                            ),
                            side: BorderSide(
                              width: 1.0,
                              color: whiteColor,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            )),
                        icon: Icon(
                          Icons.arrow_forward,
                          color: whiteColor,
                        ),
                        iconAlignment: IconAlignment.end,
                        label: Text(
                          "Submit",
                          style: TextStyle(
                            color: whiteColor,
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    ],
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
