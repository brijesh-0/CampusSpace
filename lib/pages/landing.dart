import 'package:campus_space/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:campus_space/pages/my_events.dart';
import 'package:campus_space/pages/profile.dart';

class LandingPage extends StatefulWidget {
  static const routeName = '/landing';

  final String displayName;
  final String photoUrl;
  final Future<void> Function() onSignOut;

  LandingPage({
    required this.displayName,
    required this.photoUrl,
    required this.onSignOut,
  });

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

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomePage(
        displayName: widget.displayName,
        photoUrl: widget.photoUrl,
      ),
      MyEvents(
        photoUrl: widget.photoUrl,
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
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Stack(
        children: [
          Container(
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
    ); /*NavigationBar(
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
      ),*/
  }

  Widget _buildIconButton(
      IconData selectedIcon, IconData unselectedIcon, int index) {
    return Container(
      decoration: BoxDecoration(
        color: _selectedIndex == index
            ? Color.fromARGB(0, 0, 102, 255)
            : Colors.transparent,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(_selectedIndex == index ? selectedIcon : unselectedIcon,
            color: _selectedIndex == index
                ? Color(0xFF0066FF)
                : Color.fromARGB(255, 0, 0, 0)),
        onPressed: () => _navigateBottomBar(index),
        color: _selectedIndex == index
            ? Color.fromARGB(255, 0, 55, 255)
            : Color.fromARGB(255, 0, 0, 0),
        padding: EdgeInsets.all(16.0),
      ),
    );
  }
}
