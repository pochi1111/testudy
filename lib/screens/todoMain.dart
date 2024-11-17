import 'package:flutter/material.dart';
import 'package:testudy/configs/appTheme.dart';
import 'package:testudy/screens/addTodo.dart';

import '../class/todoItem.dart';

class TodoMain extends StatefulWidget {
  const TodoMain({Key? key}) : super(key: key);

  @override
  _TodoMainState createState() => _TodoMainState();
}

class _TodoMainState extends State<TodoMain> {
  final todoListKey = GlobalKey<AnimatedListState>();
  final doneListKey = GlobalKey<AnimatedListState>();
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
                  SizedBox(width: 20),
                  AppBarTitle('Todo'),
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10),
              AnimatedList(
                key: todoListKey,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                initialItemCount: _todoItems.length,
                itemBuilder: (context, index, animation) {
                  return SizeTransition(
                    sizeFactor: animation,
                    child: Card(
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
                              changeTodoItemState(index,_todoItems[index].isDone);
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 10),
              ExpansionTile(
                title: Text(
                  '完了済み',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                children: [
                  AnimatedList(
                    key: doneListKey,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    initialItemCount: DoneItems.length,
                    itemBuilder: (context, index ,animation) {
                      return SizeTransition(
                        sizeFactor: animation,
                        child: Card(
                          elevation: 5,
                          shadowColor: Colors.transparent,
                          color: primaryColor,
                          child: ListTile(
                            title: Text(
                              DoneItems[index].title,
                              style: TextStyle(
                                decoration: DoneItems[index].isDone
                                    ? TextDecoration.lineThrough
                                    : null,
                                fontSize: 20,
                              ),
                            ),
                            subtitle: DoneItems[index].description != ""
                                ? Text(
                                    DoneItems[index].description,
                                    style: TextStyle(
                                      decoration: DoneItems[index].isDone
                                          ? TextDecoration.lineThrough
                                          : null,
                                    ),
                                  )
                                : null,
                            leading: Transform.scale(
                              scale: 1.3,
                              child: Checkbox(
                                value: DoneItems[index].isDone,
                                //fillColor: MaterialStateProperty.all(primaryColor),
                                checkColor: primaryColor,
                                onChanged: (bool? value) {
                                  changeTodoItemState(index,DoneItems[index].isDone);
                                },
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddTodo(),
              ),
            );
          },
          child: Icon(Icons.add),
        ),
    );
  }

  void changeTodoItemState(int index,bool value) {
    if (value) {
      //未完了にする
      DoneItems[index].isDone = !value;
      _todoItems.insert(0,DoneItems[index]);
      todoListKey.currentState?.insertItem(0);
      TodoItem removedDoneItem = DoneItems[index];
      DoneItems.removeAt(index);
      doneListKey.currentState?.removeItem(index, (context, animation) => tmpCard(removedDoneItem,animation));
    }else{
      //完了にする
      _todoItems[index].isDone = !value;
      DoneItems.insert(0, _todoItems[index]);
      doneListKey.currentState?.insertItem(0);
      TodoItem removedTodoItem = _todoItems[index];
      _todoItems.removeAt(index);
      todoListKey.currentState?.removeItem(index, (context, animation) => tmpCard(removedTodoItem,animation));
    }
    setState((){});
  }

  SizeTransition tmpCard (TodoItem item,Animation<double> animation){
    return SizeTransition(
      sizeFactor: animation,
      child: Card(
          shadowColor: Colors.transparent,
          color: primaryColor,
          child: ListTile(
            title: Text(
              item.title,
              style: TextStyle(
                decoration: item.isDone
                    ? TextDecoration.lineThrough
                    : null,
                fontSize: 20,
              ),
            ),
            subtitle: item.description != ""
                ? Text(
              item.description,
              style: TextStyle(
                decoration: item.isDone
                    ? TextDecoration.lineThrough
                    : null,
              ),
            )
                : null,
            leading: Transform.scale(
              scale: 1.3,
              child: Checkbox(
                tristate: true,
                value: item.isDone,
                //fillColor: MaterialStateProperty.all(primaryColor),
                checkColor: primaryColor,
                onChanged: (bool? value) {},
              ),
            ),
          )
      ),
    );
  }
}
