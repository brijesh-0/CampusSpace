import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:campus_space/widgets/amenities_list.dart';

class VenueDetailsPage extends StatefulWidget {
  final String venuename;
  final String capacity;
  final List<String> images;

  const VenueDetailsPage({
    required this.venuename,
    required this.capacity,
    required this.images,
    super.key,
  });

  @override
  VenueDetailsPageState createState() => VenueDetailsPageState();
}

class VenueDetailsPageState extends State<VenueDetailsPage> {
  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color(0xFFC5E7FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.6, 1.0],
          ),
        ),
        child: ListView(
          children: [
            buildImageSlider(),
            Padding(
              padding:
                  const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Text(
                    widget.venuename,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      const Icon(Icons.people_alt_outlined, size: 18.0),
                      const Padding(padding: EdgeInsets.only(right: 5.0)),
                      Text("Capacity: ${widget.capacity}"),
                    ],
                  ),
                  const Row(
                    children: [
                      Icon(Icons.location_pin, size: 18.0),
                      Padding(padding: EdgeInsets.only(right: 5.0)),
                      Text("Ground Floor, PJ Block"),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Details:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'A modern facility equipped with advanced audio-visual systems, accommodating large audiences for seminars, lectures, and cultural events, enhancing the academic and social experience.',
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Amenities:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  buildAmenitiesList(),
                  const SizedBox(height: 24),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle booking action
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0066FF),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 130, vertical: 14),
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

  Widget buildImageSlider() {
    return Stack(
      children: [
        CarouselSlider.builder(
          itemCount: widget.images.length,
          itemBuilder: (context, index, realIndex) {
            return buildImage(widget.images[index], index);
          },
          options: CarouselOptions(
            height: 240,
            viewportFraction: 1,
            onPageChanged: (index, reason) =>
                setState(() => activeIndex = index),
          ),
        ),
        const SizedBox(height: 16),
        Positioned(
          bottom: 10,
          left: 0,
          right: 0,
          child: Center(child: buildIndicator(widget.images.length)),
        ),
      ],
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
