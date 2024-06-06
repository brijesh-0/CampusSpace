import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:campus_space/widgets/venue_card.dart';
import 'package:campus_space/models/testvenuemodel.dart'; // Import your Venue model class

class HomePage extends StatelessWidget {
  const HomePage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
      child: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 4.0, top: 15.0),
            child: Text(
              'Find Your Venue',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
              height: 15.0), // Adding some space between text and TextField
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 45,
                  child: TextField(
                    onChanged: (value) {
                      print('$value');
                    },
                    cursorColor: Colors.grey,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 10.0,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      hintText: 'Search...',
                      alignLabelWithHint: true,
                      hintStyle: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14.0,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    print("pressed Search icon");
                  },
                ),
              ),
            ],
          ),
          StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection('testvenues').snapshots(), // this is the query TODO: replace with service
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              // stores the data in venues variable
              final venues = snapshot.data?.docs
                      .map((doc) =>
                          Venue.fromMap(doc.data() as Map<String, dynamic>?))
                      .toList() ??
                  []; // Venue is the model

              return Column(
                children: venues.map((venue) {
                  return VenueCard(
                      name: venue.name,
                      capacity: venue.capacity,
                      imageUrl: venue.images.isNotEmpty ? venue.images[0] : '');
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
