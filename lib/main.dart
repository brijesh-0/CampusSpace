import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'pages/landing.dart';
import 'pages/sign_in_screen.dart';
import 'utils/theme.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  /*String? token = await messaging.getToken();
  if (token != null) {
    print('FCM Token: $token');
    await saveTokenToDatabase(token);
  } else {
    print("NO TOKEN!");
  }
  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
    print('FCM Token Refreshed: $newToken');
    await saveTokenToDatabase(newToken);
  });*/

  runApp(const MyApp());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  saveNotification(message);
}

Future<void> saveNotification(RemoteMessage message) async {
  final user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    await FirebaseFirestore.instance.collection('notifications').add({
      'userId': user.uid,
      'title': message.notification?.title ?? 'No Title',
      'body': message.notification?.body ?? 'No Body',
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      saveNotification(message);
      // You can show a local notification here if needed
      print('Received a message while in the foreground!');
      print('Message data: ${message.data}');
      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });

    return MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      home: AuthGate(),
      onGenerateRoute: (settings) {
        if (settings.name == LandingPage.routeName) {
          final args = settings.arguments as Map<String, String>;
          return MaterialPageRoute(
            builder: (context) => LandingPage(
              displayName: args['displayName']!,
              photoUrl: args['photoUrl']!,
              onSignOut: args['onSignOut'] as Future<void> Function(),
              email: args['email']!,
            ),
          );
        }
        return null; // Let `onUnknownRoute` handle this behavior.
      },
    );
  }
}

class AuthGate extends StatelessWidget {
  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> _saveTokenToDatabase(User user) async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        // Query Firestore to find the document where the user's email exists
        QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection('clubs')
            .where('Email', isEqualTo: user.email)
            .get();

        if (snapshot.docs.isNotEmpty) {
          // If a document exists, update the fcmToken
          DocumentReference userDocRef = snapshot.docs.first.reference;
          await userDocRef.update({'fcmToken': token});

          print('FCM Token updated successfully for user: ${user.email}');
        }
      }
    } catch (e) {
      print('Failed to save FCM token: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasData) {
          User? user = snapshot.data;

          if (user != null) {
            _saveTokenToDatabase(user); // Save FCM token after login
          }
          return LandingPage(
            displayName: user?.displayName ?? 'No Name',
            photoUrl: user?.photoURL ?? '',
            email: user?.email ?? '',
            onSignOut: _signOut,
          );
        } else {
          return const SignInScreen();
        }
      },
    );
  }
}
