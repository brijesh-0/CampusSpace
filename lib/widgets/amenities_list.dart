import 'package:flutter/material.dart';

Widget buildAmenitiesList() {
  final amenities = [
    {'icon': Icons.wifi, 'text': 'Wi-Fi'},
    {'icon': Icons.tv, 'text': 'Screen'},
    {'icon': Icons.ac_unit, 'text': 'AC'},
    {'icon': Icons.speaker, 'text': 'Speakers'}
  ];

  return Container(
    height: 100,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: amenities.length,
      itemBuilder: (context, index) {
        return buildAmenityItem(amenities[index], index);
      },
    ),
  );
}

Widget buildAmenityItem(Map<String, dynamic> amenity, int index) {
  List<Color> colors = [
    const Color.fromARGB(54, 0, 255, 68),
    const Color.fromARGB(54, 255, 0, 0),
    const Color.fromARGB(54, 0, 106, 255),
    Color.fromARGB(134, 255, 209, 59)
    // Add more colors as needed
  ];
  return Container(
    margin: EdgeInsets.only(right: 14),
    child: Column(
      children: [
        Container(
          padding: EdgeInsets.all(12),
          width: 70,
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: colors[index % colors.length],
              borderRadius: BorderRadius.circular(10.0)),
          child: Icon(
            amenity['icon'],
            size: 32,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          amenity['text'],
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14),
        ),
      ],
    ),
  );
}
