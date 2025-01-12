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
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'ホーム',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time_filled),
            label: '勉強時間',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'テスト',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'プロフィール',
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