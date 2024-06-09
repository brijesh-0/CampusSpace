import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Container(
        /*decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.6, 1.0]),
        ),*/
        child: Center(child: Text('Profile page')),
      ),
    );
  }
}
