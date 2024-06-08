import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:campus_space/widgets/venue_card.dart';
import 'package:campus_space/models/testvenuemodel.dart'; // Import your Venue model class

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> selectedFilters = [];
  String searchText = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
      child: ListView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
          const SizedBox(height: 15.0),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 45,
                  child: TextField(
                    onTapOutside: (event) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    onChanged: (value) {
                      setState(() {
                        searchText = value.toLowerCase();
                      });
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
          const SizedBox(height: 15.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  FilterChip(
                    label: const Text('Auditorium'),
                    selected: selectedFilters.contains('auditorium'),
                    onSelected: (isSelected) {
                      updateFilters('auditorium', isSelected);
                    },
                    backgroundColor: Colors.white,
                    selectedColor: Colors.blue[200],
                    checkmarkColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: const Text('Labs'),
                    selected: selectedFilters.contains('lab'),
                    onSelected: (isSelected) {
                      updateFilters('lab', isSelected);
                    },
                    backgroundColor: Colors.white,
                    selectedColor: Colors.blue[200],
                    checkmarkColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: const Text('Seminar Hall'),
                    selected: selectedFilters.contains('seminar hall'),
                    onSelected: (isSelected) {
                      updateFilters('seminar hall', isSelected);
                    },
                    backgroundColor: Colors.white,
                    selectedColor: Colors.blue[200],
                    checkmarkColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: const Text('Outdoor'),
                    selected: selectedFilters.contains('Outdoor'),
                    onSelected: (isSelected) {
                      updateFilters('Outdoor', isSelected);
                    },
                    backgroundColor: Colors.white,
                    selectedColor: Colors.blue[200],
                    checkmarkColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ],
              ),
            ),
          ),
          StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection('testvenues').snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: null);
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              final filteredVenues = snapshot.data?.docs
                      .map((doc) =>
                          Venue.fromMap(doc.data() as Map<String, dynamic>?))
                      .where((venue) =>
                          (selectedFilters.isEmpty ||
                              selectedFilters.contains(venue.venueType)) &&
                          (searchText.isEmpty ||
                              venue.name.toLowerCase().contains(searchText)))
                      .toList() ??
                  [];

              return Column(
                children: filteredVenues.map((venue) {
                  return VenueCard(
                      name: venue.name,
                      capacity: venue.capacity,
                      imageUrl: venue.images);
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  void updateFilters(String filter, bool isSelected) {
    setState(() {
      if (isSelected) {
        selectedFilters.add(filter);
      } else {
        selectedFilters.remove(filter);
      }
    });
  }
}
