import 'package:flutter/material.dart';
import 'package:campus_space/pages/venue_page.dart';

class VenueCard extends StatelessWidget {
  final String name;
  final String capacity;
  final List<String> imageUrl;

  const VenueCard({
    required this.name,
    required this.capacity,
    required this.imageUrl,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: SizedBox(
        width: double.infinity,
        height: 190,
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => VenueDetailsPage(
                    venuename: name, capacity: capacity, images: imageUrl)));
          },
          child: Card(
            clipBehavior: Clip.hardEdge,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Stack(
              children: <Widget>[
                Image.network(
                  imageUrl[0],
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  bottom: 10.0,
                  left: 30.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Colors.black,
                              blurRadius: 2.0,
                              offset: Offset(1.0, 1.0),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.people_alt_rounded,
                            color: Colors.white,
                            size: 18.0,
                            shadows: [
                              Shadow(
                                color: Colors.black,
                                blurRadius: 2.0,
                                offset: Offset(1.0, 1.0),
                              ),
                            ],
                          ),
                          Text(
                            ' Capacity: $capacity',
                            style: const TextStyle(
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: Colors.black,
                                  blurRadius: 2.0,
                                  offset: Offset(1.0, 1.0),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
