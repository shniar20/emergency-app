import 'package:emergency/pages/category.dart';
import 'package:emergency/pages/location.dart';
import 'package:emergency/pages/posts.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class NavigationBottom extends StatefulWidget {
  const NavigationBottom({Key? key}) : super(key: key);

  @override
  State<NavigationBottom> createState() => _NavigationBottomState();
}

class _NavigationBottomState extends State<NavigationBottom> {
  int index = 0;
  List<Widget> page = [const Category(), const Posts(), const Location()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: page[index],
      bottomNavigationBar: CurvedNavigationBar(
        index: index,
        backgroundColor: Colors.white,
        color: const Color.fromARGB(255, 33, 67, 127),
        items: [
          const Icon(
            Icons.home,
            size: 30,
            color: Colors.white,
          ),
          const Icon(Icons.view_agenda, size: 30, color: Colors.white),
          Image.asset(
            'assets/images/location.png',
            height: 40.0,
            width: 40.0,
            color: Colors.white,
          ),
        ],
        onTap: (index) {
          setState(() {
            this.index = index;
          });
        },
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: index,
      //   onTap: (value) => setState(() => index = value),
      //   items: [
      //     BottomNavigationBarItem(
      //       label: "Home",
      //       icon: Icon(Icons.home),
      //     ),
      //     BottomNavigationBarItem(
      //       label: "Posts",
      //       icon: Icon(Icons.post_add),
      //     ),
      //     BottomNavigationBarItem(
      //       label: "Map",
      //       icon: Icon(Icons.location_pin),
      //     ),
      //   ],
      // ),
    );
  }
}
