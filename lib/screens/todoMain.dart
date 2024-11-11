import 'package:flutter/material.dart';
import 'package:testudy/configs/appTheme.dart';

import '../class/todoItem.dart';

class TodoMain extends StatefulWidget {
  const TodoMain({Key? key}) : super(key: key);

  @override
  _TodoMainState createState() => _TodoMainState();
}

class _TodoMainState extends State<TodoMain> {
  //finalは一時的にUIを更新するためのもの
  List<TodoItem> _todoItems = [
    TodoItem(
      title: '数学ワーク',
      description: '',
      subject: 'Math',
      endDate: DateTime.now(),
      isDone: false,
    ),
    TodoItem(
      title: '英語ワーク',
      description: 'zoomで確認',
      subject: 'Eng',
      endDate: DateTime.now(),
      isDone: false,
    ),
    TodoItem(
      title: '英単語',
      description: '1000~1500',
      subject: 'Eng',
      endDate: DateTime.now(),
      isDone: false,
    ),
  ];

  List<TodoItem> DoneItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.check_box,
                  size: 30,
                ),
                SizedBox(width: 30),
                Text('Todo', style: TextStyle(fontSize: 25)),
              ],
            ),
            SizedBox(height: 5),
          ],
        ),
        shape: const Border(
          bottom: BorderSide(
            color: Color(0xFFCCCCCC),
            width: 1.5,
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: _todoItems.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 5,
                  shadowColor: Colors.transparent,
                  color: primaryColor,
                  child: ListTile(
                    title: Text(
                      _todoItems[index].title,
                      style: TextStyle(
                        decoration: _todoItems[index].isDone
                            ? TextDecoration.lineThrough
                            : null,
                        fontSize: 20,
                      ),
                    ),
                    subtitle: _todoItems[index].description != ""
                        ? Text(
                      _todoItems[index].description,
                      style: TextStyle(
                        decoration: _todoItems[index].isDone
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    )
                        : null,
                    leading: Transform.scale(
                      scale: 1.3,
                      child: Checkbox(
                        value: _todoItems[index].isDone,
                        //fillColor: MaterialStateProperty.all(primaryColor),
                        checkColor: primaryColor,
                        onChanged: (bool? value) {
                          setState(() {
                            _todoItems[index].isDone = value!;
                          });
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
