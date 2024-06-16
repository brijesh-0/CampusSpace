import 'package:flutter/material.dart';
import 'package:campus_space/widgets/my_event.dart';

class MyEvents extends StatelessWidget {
  final String photoUrl;
  const MyEvents({super.key, required this.photoUrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
      child: ListView(
        children: [
          Padding(
              padding: EdgeInsets.only(left: 4.0, top: 15.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'My ',
                          style: TextStyle(
                            fontSize: 28.0,
                            fontWeight: FontWeight.bold,
                            color:
                                Colors.black, // Default color for 'Find Your'
                          ),
                        ),
                        TextSpan(
                          text: 'Reservations',
                          style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0066FF), // Color for 'Venue'
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(width: 100.0),
                  CircleAvatar(
                    radius: 20.0,
                    backgroundImage: NetworkImage(photoUrl),
                    // Replace with your image asset
                  ),
                ],
              )),
          SizedBox(height: 15.0),
          MyEvent(),
          MyEvent(),
          // Adding some space between text and TextField
        ],
      ),
    );
  }
}
