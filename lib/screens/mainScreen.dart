import 'package:flutter/material.dart';
import 'package:testudy/screens/studyTime.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>{
  int currentIndex = 0;
  late List<Widget> _children;
  @override
  void initState(){
    super.initState();
    _children = [
      PlaceholderWidget(),
      StudyTime(),
      PlaceholderWidget(),
      PlaceholderWidget(),
    ];
  }

  void onTabTapped(int index){
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[currentIndex],
      bottomNavigationBar:BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: onTabTapped,
        unselectedLabelStyle: const TextStyle(
          fontSize: 0,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time_filled),
            label: 'StudyTime',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Tests',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

Widget PlaceholderWidget(){
  return const Center(
    child: Text("Placeholder Widget"),
  );
}