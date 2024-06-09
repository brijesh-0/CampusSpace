import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  final String displayName;
  final String photoUrl;
  final Future<void> Function() onSignOut;

  const Profile({
    required this.displayName,
    required this.photoUrl,
    required this.onSignOut,
  });

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

  Widget _buildSettingItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
      trailing: Icon(Icons.chevron_right, color: Colors.grey),
      onTap: () {
        // Handle tap for each setting
      },
    );
  }
}





