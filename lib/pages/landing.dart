import 'package:campus_space/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:campus_space/pages/my_events.dart';
import 'package:campus_space/pages/profile.dart';

class LandingPage extends StatefulWidget {
  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int _selectedIndex = 0;

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    const HomePage(),
    const MyEvents(),
    const Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.white, Color(0xFFC5E7FF)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.6, 1.0])),
            child: _pages[_selectedIndex]),
        bottomNavigationBar: NavigationBar(
          indicatorColor: const Color.fromARGB(196, 0, 102, 255),
          height: 75.0,
          backgroundColor:
              const Color.fromARGB(226, 205, 235, 255), //Color(0xFF0066FF),
          selectedIndex: _selectedIndex,
          onDestinationSelected: _navigateBottomBar,
          destinations: <Widget>[
            NavigationDestination(
                icon: _selectedIndex == 0
                    ? const Icon(Icons.home)
                    : const Icon(Icons.home_outlined),
                label: 'Home'),
            NavigationDestination(
                icon: _selectedIndex == 1
                    ? const Icon(Icons.event_available)
                    : const Icon(Icons.event_available_outlined),
                label: 'My Events'),
            NavigationDestination(
                icon: _selectedIndex == 2
                    ? const Icon(Icons.person)
                    : const Icon(Icons.person_outline),
                label: 'Profile'),
          ],
        ));
  }
}
