import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Find a Venue',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5.0), // Adding some space between text and TextField
          TextField(
            onChanged: (value) {
              print('$value');
            },
            cursorColor: Colors.grey,
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(width: 20.0, color: Colors.black),
              ),
              hintText: 'Search...',
              alignLabelWithHint: true,
              hintStyle: TextStyle(color: Colors.grey, fontSize: 14.0),
              suffixIcon: const Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: Icon(Icons.search),
              ), // Corrected icon usage
            ),
          ),
        ],
      ),
    );
  }
}
