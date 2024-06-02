import 'package:flutter/material.dart';
import 'package:campus_space/widgets/venue_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
      child: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 15.0),
            child: Text(
              'Find Your Venue',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 25.0,
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
                  height: 50,
                  child: TextField(
                    onChanged: (value) {
                      print('$value');
                    },
                    cursorColor: Colors.grey,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      hintText: 'Search...',
                      alignLabelWithHint: true,
                      hintStyle: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    print("pressed Search icon");
                  },
                ),
              ),
            ],
          ),
          const VenueCard(),
          const VenueCard(),
          const VenueCard(),
          const VenueCard(),
          const VenueCard(),
          const VenueCard(),
          const VenueCard(),
          const VenueCard(),
        ],
      ),
    );
  }
}
