import 'package:campus_space/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:campus_space/pages/my_events.dart';
import 'package:campus_space/pages/profile.dart';

class LandingPage extends StatefulWidget {
  static const routeName = '/landing';

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
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
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Container(
        /*decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 218, 238, 255),
              Color.fromARGB(255, 218, 238, 255)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.6, 1.0],
          ),
        ),*/
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          children: _pages,
        ),
      ),
      bottomNavigationBar: NavigationBar(
        indicatorColor: Color(0xFF0066FF),
        height: 75.0,
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        selectedIndex: _selectedIndex,
        onDestinationSelected: _navigateBottomBar,
        destinations: <Widget>[
          NavigationDestination(
            icon: _selectedIndex == 0
                ? const Icon(
                    Icons.home,
                    color: Color.fromRGBO(255, 255, 255, 1),
                  )
                : const Icon(
                    Icons.home_outlined,
                  ),
            label: 'Home',
          ),
          NavigationDestination(
            icon: _selectedIndex == 1
                ? const Icon(
                    Icons.event_available,
                    color: Color.fromRGBO(255, 255, 255, 1),
                  )
                : const Icon(Icons.event_available_outlined),
            label: 'My Events',
          ),
          NavigationDestination(
            icon: _selectedIndex == 2
                ? const Icon(
                    Icons.person,
                    color: Color.fromRGBO(255, 255, 255, 1),
                  )
                : const Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
