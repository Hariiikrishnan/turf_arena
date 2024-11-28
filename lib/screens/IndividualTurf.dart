import 'package:turf_arena/screens/BookingScreen.dart';
import 'package:turf_arena/screens/SuccessBook.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:turf_arena/constants.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Individualturf extends StatefulWidget {
  Individualturf(this.details, this.userDetails);
  Map details;
  Map userDetails;

  @override
  State<Individualturf> createState() => _IndividualturfState();
}

class _IndividualturfState extends State<Individualturf> {
  bool isLiked = false;

  Future<void> addLike(String userId, String turfId) async {
    // Get a reference to the Firestore collection
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('users');

    // Reference the specific document
    // DocumentReference docRef = collectionRef.doc(documentId);

    try {
      // Get documents that match the condition
      QuerySnapshot querySnapshot =
          await collectionRef.where('uid', isEqualTo: userId).get();

      // Iterate through the matching documents
      for (var doc in querySnapshot.docs) {
        // Update each document
        await doc.reference.update({
          'liked': FieldValue.arrayUnion([turfId]),
        });
        print("Updated document: ${doc.id}");
        setState(() {
          isLiked = true;
          widget.userDetails['liked'].add(turfId);
        });
      }
    } catch (e) {
      print("Error updating documents: $e");
    }
  }

  Future<void> removeLike(String userId, String turfId) async {
    // Get a reference to the Firestore collection
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('users');

    // Reference the specific document
    // DocumentReference docRef = collectionRef.doc(documentId);

    try {
      // Get documents that match the condition
      QuerySnapshot querySnapshot =
          await collectionRef.where('uid', isEqualTo: userId).get();

      // Iterate through the matching documents
      for (var doc in querySnapshot.docs) {
        // Update each document
        await doc.reference.update({
          'liked': FieldValue.arrayRemove([turfId]),
        });
        print("Updated document: ${doc.id}");
        setState(() {
          isLiked = false;
          widget.userDetails['liked'].remove(turfId);
        });
      }
    } catch (e) {
      print("Error updating documents: $e");
    }
  }

  void launchGoogleMap(double lat, double lng) async {
    final Uri _url = Uri.parse(
        'google.navigation:q=${widget.details['latitude'].toString()},${widget.details['longitude'].toString()}');
    // final Uri _url = Uri.parse('google.navigation:q=10.729448,79.020248');
    final Uri fallbackUrl = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=${widget.details['latitude'].toString()},${widget.details['longitude'].toString()}');
    // var url = 'google.navigation:q=${lat.toString()},${lng.toString()}';

    // 'https://www.google.com/maps/search/?api=1&query=${lat.toString()},${lng.toString()}';
    try {
      bool launched =
          await launchUrl(_url, mode: LaunchMode.externalNonBrowserApplication);
      if (!launched) {
        await launchUrl(fallbackUrl,
            mode: LaunchMode.externalNonBrowserApplication);
      }
    } catch (e) {
      await launchUrl(fallbackUrl,
          mode: LaunchMode.externalNonBrowserApplication);
    }
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

  void checkIsLiked() {
    List<dynamic> liked = widget.userDetails['liked'];
    print(liked);
    liked.forEach((value) {
      if (value == widget.details['t_id']) {
        setState(() {
          isLiked = true;
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkIsLiked();
    print(widget.userDetails);
    // print(widget.details['t_id']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //     alignment: Alignment.topCenter,
        //     fit: BoxFit.fitWidth,
        //     image: AssetImage("images/turf_bg1.png"),
        //   ),
        // ),
        height: double.infinity,
        child: Stack(
          children: [
            Stack(
              children: [
                Container(
                  // transform: Matrix4.identity()..scale(1.2),
                  width: double.infinity,
                  // height: MediaQuery.of(context).size.height / 1.5,
                  decoration: BoxDecoration(
                      // color: Colors.green,
                      // image: DecorationImage(
                      //   image: AssetImage("images/turf_bg1.png"),
                      // ),
                      ),
                  child: MyCarouselContainer(),
                  // child: Image(image: AssetImage("images/turf_bg1.png")),
                ),
                Positioned(
                  right: 35,
                  top: 250,
                  child: Container(
                    // backgroundColor: whiteColor,
                    decoration: BoxDecoration(
                      color: isLiked ? Colors.red : whiteColor,
                      borderRadius: BorderRadius.circular(50.0),
                      boxShadow: [
                        BoxShadow(
                          color: secondaryColor.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 7,
                          offset: Offset(0, 2), // changes position of shadow
                        ),
                      ],
                    ),
                    // radius: 25.0,
                    child: IconButton(
                      splashRadius: 35.0,
                      // color: Colors.red,
                      icon: Icon(
                        Icons.favorite_outline,
                        color: isLiked ? whiteColor : Colors.red,
                        size: 30.0,
                      ), // Favorite icon
                      onPressed: () {
                        // Handle favorite action here
                        isLiked
                            ? removeLike(
                                widget.userDetails['uid'],
                                widget.details['t_id'],
                              )
                            : addLike(
                                widget.userDetails['uid'],
                                widget.details['t_id'],
                              );
                      },
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60.0),
                    topRight: Radius.circular(60.0),
                  ),
                  color: secondaryColor,
                ),
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 1.6,
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 30.0,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 1.4,
                            decoration: BoxDecoration(
                              color: whiteColor,
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                                vertical: 15.0,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                  ),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  Expanded(
                                    child: Text(
                                      widget.details['address'],
                                      style: TextStyle(
                                        fontSize: 14.0,
                                      ),
                                      // overflow: TextOverflow.fade,
                                      textAlign: TextAlign.left,
                                      // softWrap: true,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  Icon(
                                    Icons.outbond_rounded,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // SizedBox(
                          //   height: ,
                          // ),
                          Container(
                            width: MediaQuery.of(context).size.width / 1.4,
                            decoration: BoxDecoration(
                              color: whiteColor,
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                                vertical: 15.0,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.newspaper_rounded,
                                  ),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  Expanded(
                                    child: Text(
                                      widget.details['desc'],
                                      style: TextStyle(
                                        fontSize: 14.0,
                                      ),
                                      // overflow: TextOverflow.fade,
                                      textAlign: TextAlign.left,
                                      // softWrap: true,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 1.4,
                            decoration: BoxDecoration(
                              color: whiteColor,
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                                vertical: 15.0,
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Timings",
                                        style: TextStyle(
                                          fontSize: 17.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Icon(Icons.alarm),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Mon-Fri ",
                                      ),
                                      Text(
                                        widget.details['startTime'] +
                                            " - " +
                                            widget.details['endTime'],
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Sat-Sun ",
                                      ),
                                      Text(
                                        "6:00 AM - 12:00 Pm",
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          // Container(
                          //   width: MediaQuery.of(context).size.width / 1.4,
                          //   decoration: BoxDecoration(
                          //     color: whiteColor,
                          //     borderRadius: BorderRadius.circular(12.0),
                          //   ),
                          //   child: Padding(
                          //     padding: const EdgeInsets.symmetric(
                          //       horizontal: 10.0,
                          //       vertical: 15.0,
                          //     ),
                          //     child: Text(
                          //       "Rs. 1200",
                          //       textAlign: TextAlign.center,
                          //       style: TextStyle(
                          //         color: primaryColor,
                          //         fontSize: 16.0,
                          //         fontWeight: FontWeight.w800,
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          BookingWidget(widget.details['amtPerHour']),
                          Row(
                            children: [
                              Expanded(
                                flex: 4,
                                child: TextButton(
                                    style: TextButton.styleFrom(
                                        backgroundColor: primaryColor,
                                        // fixedSize: Size(
                                        //   200.0,
                                        //   40.0,
                                        // ),

                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        )),
                                    onPressed: () {
                                      // Navigator.push(context,
                                      //     MaterialPageRoute(builder: (context) {
                                      //   return SuccessfullyBooked();
                                      // }));
                                      launchGoogleMap(10.729448, 79.020248);
                                    },
                                    child: Text(
                                      "Show in Map",
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w800,
                                        color: whiteColor,
                                      ),
                                    )),
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              Expanded(
                                flex: 3,
                                child: TextButton.icon(
                                    style: TextButton.styleFrom(
                                      backgroundColor: whiteColor,
                                      // fixedSize: Size(
                                      //   200.0,
                                      //   40.0,
                                      // ),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        _createRoute(
                                          BookingScreen(widget.details),
                                        ),
                                      );
                                    },
                                    icon: Icon(
                                      Icons.swipe_right_rounded,
                                      color: primaryColor,
                                    ),
                                    iconAlignment: IconAlignment.end,
                                    label: Text(
                                      "Book Now",
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600,
                                        color: primaryColor,
                                      ),
                                    )),
                              ),
                            ],
                          )
                        ],
                      ),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BookingWidget extends StatelessWidget {
  BookingWidget(this.amount);
  int amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.0,
      width: MediaQuery.of(context).size.width / 1.4,
      decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(
            8.0,
          )),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: 10.0,
                width: 6.0,
                decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(50.0),
                      bottomRight: Radius.circular(50.0),
                    )),
              ),
              Container(
                height: 10.0,
                width: 6.0,
                decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(50.0),
                      bottomRight: Radius.circular(50.0),
                    )),
              ),
            ],
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Rs ." + amount.toString() + "/-",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: secondaryColor,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: 10.0,
                width: 6.0,
                decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50.0),
                      bottomLeft: Radius.circular(50.0),
                    )),
              ),
              Container(
                height: 10.0,
                width: 6.0,
                decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50.0),
                      bottomLeft: Radius.circular(50.0),
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MyCarouselContainer extends StatefulWidget {
  @override
  _MyCarouselContainerState createState() => _MyCarouselContainerState();
}

class _MyCarouselContainerState extends State<MyCarouselContainer> {
  final List<String> imgList = [
    'images/cricket.png',
    'images/football.png',
    'images/tennis.png',
  ];

  int _currentIndex = 0; // To keep track of the current index
  final CarouselController _carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height / 2.2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: Colors.white,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: Stack(
              children: [
                CarouselSlider(
                  carouselController: _carouselController,
                  options: CarouselOptions(
                    height: double.infinity,
                    viewportFraction: 1.0,
                    autoPlay: true,
                    aspectRatio: MediaQuery.of(context).size.width /
                        MediaQuery.of(context).size.height,
                    enlargeCenterPage: false,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                  ),
                  items: imgList
                      .map((item) => Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(item),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ))
                      .toList(),
                ),
                Positioned(
                  bottom: 100.0,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: imgList.asMap().entries.map((img) {
                      return GestureDetector(
                        onTap: () => _carouselController.animateToPage(img.key),
                        child: Container(
                          width: 10.0,
                          height: 10.0,
                          margin: EdgeInsets.symmetric(horizontal: 4.0),
                          decoration: BoxDecoration(
                            boxShadow: [],
                            border: Border.all(
                              color: _currentIndex == img.key
                                  ? whiteColor
                                  : Colors.grey.shade100,
                              width: 1,
                            ),
                            shape: BoxShape.circle,
                            color: _currentIndex == img.key
                                ? primaryColor
                                : Colors.grey.shade200,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
