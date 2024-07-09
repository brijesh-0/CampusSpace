import 'package:campus_space/pages/helpSupport.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      /*appBar: AppBar(
        title: const Text(
          'My Profile',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),*/
      body: Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
        child: ListView(
          children: <Widget>[
            const Padding(
                padding: EdgeInsets.only(left: 4.0, top: 65.0),
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
                              color:
                                  Colors.black, // Default color for 'Find Your'
                            ),
                          ),
                          TextSpan(
                            text: 'Profile',
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
            _buildSettingItem(
                Icons.person, 'Profile Settings', context, () => HelpSupport()),
            _buildSettingItem(
                Icons.history, 'Venue History', context, () => HelpSupport()),
            _buildSettingItem(Icons.notifications, 'Notifications', context,
                () => HelpSupport()),
            _buildSettingItem(
                Icons.help, 'Help and Support', context, () => HelpSupport()),
            const SizedBox(height: 140.0),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton.icon(
                onPressed: () async {
                  await _signOut(
                      context); // Call the function to sign out the user
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
            color: const Color.fromARGB(255, 121, 121, 121)
                .withOpacity(0.5), // Choose your border color
            width: 0.5, // Choose the width of the border
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
