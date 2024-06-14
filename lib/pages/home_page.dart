import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:campus_space/widgets/venue_card.dart';
import 'package:campus_space/models/testvenuemodel.dart'; // Import your Venue model class

class HomePage extends StatefulWidget {
  final String displayName;
  const HomePage({Key? key, required this.displayName}) : super(key: key);

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
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Find Your ',
                      style: TextStyle(
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // Default color for 'Find Your'
                      ),
                    ),
                    TextSpan(
                      text: 'Venue',
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0066FF), // Color for 'Venue'
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.left,
              )),
          const SizedBox(height: 16.0),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 50,
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
                      fillColor: Color.fromARGB(118, 223, 223, 223),
                      filled: true,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 10.0,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Color(0xFF0066FF),
                          width: 2.0,
                        ),
                      ),
                      hintText: 'Search...',
                      alignLabelWithHint: true,
                      hintStyle: const TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 14.0,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 2.0),
                child: IconButton(
                  icon: const Icon(
                    Icons.search,
                    color: Color(0xFF0066FF),
                  ),
                  onPressed: () {
                    print("pressed Search icon");
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  FilterChip(
                    label: Text(
                      'Auditoriums',
                      style: TextStyle(
                        color: selectedFilters.contains('auditorium')
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    selected: selectedFilters.contains('auditorium'),
                    onSelected: (isSelected) {
                      updateFilters('auditorium', isSelected);
                    },
                    backgroundColor: Colors.white,
                    selectedColor: Color(0xFF0066FF),
                    checkmarkColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: Text(
                      'Labs',
                      style: TextStyle(
                        color: selectedFilters.contains('lab')
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    selected: selectedFilters.contains('lab'),
                    onSelected: (isSelected) {
                      updateFilters('lab', isSelected);
                    },
                    backgroundColor: Colors.white,
                    selectedColor: Color(0xFF0066FF),
                    checkmarkColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: Text(
                      'Seminar Halls',
                      style: TextStyle(
                        color: selectedFilters.contains('seminar hall')
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    selected: selectedFilters.contains('seminar hall'),
                    onSelected: (isSelected) {
                      updateFilters('seminar hall', isSelected);
                    },
                    backgroundColor: Colors.white,
                    selectedColor: Color(0xFF0066FF),
                    checkmarkColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: Text(
                      'Outdoor',
                      style: TextStyle(
                        color: selectedFilters.contains('Outdoor')
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    selected: selectedFilters.contains('Outdoor'),
                    onSelected: (isSelected) {
                      updateFilters('Outdoor', isSelected);
                    },
                    backgroundColor: Colors.white,
                    selectedColor: Color(0xFF0066FF),
                    checkmarkColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 6.0),
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
                      displayName: widget.displayName,
                      capacity: venue.capacity,
                      imageUrl: venue.images,
                      details: venue.details);
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
