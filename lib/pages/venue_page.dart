import 'package:flutter/material.dart';

class VenueDetailsPage extends StatefulWidget {
  static const routeName = '/venue-details';

  @override
  VenueDetailsPageState createState() => VenueDetailsPageState();
}

class VenueDetailsPageState extends State<VenueDetailsPage> {
  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    //final String imgPath = ModalRoute.of(context)?.settings.arguments as String;

    return Scaffold(
        body: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.white, Color(0xFFC5E7FF)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.6, 1.0])),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //buildImageSlider(imgPath),
                  const SizedBox(height: 16),
                  const Text(
                    'Venue Name',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Details:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Description: This is a beautiful venue with amazing amenities. It is perfect for events and gatherings.',
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Amenities:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    '• Free Wi-Fi\n• Parking\n• Catering Services\n• Audio-Visual Equipment\n• Air Conditioning',
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle booking action
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF0066FF),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 120, vertical: 14),
                        textStyle: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(10.0), // No border radius
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
            )));
  }
}
