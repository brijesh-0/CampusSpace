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
        return buildAmenityItem(amenities[index]);
      },
    ),
  );
}

Widget buildAmenityItem(Map<String, dynamic> amenity) => Container(
      margin: EdgeInsets.only(right: 14),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            width: 70,
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Color.fromARGB(54, 0, 140, 255),
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
