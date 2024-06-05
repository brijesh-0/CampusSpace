import 'package:flutter/material.dart';
import 'package:campus_space/pages/venue_page.dart';

class VenueCard extends StatelessWidget {
  const VenueCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Container(
          width: double.infinity, // Take full width
          height: 190,
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                VenueDetailsPage.routeName,
                //arguments: imageUrl,
              );
            },
            child: Card(
              clipBehavior: Clip.hardEdge, // Clip content at card edges
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Stack(
                children: <Widget>[
                  // Use Expanded to fill remaining space
                  Image.network(
                    'https://www.collegebatch.com/static/clg-gallery/bms-college-of-engineering-bangalore-218122.jpg',
                    width: double.infinity, // Take full width
                    fit: BoxFit.cover, // Cover the entire area
                  ),

                  // Gradient overlay -- Deprecated in favour or Text Shadow
                  // Container(
                  //     decoration: const BoxDecoration(
                  //         gradient: LinearGradient(
                  //             colors: [Colors.transparent, Colors.black],
                  //             begin: Alignment.topCenter,
                  //             end: Alignment.bottomCenter))),

                  const Positioned(
                    bottom: 10.0,
                    left: 30.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Overlay Text',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    color: Colors
                                        .black, // Choose the color of the shadow
                                    blurRadius:
                                        2.0, // Adjust the blur radius for the shadow effect
                                    offset: Offset(2.0, 2.0),
                                  )
                                ])),
                        Row(
                          children: [
                            Icon(Icons.people_alt_rounded,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    color: Colors
                                        .black, // Choose the color of the shadow
                                    blurRadius:
                                        2.0, // Adjust the blur radius for the shadow effect
                                    offset: Offset(2.0, 2.0),
                                  )
                                ]),
                            Text(' Capacity: 100',
                                style: TextStyle(color: Colors.white, shadows: [
                                  Shadow(
                                    color: Colors
                                        .black, // Choose the color of the shadow
                                    blurRadius:
                                        2.0, // Adjust the blur radius for the shadow effect
                                    offset: Offset(2.0, 2.0),
                                  )
                                ]))
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
