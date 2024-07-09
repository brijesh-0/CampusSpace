import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'pages/landing.dart';
import 'pages/sign_in_screen.dart';
import 'utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
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
