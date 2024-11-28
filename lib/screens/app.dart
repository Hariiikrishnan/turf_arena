import 'dart:async';

import 'package:turf_arena/screens/MyBookings.dart';
import 'package:turf_arena/screens/TurfsList.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:turf_arena/constants.dart';
import 'package:turf_arena/screens/HomeScreen.dart';
import 'package:turf_arena/screens/Profilescreen.dart';

class App extends StatefulWidget {
  App(this.userDetails);
  Map userDetails;

  @override
  State<App> createState() => _AppState();
}

var currentPageIndex = 0;

class _AppState extends State<App> {
  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();
    // _initUniLinks();
    print(widget.userDetails);
  }

  // Future<void> _initUniLinks() async {
  //   // Listen for incoming links
  //   _sub = uriLinkStream.listen((Uri? uri) {
  //     if (uri != null) {
  //       _handleIncomingLink(uri);
  //     }
  //   }, onError: (Object err) {
  //     // Handle exception by warning the user their action did not succeed
  //     print('Error: $err');
  //   });

  //   // Handle app being opened with a link initially
  //   final initialUri = await getInitialUri();
  //   if (initialUri != null) {
  //     _handleIncomingLink(initialUri);
  //   }
  // }

  // void _handleIncomingLink(Uri uri) {
  //   // Handle the deep link
  //   print('Received link: ${uri.toString()}');
  //   Navigator.push(context, MaterialPageRoute(builder: (context) {
  //     return AcceptInviteScreen(uri.toString());
  //   }));
  //   // Navigate to a specific page or perform any action based on the link
  // }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // extendBody: true,
        backgroundColor: secondaryColor,
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: Stack(
          alignment: Alignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 35.0,
                vertical: 20.0,
              ),
              child: ClipRRect(
                // alignment: AlignmentDirectional.topStart,
                borderRadius: BorderRadius.circular(50.0),
                child: NavigationBar(
                  onDestinationSelected: (int index) {
                    setState(() {
                      currentPageIndex = index;
                      print(index);
                    });
                  },
                  labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
                  // indicatorShape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.circular(62.0)),

                  backgroundColor: primaryColor,
                  indicatorColor: primaryColor,
                  height: 70.0,
                  selectedIndex: currentPageIndex,
                  destinations: [
                    NavigationDestination(
                      selectedIcon: Icon(
                        Icons.home,
                        size: 32.0,
                        color: Colors.white,
                      ),
                      icon: Icon(
                        size: 32.0,
                        Icons.home_outlined,
                        color: Colors.grey,
                      ),
                      label: '',
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        right: 40.0,
                      ),
                      child: NavigationDestination(
                        selectedIcon: Icon(
                          Icons.confirmation_number_rounded,
                          size: 32.0,
                          color: Colors.white,
                        ),
                        icon: Icon(
                          size: 32.0,
                          Icons.confirmation_number_outlined,
                          color: Colors.grey,
                        ),
                        label: '',
                      ),
                    ),
                    // Spacer(
                    //   flex: 1,
                    // ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 40.0,
                      ),
                      child: NavigationDestination(
                        selectedIcon: Icon(
                          Icons.favorite_rounded,
                          size: 36.0,
                          color: Colors.white,
                          // Icons.notifications,
                        ),
                        icon: Icon(
                          Icons.favorite_outline_outlined,
                          size: 36.0,
                          // Icons.notifications_outlined,
                          color: Colors.grey,
                        ),
                        label: '',
                      ),
                    ),
                    NavigationDestination(
                      selectedIcon: Icon(
                        Icons.account_circle,
                        size: 36.0,
                        color: Colors.white,
                        // Icons.notifications,
                      ),
                      icon: Icon(
                        Icons.account_circle_outlined,
                        size: 36.0,
                        // Icons.notifications_outlined,
                        color: Colors.grey,
                      ),
                      label: '',
                    ),
                  ],
                ),
              ),
            ),
            Transform.translate(
              offset: Offset(0, -40),
              child: Transform.scale(
                scale: 1.5,
                child: Container(
                  // transform: Matrix4.translation(1),

                  decoration: BoxDecoration(
                    // border: BoxBorder.lerp(a, b, t),
                    border: Border.all(
                      color: Colors.white,
                      width: 3.5,
                    ),
                    image: DecorationImage(
                      fit: BoxFit.fitWidth,
                      image: AssetImage(
                        "images/cock.jpg",
                      ),
                    ),
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(100.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: secondaryColor.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 7,
                        offset: Offset(0, 2), // changes position of shadow
                      ),
                    ],
                  ),

                  height: 60.0,
                  width: 60.0,
                ),
              ),
            ),
          ],
        ),
        body: [
          // Center(
          //   child: Container(
          //     child: Text("1"),
          //   ),
          // ),
          HomeScreen(widget.userDetails),
          MyBookings(widget.userDetails),
          TurfsList("Saved List", widget.userDetails),
          Profilescreen(widget.userDetails)
        ][currentPageIndex]);
  }
}

// class _HomeScreenState extends State<HomeScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.end,
//         // margin: EdgeInsets.symmetric(
//         //   vertical: 50.0,
//         // ),
//         children: [
//           BottomNavigationBar(
//             backgroundColor: Colors.transparent,
//             showUnselectedLabels: true,
//             type: BottomNavigationBarType.fixed,
//             elevation: 0,
//             items: [
//               BottomNavigationBarItem(
//                 backgroundColor: Colors.red,
//                 icon: Icon(Icons.home),
//                 label: '',
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.local_activity),
//                 label: '',
//               ),
//               BottomNavigationBarItem(
//                 icon: Container(
//                   decoration: BoxDecoration(
//                     color: Colors.black,
//                   ),
//                   height: 100.0,
//                   width: 50.0,
//                   child: ModelViewer(
//                     disableTap: false,
//                     // backgroundColor: Color.fromARGB(0xFF, 0xEE, 0xEE, 0xEE),
//                     src: 'assets/football.glb',
//                     alt: 'A 3D model of an astronaut',
//                     ar: false,
//                     autoRotate: false,

//                     // iosSrc: 'https://modelviewer.dev/shared-assets/models/Astronaut.usdz',
//                     disableZoom: true,
//                   ),
//                 ),
//                 label: '',
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.inbox),
//                 label: '',
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.person),
//                 label: '',
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// Container(
//               height: 170.0,
//               color: Colors.red,
//               child: Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: Container(
//                   decoration: BoxDecoration(
//                       color: Colors.black,
//                       borderRadius: BorderRadius.circular(80.0)),
//                   height: 100.0,
//                   width: 100.0,
//                   child: ModelViewer(
//                     disableTap: true,
//                     // backgroundColor: Color.fromARGB(0xFF, 0xEE, 0xEE, 0xEE),
//                     src: 'assets/football.glb',
//                     alt: 'A 3D model of an astronaut',
//                     ar: false,
//                     autoRotate: false,
//                     autoPlay: false,
//                     disablePan: true,

//                     // iosSrc: 'https://modelviewer.dev/shared-assets/models/Astronaut.usdz',
//                     disableZoom: true,
//                   ),
//                 ),
//               ),
//             ),
