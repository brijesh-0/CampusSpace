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

  // Print the FCM token for testing purposes
  String? token = await messaging.getToken();
  print('FCM Token: $token');

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
