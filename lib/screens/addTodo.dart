import 'package:flutter/material.dart';
import 'package:testudy/configs/appTheme.dart';

import '../class/todoItem.dart';

class AddTodo extends StatefulWidget {
  const AddTodo({Key? key}) : super(key: key);

  @override
  _AddTodoState createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle("Todoを追加する"),
        shape: const Border(
          bottom: BorderSide(
            color: Color(0xFFCCCCCC),
            width: 1.5,
          ),
        ),
      ),
      body: Center(),
    );
  }
}