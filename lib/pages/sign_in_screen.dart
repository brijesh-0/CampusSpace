import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'landing.dart';
import 'package:campus_space/services/authlevel_service.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreen createState() => _SignInScreen();
}

class _SignInScreen extends State<SignInScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _handleSignIn(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return; // The user canceled the sign-in
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        //if (user.email != null && user.email!.endsWith('@bmsce.ac.in')) {
        if (user.email != null &&
            user.email!.endsWith('@bmsce.ac.in') &&
            await checkEmail(
                user.email.toString(), user.displayName.toString())) {
          //await checkEmail(user.email.toString());
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LandingPage(
                displayName: user.displayName ?? 'No Name',
                photoUrl: user.photoURL ?? '',
                onSignOut: _signOut,
                email: user.email ?? "nomail",
              ),
            ),
          );
        } else {
          await _auth.signOut();
          await _googleSignIn.signOut();
          _showCustomSnackbar(context, 'Invalid College Email');
        }
      }
    } catch (error) {
      print(error);
      _showCustomSnackbar(context, 'Failed to sign in with Google: $error');
    }
  }

  Future<void> _signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  void _showCustomSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 200, 40, 28),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: Duration(seconds: 3),
      ),
    );
  }

  bool _firstTime = true;
  @override
  void initState() {
    super.initState();
    // Simulate a delay for first time app opening
    Future.delayed(const Duration(milliseconds: 700), () {
      setState(() {
        _firstTime = false; // Set to false after delay to trigger animation
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.lightBlue[100]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/CampusSpaceLogo4.png', // Make sure to add your logo image to the assets folder and update the path
                  height: 180,
                ),
                AnimatedOpacity(
                    opacity:
                        _firstTime ? 0.0 : 1.0, // Fade in if not the first time
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    child: Column(children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Campus',
                              style: GoogleFonts.poppins(
                                fontSize: 44.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: 'Space',
                              style: GoogleFonts.poppins(
                                fontSize: 46.0,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF0066FF),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ])),
                /*Text(
                  "Simplifying Campus Reservations :)",
                  style: GoogleFonts.poppins(
                    fontSize: 14.0,
                    height: 1.0,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(
                        255, 0, 0, 0), // Default color for 'Campus'
                  ),
                ),*/
                const SizedBox(height: 80),
                const Text(
                  'Let\'s get you signed in!',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    side: const BorderSide(color: Colors.grey),
                  ),
                  icon: Image.asset(
                    'assets/google-logo.png', // Make sure to add the Google logo image to the assets folder and update the path
                    height: 24,
                  ),
                  label: const Text('Sign in with Google'),
                  onPressed: () => _handleSignIn(
                      context), // Pass the context to _handleSignIn
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
