import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function onItemTapped;

  BottomNavBar({@required this.selectedIndex, @required this.onItemTapped});
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      showUnselectedLabels: true,
      selectedIconTheme: IconThemeData(size: 30),
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.home),
          ),
          title: SizedBox.shrink(),
        ),
        BottomNavigationBarItem(
          icon: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.search),
          ),
          title: SizedBox.shrink(),
        ),
        BottomNavigationBarItem(
          icon: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.add_box),
          ),
          title: SizedBox.shrink(),
        ),
        BottomNavigationBarItem(
          icon: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.notifications_active),
          ),
          title: SizedBox.shrink(),
        ),
        BottomNavigationBarItem(
          icon: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.account_circle),
          ),
          title: SizedBox.shrink(),
        ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: Colors.blue[800],
      unselectedItemColor: Colors.grey[800],
      onTap: onItemTapped,
    );
  }
}
