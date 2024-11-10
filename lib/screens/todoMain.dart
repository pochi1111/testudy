import 'package:flutter/material.dart';

import '../class/todoItem.dart';

class TodoMain extends StatefulWidget {
  const TodoMain({Key? key}) : super(key: key);

  @override
  _TodoMainState createState() => _TodoMainState();
}

class _TodoMainState extends State<TodoMain> {
  //finalは一時的にUIを更新するためのもの
  final List<TodoItem> _todoItems = [
    TodoItem(
      title: '数学ワーク',
      description: '',
      subject: 'Math',
      endDate: DateTime.now(),
      isDone: false,
    ),
    TodoItem(
      title: '英語ワーク',
      description: '',
      subject: 'Eng',
      endDate: DateTime.now(),
      isDone: false,
    ),
    TodoItem(
      title: '英単語',
      description: '',
      subject: 'Eng',
      endDate: DateTime.now(),
      isDone: false,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.check_box,size: 30,),
            SizedBox(width: 30),
            Text('Todo',style: TextStyle(fontSize:25)),
          ],
        ),
      ),
      body: Column(

      ),
    );
  }
}