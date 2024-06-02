import 'package:campus_space/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:campus_space/pages/my_events.dart';
import 'package:campus_space/pages/profile.dart';

class LandningPage extends StatefulWidget {
  @override
  State<LandningPage> createState() => _LandningPageState();
}

class _LandningPageState extends State<LandningPage> {
  int _selectedIndex = 0;

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    HomePage(),
    MyEvents(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _pages[_selectedIndex],
        bottomNavigationBar: NavigationBar(
          indicatorColor: Colors.blue[300], //Color(0xFF0066FF),
          selectedIndex: _selectedIndex,
          onDestinationSelected: _navigateBottomBar,
          destinations: const <Widget>[
            NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
            NavigationDestination(
                icon: Icon(Icons.event_available), label: 'My Events'),
            NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ));
  }
}
