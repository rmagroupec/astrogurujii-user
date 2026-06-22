import 'package:flutter/material.dart';

import '../homeScreen/Home.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    Home(),
    Text('Search Page',
        style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
    Text('Profile Page',
        style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Image.asset('assets/d_icons/new_home_icon.png'),
                activeIcon: Image.asset('assets/d_icons/active_home_icon.png'),
                label: 'Home'),
            BottomNavigationBarItem(
                icon: Image.asset('assets/d_icons/chat_icon.png'),
                activeIcon: Image.asset('assets/d_icons/active_chat_icon.png'),
                label: 'Chat'),
            BottomNavigationBarItem(
                icon: Image.asset('assets/d_icons/chat_icon.png'),
                activeIcon: Image.asset('assets/d_icons/live_new.png'),
                label: 'Video Call'),
            BottomNavigationBarItem(
                icon: Image.asset('assets/d_icons/new_call_icon.png'),
                activeIcon: Image.asset('assets/d_icons/active_call_icon.png'),
                label: 'Call'),
            BottomNavigationBarItem(
                icon: Image.asset('assets/d_icons/pooja_icon.png'),
                activeIcon: Image.asset('assets/d_icons/active_pooja_icon.png'),
                label: 'Pooja//nMandir'),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.black,
          iconSize: 40,
          onTap: _onItemTapped,
          elevation: 5),
    );
  }
}
