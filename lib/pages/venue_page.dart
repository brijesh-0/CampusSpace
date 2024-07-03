import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:campus_space/widgets/amenities_list.dart';
import 'package:campus_space/widgets/Booking_Form.dart';
import 'package:campus_space/widgets/Calendar.dart';
import 'package:campus_space/models/bookingsmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VenueDetailsPage extends StatefulWidget {
  final String displayName;
  final String venuename;
  final String capacity;
  final List<String> images;
  final String details;
  final String location;

  const VenueDetailsPage({
    required this.displayName,
    required this.venuename,
    required this.capacity,
    required this.images,
    required this.details,
    required this.location,
    super.key,
  });

  @override
  VenueDetailsPageState createState() => VenueDetailsPageState();
}

class VenueDetailsPageState extends State<VenueDetailsPage> {
  List<Booking> bookings = [];
  bool isExpanded = false;
  int activeIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    bookings = await fetchBookingsForVenue(widget.venuename);
    print(bookings);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        /*decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color(0xFFC5E7FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.6, 1.0],
          ),
        ),*/
        child: ListView(
          children: [
            buildImageSlider(),
            Padding(
              padding:
                  const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  Text(
                    widget.venuename,
                    style: const TextStyle(
                        fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      const Icon(Icons.people_alt_outlined, size: 18.0),
                      const Padding(padding: EdgeInsets.only(right: 5.0)),
                      Text("Capacity: ${widget.capacity}"),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.location_pin, size: 18.0),
                      const Padding(padding: EdgeInsets.only(right: 5.0)),
                      Text(widget.location),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Details',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.details,
                          maxLines: isExpanded ? null : 3,
                          textAlign: TextAlign.justify,
                        ),
                        const SizedBox(height: 3),
                        if (!isExpanded)
                          const Row(
                            children: [
                              Text(
                                'Read more',
                                style: TextStyle(color: Color(0xFF0066FF)),
                              ),
                              Icon(Icons.keyboard_arrow_down,
                                  color: Color(0xFF0066FF)),
                            ],
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Amenities',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  buildAmenitiesList(),
                  const SizedBox(height: 24),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CalendarScreen(
                                    venue: widget.venuename,
                                  )),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size.fromWidth(370.0),
                        backgroundColor: Color.fromARGB(255, 255, 255, 255),
                        side: BorderSide(width: 1.5, color: Color(0xFF0066FF)),
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        textStyle: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w400),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: const Text(
                        'View Venue Calendar',
                        style: TextStyle(color: Color(0xFF0066FF)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        showModalBottomSheet(
                          useSafeArea: true,
                          context: context,
                          isScrollControlled:
                              true, // To make sure the sheet takes full height
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(25.0)),
                          ),
                          builder: (BuildContext context) {
                            return Padding(
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              child: BookingForm(
                                  capacity: widget.capacity,
                                  venuename: widget.venuename,
                                  userName: widget.displayName,
                                  bookings: bookings),
                            );
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size.fromWidth(370.0),
                        backgroundColor: const Color(0xFF0066FF),
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        textStyle: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: const Text(
                        'Book Now',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Booking>> fetchBookingsForVenue(String venueName) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('bookings')
        .where('venuename', isEqualTo: venueName)
        .get();
    print(snapshot.docs); // Print the fetched documents
    return snapshot.docs
        .map((doc) => Booking.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Widget buildImageSlider() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 7,
            offset: Offset(1, 1.5),
          ),
        ],
      ),
      child: Stack(
        children: [
          CarouselSlider.builder(
            itemCount: widget.images.length,
            itemBuilder: (context, index, realIndex) {
              return buildImage(widget.images[index], index);
            },
            options: CarouselOptions(
              height: 240,
              viewportFraction: 1,
              autoPlay: true,
              onPageChanged: (index, reason) =>
                  setState(() => activeIndex = index),
            ),
          ),
          Positioned(
              top: 15, // Adjust the top position as needed
              left: 10, // Adjust the left position as needed
              child: Container(
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(30), // Adjust the radius as needed
                  color: Colors.white,
                ),
                child: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              )),
          const SizedBox(height: 16),
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Center(child: buildIndicator(widget.images.length)),
          ),
        ],
      ),
    );
  }

  Widget buildImage(String imgPath, int index) {
    return Container(
      color: Colors.grey,
      child: Image.network(
        imgPath,
        fit: BoxFit.cover,
        width: double.infinity,
      ),
    );
  }

  Widget buildIndicator(int count) {
    return AnimatedSmoothIndicator(
      activeIndex: activeIndex,
      count: count,
      effect: const ExpandingDotsEffect(
        dotWidth: 10,
        dotHeight: 10,
        activeDotColor: Color(0xFF0066FF),
        dotColor: Colors.grey,
      ),
    );
  }
}
