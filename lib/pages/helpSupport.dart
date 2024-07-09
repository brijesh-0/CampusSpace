import 'package:flutter/material.dart';

class HelpSupport extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        padding:
            EdgeInsets.only(top: 75.0, bottom: 16.0, right: 16.0, left: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Help & Support',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'FAQs',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            ExpansionTile(
              title: Text('How to use the app?'),
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                      'You can use the app by navigating through the menu and selecting the desired options.'),
                ),
              ],
            ),
            ExpansionTile(
              title: Text('How to contact support?'),
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                      'You can contact support by emailing support@example.com or calling (123) 456-7890.'),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Contact Us',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            ListTile(
              leading: Icon(Icons.email),
              title: Text('Email'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('avyukth.cs22@bmsce.ac.in'),
                  Text('ayman.cs22@bmsce.ac.in'),
                  Text('brijesh.cs22@bmsce.ac.in'),
                  Text('pragna.cs22@bmsce.ac.in'),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('Phone'),
              subtitle: Text('+91-80-26622130-35'),
            ),
            ListTile(
              leading: Icon(Icons.location_on),
              title: Text('Address'),
              subtitle: Text(
                  'Bull Temple Rd, Basavanagudi, Bengaluru, Karnataka 560019'),
            ),
          ],
        ),
      ),
    );
  }
}
