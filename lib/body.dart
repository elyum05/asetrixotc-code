import 'package:asetrix_app/add_post.dart';
import 'package:asetrix_app/home_screen.dart';
import 'package:asetrix_app/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class Body extends StatefulWidget {
  Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(7, 7, 7, 1),
      body: PersistentTabView(
        context,
        screens: _screens(),
        decoration:
            NavBarDecoration(border: Border.all(color: Colors.transparent)),
        items: _items(),
        resizeToAvoidBottomInset: true,
        navBarHeight: 75,
        navBarStyle: NavBarStyle.style12,
        backgroundColor: Color.fromRGBO(15, 15, 21, 1),
      ),
    );
  }

  List<Widget> _screens() {
    return [HomeScreen(), AddPost(), Profile()];
  }

  List<PersistentBottomNavBarItem> _items() {
    return [
      PersistentBottomNavBarItem(
          icon: Icon(CupertinoIcons.home),
          title: 'Home',
          activeColorPrimary: Colors.white,
          inactiveColorPrimary: Color.fromRGBO(37, 37, 37, 1)),
      PersistentBottomNavBarItem(
          icon: Icon(Icons.add),
          title: 'Create post',
          activeColorPrimary: Colors.white,
          inactiveColorPrimary: Color.fromRGBO(37, 37, 37, 1)),
      PersistentBottomNavBarItem(
          icon: Icon(CupertinoIcons.profile_circled),
          title: 'Profile',
          activeColorPrimary: Colors.white,
          inactiveColorPrimary: Color.fromRGBO(37, 37, 37, 1)),
    ];
  }
}
