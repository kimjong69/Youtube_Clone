import 'package:flutter/material.dart';
import 'package:youtube_clone/pages/home_page.dart';
import 'package:youtube_clone/pages/profile_page.dart';

class BottomBar extends StatefulWidget {
  static const String routeName = 'actual-home';
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _page = 0;
  double bottomBarWidth = 42;
  double bottomBarBorderWidth = 5;

  List<Widget> pages = [const HomePage(), const ProfilePage()];

  void updatePage(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_page],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _page,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        iconSize: 28,
        onTap: updatePage,
        items: [
          //Home
          BottomNavigationBarItem(
            icon: Column(
              children: [
                SizedBox(
                  width: bottomBarWidth,
                  child: _page == 0
                      ? const Icon(
                          Icons.home,
                        )
                      : const Icon(
                          Icons.home_outlined,
                        ),
                ),
                const Text('Home'),
              ],
            ),
            label: '',
          ),
          //Account
          BottomNavigationBarItem(
            icon: Column(
              children: [
                SizedBox(
                  width: bottomBarWidth,
                  child: _page == 1
                      ? const Icon(
                          Icons.person,
                        )
                      : const Icon(
                          Icons.person_outline_outlined,
                        ),
                ),
                const Text('Profile'),
              ],
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}
