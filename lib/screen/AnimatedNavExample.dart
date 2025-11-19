import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:team1/screen/cat.dart';
import 'package:team1/screen/home.dart';
import 'package:team1/screen/pro1.dart';
import 'package:team1/screen/profail.dart';
import '../features/product_management/presentation/pages/product_listing_screen.dart';

class AnimatedNavExample extends StatefulWidget {
  @override
  State<AnimatedNavExample> createState() => _AnimatedNavExampleState();
}

class _AnimatedNavExampleState extends State<AnimatedNavExample> {
  int _bottomNavIndex = 0;

  final iconList = <IconData>[
    Icons.home,
    Icons.production_quantity_limits,
    Icons.gif_box,
    Icons.person,
  ];

  final List<Widget> screens = [
    Home(),
    Pro1(),
    AllCategoriesScreen(),
    ProfileScreen(),
  ];

  final List<Color> activeColors = [
    Color(0xFF129AA6),
    Color(0xFF129AA6),
    Color(0xFF129AA6),
    Color(0xFF129AA6),

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_bottomNavIndex],

      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Color(0xFF129AA6), // لون الخلفية
        child: Icon(
          Icons.home,
          color: Colors.black, // لون الأيقونة
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        itemCount: iconList.length,
        tabBuilder: (int index, bool isActive) {
          return Icon(
            iconList[index],
            size: 28,
            color: isActive ? activeColors[index] : Colors.grey,
          );
        },
        activeIndex: _bottomNavIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.verySmoothEdge,
        leftCornerRadius: 32,
        rightCornerRadius: 32,
        onTap: (index) => setState(() => _bottomNavIndex = index),
      ),
    );
  }
}
