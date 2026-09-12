import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:steady_just_study/main.dart';
import 'package:steady_just_study/screens/notificationsTest.dart';
import 'package:steady_just_study/screens/profile_screen.dart';
import 'package:steady_just_study/screens/study_screen.dart';
import 'package:steady_just_study/screens/tasks_list.dart';
import 'package:steady_just_study/widgets/app_drawer.dart';

class bottom_navbar extends StatefulWidget {
  @override
  State<bottom_navbar> createState() => _bottom_navbarState();
}

class _bottom_navbarState extends State<bottom_navbar> {
  int selectedIndex = 0;

  List<Widget> screens = [MainScreen(), TasksList(), ProfileScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(
        onTabSelect: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
      appBar: AppBar(
        backgroundColor: Color(0xFFFFFFFF),
        title: const Text(
          'Steady Just Study',
          style: TextStyle(fontFamily: "Kode Mono"),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(Notificationstest.routeName);
            },
            icon: Icon(Icons.notifications),
          ),
        ],
      ),

      body: screens[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Color(0xFF7BB1D2),
        unselectedItemColor: Color(0xFF000000),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Tasks'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
    );
  }
}
