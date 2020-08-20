import 'package:flutter/material.dart';
import 'package:reach_me/components/bottom_navbar.dart';
import 'package:reach_me/screens/home.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavBar(
        selectedIndex: currentIndex,
        onItemTapped: (value) {
          setState(() {
            currentIndex = value;
          });
        },
      ),
      body: IndexedStack(
        children: [
          HomePage(
            index: currentIndex,
          ),
        ],
        index: 0,
      ),
    );
  }
}
