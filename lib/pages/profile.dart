import 'package:campus_space/pages/helpSupport.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:campus_space/widgets/venue_history_screen.dart';
import 'package:campus_space/pages/notifications_screen.dart';
import 'package:intl/intl.dart';

class Profile extends StatelessWidget {
  final String displayName;
  final String photoUrl;
  final Future<void> Function() onSignOut;

  const Profile({
    required this.displayName,
    required this.photoUrl,
    required this.onSignOut,
  });

  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
      await onSignOut();
      Navigator.pushReplacementNamed(context, '/');
    } catch (error) {
      print("Failed to sign out: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sign out: $error')),
      );
    }
  }

  Future<List<Map<String, dynamic>>> fetchPastBookings() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return [];
    }

    final bookingsQuery = await FirebaseFirestore.instance
        .collection('bookings')
        .where('contactEmail', isEqualTo: user.email)
        .get();

    List<Map<String, dynamic>> pastBookings = [];
    DateFormat dateFormat = DateFormat('yyyy-MM-dd h:mm a');

    for (var doc in bookingsQuery.docs) {
      var booking = doc.data();
      List<dynamic> dateTimeList = booking['dateTimeList'];

      bool hasPastBooking = dateTimeList.any((dateTime) {
        try {
          DateTime endTime =
              dateFormat.parse('${dateTime['date']} ${dateTime['end-time']}');
          return endTime.isBefore(DateTime.now());
        } catch (e) {
          print('Error parsing date: $e');
          return false;
        }
      });

      if (hasPastBooking) {
        pastBookings.add(booking);
      }
    }

    return pastBookings;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
        child: ListView(
          children: <Widget>[
            const Padding(
                padding: EdgeInsets.only(left: 4.0, top: 20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'My ',
                            style: TextStyle(
                              fontSize: 28.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: 'Profile',
                            style: TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0066FF),
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                )),
            const SizedBox(height: 20),
            Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 2),
                  image: DecorationImage(
                    image: NetworkImage(photoUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                "Welcome " + displayName + "!",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 30),
            _buildSettingItem(Icons.history, 'Venue History', context,
                () => VenueHistoryScreen(fetchPastBookings: fetchPastBookings)),
            _buildSettingItem(Icons.notifications, 'Notifications', context,
                () => NotificationsScreen()),
            _buildSettingItem(
                Icons.help, 'Help and Support', context, () => HelpSupport()),
            const SizedBox(height: 140.0),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton.icon(
                onPressed: () async {
                  await _signOut(context);
                },
                icon: const Icon(Icons.logout, color: Colors.white),
                label:
                    const Text('Logout', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 218, 48, 48),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 110),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem(IconData icon, String title, BuildContext context,
      Widget Function() pageBuilder) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: const Color.fromARGB(255, 121, 121, 121).withOpacity(0.5),
            width: 0.5,
          ),
        ),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.black),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => pageBuilder()),
          );
        },
      ),
    );
  }
}
