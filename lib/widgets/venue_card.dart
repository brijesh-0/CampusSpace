import 'package:flutter/material.dart';

class VenueCard extends StatelessWidget {
  const VenueCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Container(
        width: double.infinity, // Take full width
        height: 200,
        child: Card(
          clipBehavior: Clip.hardEdge, // Clip content at card edges
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Stack(
            children: <Widget>[
              // Use Expanded to fill remaining space
              Image.network(
                'https://picsum.photos/200/300',
                width: double.infinity, // Take full width
                fit: BoxFit.cover, // Cover the entire area
              ),

              const Positioned(
                bottom: 10.0,
                left: 30.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Overlay Text',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.people_alt_rounded,
                          color: Colors.white,
                        ),
                        Text(' Capasity: over 9000',
                            style: TextStyle(color: Colors.white))
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
