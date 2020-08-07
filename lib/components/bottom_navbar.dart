import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function onItemTapped;
  BottomNavBar({@required this.selectedIndex,@required this.onItemTapped});
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text(''),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          title: Text(''),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_box),
          title: Text(''),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications_active),
          title: Text(''),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          title: Text(''),
        ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: Colors.blue[800],
      unselectedItemColor: Colors.grey[800],
      onTap: onItemTapped,

    );
  }
}




