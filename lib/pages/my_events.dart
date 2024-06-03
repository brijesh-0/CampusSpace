import 'package:flutter/material.dart';
import 'package:campus_space/widgets/my_event.dart';

class MyEvents extends StatelessWidget {
  const MyEvents({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
      child: ListView(
        children: const [
          Padding(
            padding: EdgeInsets.only(left: 4.0, top: 15.0),
            child: Text(
              'My Events',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 15.0),
          const MyEvent() // Adding some space between text and TextField
        ],
      ),
    );
  }
}
