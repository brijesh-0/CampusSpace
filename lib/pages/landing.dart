import 'package:campus_space/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:campus_space/pages/my_events.dart';
import 'package:campus_space/pages/profile.dart';
import 'package:campus_space/utils/page_transition.dart';

class LandingPage extends StatefulWidget {
  static const routeName = '/landing';

  final String displayName;
  final String photoUrl;
  final String email;
  final Future<void> Function() onSignOut;

  const LandingPage({
    required this.displayName,
    required this.photoUrl,
    required this.onSignOut,
    required this.email,
  });

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int _selectedIndex = 0;
  //final PageController _pageController = PageController();

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomePage(
        displayName: widget.displayName,
        clubEmail: widget.email,
        photoUrl: widget.photoUrl,
      ),
      MyEvents(
        photoUrl: widget.photoUrl,
        email: widget.email,
      ),
      Profile(
        displayName: widget.displayName,
        photoUrl: widget.photoUrl,
        onSignOut: widget.onSignOut,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Stack(
        children: [
          PageTransition(
            child: _pages[_selectedIndex],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.all(18.0), // Margin for floating effect
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(55, 0, 0, 0),
                    blurRadius: 15,
                    spreadRadius: 3,
                  ),
                ],
              ),
              height: 70.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  _buildIconButton(Icons.home, Icons.home_outlined, 0),
                  _buildIconButton(
                      Icons.event_available, Icons.event_available_outlined, 1),
                  _buildIconButton(Icons.person, Icons.person_outline, 2),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(
      IconData selectedIcon, IconData unselectedIcon, int index) {
    return Container(
      decoration: BoxDecoration(
        color: _selectedIndex == index
            ? const Color.fromARGB(0, 0, 102, 255)
            : Colors.transparent,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(_selectedIndex == index ? selectedIcon : unselectedIcon,
            color: _selectedIndex == index
                ? const Color(0xFF0066FF)
                : const Color.fromARGB(255, 0, 0, 0)),
        onPressed: () => _navigateBottomBar(index),
        color: _selectedIndex == index
            ? const Color.fromARGB(255, 0, 55, 255)
            : const Color.fromARGB(255, 0, 0, 0),
        padding: const EdgeInsets.all(16.0),
      ),
    );
  }
}
