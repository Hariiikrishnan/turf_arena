import 'package:turf_arena/constants.dart';
import 'package:turf_arena/screens/IndividualTurf.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skeletonizer/skeletonizer.dart';

class TurfsList extends StatefulWidget {
  TurfsList(this.title, this.userDetails);
  String title;
  Map userDetails;

  @override
  State<TurfsList> createState() => _TurfsListState();
}

String capitalize(String text) {
  if (text == null || text.isEmpty) {
    return text; // Return as is if the string is null or empty
  }
  return text.split(' ').map((word) {
    if (word.isEmpty) return word;
    return word[0].toUpperCase() + word.substring(1).toLowerCase();
  }).join(' ');
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

class _TurfsListState extends State<TurfsList> {
  bool loadingData = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // print(widget.userDetails['u_id']);
    print(loadingData);

    _scrollController.addListener(() {
      print("Scrolling position: ${_scrollController.position.pixels}");
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !_isLoading &&
          _hasMore) {
        _loadMoreData();
        print("Loading more data...");
      }
    });

    filter = widget.title;
    (filter == "Cricket" ||
            filter == "Football" ||
            filter == "Badminton" ||
            filter == "Tennis")
        ? fetchTurfs()
        : widget.title == "Saved List"
            ? fetchSaved()
            : fetchByName();
  }

  late String filter;

  List<Map<String, dynamic>> turfList = []; // List to store the document data

  bool _isLoading = true;
  bool _hasMore = true;
  int _documentLimit = 4; // Number of documents to fetch per page
  DocumentSnapshot? _lastDocument; // To keep track of the last fetched document
  late ScrollController _scrollController = ScrollController();

  Future<void> fetchTurfs() async {
    CollectionReference turfs = FirebaseFirestore.instance.collection('turfs');

    Query query =
        turfs.where('allowed', arrayContains: filter).limit(_documentLimit);

    if (_lastDocument != null) {
      query = query.startAfterDocument(_lastDocument!);
    }

    try {
      QuerySnapshot snapshot = await query.get();

      if (snapshot.docs.length < _documentLimit) {
        _hasMore = false; // No more documents to load
      }

      _lastDocument = snapshot.docs.isNotEmpty ? snapshot.docs.last : null;

      setState(() {
        loadingData = false;
        _isLoading = false;
        snapshot.docs.forEach((doc) {
          // print(doc.id);

          turfList.add(doc.data() as Map<String, dynamic>);
        });
      });
    } catch (error) {
      print("Error getting documents: $error");
    }
  }

  Future<void> _loadMoreData() async {
    if (_isLoading || !_hasMore) return; // Prevent duplicate loading

    setState(() {
      _isLoading = true;
    });

    await fetchTurfs(); // Your existing data fetch method

    setState(() {
      _isLoading = false;
    });
  }

  // Future<void> fetchTurfs() {
  //   CollectionReference turfs = FirebaseFirestore.instance.collection('turfs');

  //   // await Future.delayed(Duration(seconds: 5));

  //   return turfs
  //       .where('allowed', arrayContains: filter)
  //       .get()
  //       .then((QuerySnapshot snapshot) {
  //     snapshot.docs.forEach((doc) {
  //       setState(() {
  //         // Store the document data into the list
  //         loadingData = false;
  //         turfList.add(doc.data() as Map<String, dynamic>);
  //       });
  //       print(loadingData);
  //       // print('${doc.id} => ${doc.data()}');
  //     });
  //   }).catchError((error) {
  //     print("Error getting documents: $error");
  //   });
  // }

  Future<void> fetchByName() {
    CollectionReference turfs = FirebaseFirestore.instance.collection('turfs');

    // await Future.delayed(Duration(seconds: 5));

    return turfs
        .where('name', isEqualTo: filter)
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((doc) {
        setState(() {
          // Store the document data into the list
          loadingData = false;
          turfList.add(doc.data() as Map<String, dynamic>);
        });
        print(loadingData);
        // print('${doc.id} => ${doc.data()}');
      });
    }).catchError((error) {
      print("Error getting documents: $error");
    });
  }

  Future<void> fetchSaved() {
    CollectionReference turfs = FirebaseFirestore.instance.collection('turfs');

    // await Future.delayed(Duration(seconds: 5));

    return turfs
        .where('t_id', whereIn: widget.userDetails['liked'])
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((doc) {
        setState(() {
          // Store the document data into the list
          loadingData = false;
          turfList.add(doc.data() as Map<String, dynamic>);
          _isLoading = false;
        });
        print(loadingData);
        // print('${doc.id} => ${doc.data()}');
      });
    }).catchError((error) {
      print("Error getting documents: $error");
    });
  }

  // List<TurfTile> list = [];
  // List<TurfTile> getTurfList() {
  //   turfList.forEach(
  //     (turf) => list.add(TurfTile(turf)),
  //   );

  //   return list;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Container(
        child: Column(
          children: [
            Container(
              // decoration: ,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 25.0,
                  right: 25.0,
                  top: 80.0,
                  bottom: 30.0,
                ),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    widget.title == "Saved List"
                        ? SizedBox(
                            width: MediaQuery.of(context).size.width / 10,
                          )
                        : IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            // splashColor: primaryColor,
                            // hoverColor: primaryColor,
                            highlightColor: greyColor,
                            // iconSize: 20.0,
                            color: whiteColor,
                            focusColor: secondaryColor,
                            icon: Icon(
                              Icons.arrow_back_rounded,
                              // color: whiteColor,
                              size: 30.0,
                            ),
                          ),
                    // SizedBox(
                    //   width: 30.0,
                    // ),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.5,
                      child: Center(
                        child: Text(
                          capitalize(widget.title),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: whiteColor,
                            fontSize: 30.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              // flex: 4,
              child: Container(
                // height: 500.0,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60.0),
                      topRight: Radius.circular(60.0),
                    )),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 20.0,
                    right: 20.0,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
                    child: RefreshIndicator(
                      onRefresh: _loadMoreData,
                      child: ListView.builder(
                        controller: _scrollController,
                        physics: AlwaysScrollableScrollPhysics(),
                        itemCount:
                            _isLoading ? turfList.length + 3 : turfList.length,
                        itemBuilder: (context, index) {
                          if (index < turfList.length) {
                            return TurfTile(
                                turfList[index], widget.userDetails);
                          } else if (_isLoading) {
                            return Skeletonizer(
                              enabled: true,
                              enableSwitchAnimation: true,
                              child: TurfTile({
                                'name': 'Turf Trichy',
                                'amtPerHour': "",
                                'address':
                                    'Lorem Ipsum Loreum Ipsum Lorem Ipsum Lorem Ipsum Loreum Ipsum Lorem Ipsum',
                              }, {}),
                            );
                          }
                        },
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

class TurfSkeleton extends StatefulWidget {
  const TurfSkeleton({super.key});

  @override
  State<TurfSkeleton> createState() => _TurfSkeletonState();
}

class _TurfSkeletonState extends State<TurfSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 150.0,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(16.0),
      ),
    );
  }
}

class TurfTile extends StatelessWidget {
  TurfTile(this.details, this.userDetails);
  Map details;
  Map userDetails;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10.0,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          color: whiteColor,
        ),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  bottomLeft: Radius.circular(16.0),
                ),
                child: Image(
                  fit: BoxFit.cover,
                  image: AssetImage("images/cricket.png"),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                // height: double.infinity,
                decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(16.0),
                      bottomRight: Radius.circular(16.0),
                    )),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        capitalize(details['name']),
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        details['address'],
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 12.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        "Rs. " + details['amtPerHour'].toString() + "/-",
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton.icon(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size(100.0, 30.0),
                              // fixedSize: Size.zero,
                              backgroundColor: secondaryColor,
                            ),
                            onPressed: () {
                              Navigator.of(context).push(
                                _createRoute(
                                  Individualturf(details, userDetails),
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.north_east,
                              color: whiteColor,
                              size: 11.0,
                            ),
                            iconAlignment: IconAlignment.end,
                            label: Text(
                              "Read More",
                              style: TextStyle(
                                fontSize: 13.0,
                                color: whiteColor,
                              ),
                            ),
                          ),
                          Container(
                            // width: 100.0,
                            height: 30.0,
                            decoration: BoxDecoration(
                              color: secondaryColor,
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Row(
                                children: [
                                  Text(
                                    "4.9",
                                    style: TextStyle(
                                      color: whiteColor,
                                      fontSize: 11.0,
                                    ),
                                  ),
                                  Icon(
                                    Icons.star,
                                    size: 13.0,
                                    color: Colors.yellow,
                                  ),
                                  Icon(
                                    Icons.star,
                                    size: 13.0,
                                    color: Colors.yellow,
                                  ),
                                  Icon(
                                    Icons.star,
                                    size: 13.0,
                                    color: Colors.yellow,
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
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
