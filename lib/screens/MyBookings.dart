import 'package:flutter/material.dart';
import 'package:turf_arena/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MyBookings extends StatefulWidget {
  MyBookings(this.details);
  Map details;

  @override
  State<MyBookings> createState() => _MyBookingsState();
}

class _MyBookingsState extends State<MyBookings> {
  List<Map<String, dynamic>> bookingsList = [];
  bool loadingData = true;
  bool isEmpty = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // List<DocumentSnapshot> _documents = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _documentLimit = 4; // Number of documents to fetch per page
  DocumentSnapshot? _lastDocument; // To keep track of the last fetched document
  late ScrollController _scrollController = ScrollController();
  // late DocumentSnapshot _lastDocument;

  // late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    // amount = widget.details['amtPerHour'];
    // details = widget.details;

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

    // Load initial data
    _loadMoreData();
  }

  int page = 1; // Current page number
  // final int itemsPerPage = 3;

  // Future<void> fetchTurfs() async {
  //   CollectionReference bookings =
  //       FirebaseFirestore.instance.collection('bookings');

  //   Query query = bookings
  //       .where('u_id', isEqualTo: 'ZdJQ8w3OsoYqQaNxrMyOV2kVbQu1')
  //       .limit(_documentLimit);

  //   if (_lastDocument != null) {
  //     query = query.startAfterDocument(_lastDocument!);
  //   }

  //   try {
  //     QuerySnapshot snapshot = await query.get();

  //     if (snapshot.docs.length < _documentLimit) {
  //       _hasMore = false; // No more documents to load
  //     }

  //     _lastDocument = snapshot.docs.isNotEmpty ? snapshot.docs.last : null;

  //     setState(() {
  //       loadingData = false;
  //       snapshot.docs.forEach((doc) {
  //         bookingsList.add(doc.data() as Map<String, dynamic>);
  //       });
  //     });
  //   } catch (error) {
  //     print("Error getting documents: $error");
  //   }
  // }

  Future<void> fetchBookings() async {
    CollectionReference bookings =
        FirebaseFirestore.instance.collection('bookings');

    Query query = bookings
        .where('u_id', isEqualTo: widget.details['uid'])
        // .where('paid', isEqualTo: true)
        .limit(_documentLimit);

    if (_lastDocument != null) {
      query = query.startAfterDocument(_lastDocument!);
    }

    try {
      QuerySnapshot snapshot = await query.get();

      if (_lastDocument == null && snapshot.docs.length == 0) {
        setState(() {
          isEmpty = true;
        });
      }

      if (snapshot.docs.length < _documentLimit) {
        _hasMore = false; // No more documents to load
      }

      _lastDocument = snapshot.docs.isNotEmpty ? snapshot.docs.last : null;

      setState(() {
        loadingData = false;
        snapshot.docs.forEach((doc) {
          bookingsList.add(doc.data() as Map<String, dynamic>);
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

    await fetchBookings(); // Your existing data fetch method

    setState(() {
      _isLoading = false;
    });
  }

  // Future<void> _loadMoreData() async {
  //   if (_isLoading) return; // Prevent multiple calls
  //   setState(() {
  //     _isLoading = true; // Set loading state
  //   });

  //   // Simulate a network call or query Firestore
  //   try {
  //     // Example: Fetch bookings from Firestore based on page number
  //     late QuerySnapshot querySnapshot;

  //     if (bookingsList.isEmpty) {
  //       // First fetch, don't use startAfterDocument
  //       querySnapshot =
  //           await _firestore.collection('bookings').limit(_documentLimit).get();
  //     } else {
  //       // Subsequent fetch
  //       querySnapshot = await _firestore
  //           .collection('bookings')
  //           .startAfterDocument(_lastDocument!)
  //           .limit(_documentLimit)
  //           .get();
  //     }
  //     final List<Map<String, dynamic>> newBookings = querySnapshot.docs
  //         .map((doc) => doc.data() as Map<String, dynamic>)
  //         .toList();

  //     // if (newBookings.isNotEmpty) {
  //     // _lastDocument = querySnapshot.docs.last; // Update last document
  //     // }

  //     setState(() {
  //       bookingsList.addAll(newBookings);
  //       page++;
  //       _lastDocument = querySnapshot.docs.last;
  //     });
  //   } catch (e) {
  //     // Handle error
  //     print('Error loading data: $e');
  //   } finally {
  //     setState(() {
  //       _isLoading = false; // Reset loading state
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: secondaryColor,
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20.0,
            right: 20.0,
            top: 50.0,
          ),
          child: Column(
            children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // IconButton(
                    //   onPressed: () {
                    //     Navigator.pop(context);
                    //   },
                    //   highlightColor: greyColor,
                    //   color: whiteColor,
                    //   focusColor: secondaryColor,
                    //   icon: Icon(
                    //     Icons.arrow_back_rounded,
                    //     // color: whiteColor,
                    //     size: 30.0,
                    //   ),
                    // ),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.5,
                      child: Center(
                        child: Text(
                          "My Bookings",
                          // textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                            color: whiteColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _loadMoreData,
                  child: isEmpty
                      ? NoBookings()
                      : ListView.builder(
                          controller: _scrollController,
                          physics: AlwaysScrollableScrollPhysics(),
                          itemCount: _isLoading
                              ? bookingsList.length + 3
                              : bookingsList.length,
                          itemBuilder: (context, index) {
                            if (index < bookingsList.length) {
                              // Replace with your booking item widget
                              return BookingWidget(
                                  bookingsList[index], whiteColor);
                            } else if (_isLoading) {
                              return Skeletonizer(
                                enabled: true,
                                enableSwitchAnimation: true,
                                child: BookingWidget({
                                  'turfName': "Lorem Ipsum",
                                  'date': '00-00-00',
                                  'bookedTime': "00:00 00-00-00",
                                  "from": "7 AM",
                                  "to": "8 AM",
                                }, Color.fromARGB(232, 215, 214, 214)),
                              );
                            }
                          },
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NoBookings extends StatelessWidget {
  const NoBookings({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.sentiment_dissatisfied_rounded,
              color: whiteColor,
              size: 120.0,
            ),
            SizedBox(
              height: 30.0,
            ),
            Text(
              'No Bookings Found.',
              style: TextStyle(
                color: whiteColor,
                fontSize: 18.0,
              ),
            ),
            Text(
              'Book Your Turfs Now!',
              style: TextStyle(
                color: whiteColor,
                fontSize: 18.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BookingWidget extends StatelessWidget {
  BookingWidget(this.details, this.bgColor);
  Color bgColor;
  Map details;

  String capitalize(String? text) {
    if (text == null || text.isEmpty) {
      return text!; // Return as is if the string is null or empty
    }
    return text.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 7.0,
      ),
      child: Container(
        // height: 170.0,
        decoration: BoxDecoration(
            color: bgColor,
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
                  height: 25.0,
                  width: 15.0,
                  decoration: BoxDecoration(
                      color: secondaryColor,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(50.0),
                        bottomRight: Radius.circular(50.0),
                      )),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Container(
                  height: 25.0,
                  width: 15.0,
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
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15.0,
                  vertical: 20.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Turf Booked : " + capitalize(details['turfName']),
                      style: TextStyle(
                        color: secondaryColor,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "To Play at : " + details['date'],
                      style: TextStyle(
                        color: secondaryColor,
                        fontSize: 16.0,
                      ),
                    ),
                    Text(
                      "Time : " +
                          " From " +
                          details['from'] +
                          " to " +
                          details['to'],
                      style: TextStyle(
                        color: secondaryColor,
                        fontSize: 16.0,
                      ),
                    ),
                    Text(
                      "Booked at : " + details['bookedTime'],
                      style: TextStyle(
                        color: secondaryColor,
                        fontSize: 16.0,
                      ),
                    ),
                    Text(
                      "Amount Paid : Rs.1200",
                      style: TextStyle(
                        color: secondaryColor,
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 25.0,
                  width: 15.0,
                  decoration: BoxDecoration(
                      color: secondaryColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50.0),
                        bottomLeft: Radius.circular(50.0),
                      )),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Container(
                  height: 25.0,
                  width: 15.0,
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
      ),
    );
  }
}
