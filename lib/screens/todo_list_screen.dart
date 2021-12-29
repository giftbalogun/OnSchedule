// ignore_for_file: use_key_in_widget_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/config/config.dart';
import 'package:todoapp/helpers/database_helper.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/screens/add_task_screen.dart';
import 'package:todoapp/services/notification_service.dart';
import 'package:todoapp/widget/drawer.dart';

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  Future<List<Task>>? _taskList;
  final DateFormat _dateFormatter = DateFormat('MMM dd, yyyy');

  @override
  void initState() {
    super.initState();
    Provider.of<NotificationService>(context, listen: false).initNotification();
    _showNotificationsAfterSecond();
    _updateTaskList();
  }

  void _showNotificationsAfterSecond() async {
    await NotificationService().ReminderNotifications();
  }

  _updateTaskList() {
    setState(() {
      _taskList = DatabaseHelper.instance.getTaskList();
    });
  }

  Widget _buildTask(Task task) {
    return Padding(
      padding: EdgeInsets.only(left: 5),
      child: Column(
        children: [
          ListTile(
            title: Text(
              task.title!,
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  decoration: task.status == 0
                      ? TextDecoration.none
                      : TextDecoration.lineThrough),
            ),
            subtitle: Text(
              '${_dateFormatter.format(task.date!)} * ${task.priority}',
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  decoration: task.status == 0
                      ? TextDecoration.none
                      : TextDecoration.lineThrough),
            ),
            trailing: Checkbox(
              onChanged: (value) {
                task.status = value! ? 1 : 0;
                DatabaseHelper.instance.updateTask(task);
                _updateTaskList();
              },
              activeColor: Config.appThemeColors,
              value: task.status == 1 ? true : false,
            ),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => AddTaskScreen(
                        updateTaskList: _updateTaskList, task: task))),
          ),
          const Divider()
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(
        'All Schedules',
        style: TextStyle(
            color: Config.appThemeColors,
            fontSize: 30,
            fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      actions: [
        IconButton(
          icon: Image.asset(
            'images/logot.png',
            height: 50,
          ),
          onPressed: null,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      drawer: NavDrawer(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Config.appThemeColors,
        onPressed: () => {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddTaskScreen(updateTaskList: _updateTaskList),
            ),
          )
        },
        child: Icon(Icons.add),
      ),
      backgroundColor: Colors.grey[800],
      body: FutureBuilder(
        future: _taskList,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final int? completedTaskCount = (snapshot.data as List<Task>)
              .where((Task task) => task.status == 1)
              .toList()
              .length;

          return ListView.builder(
            padding: const EdgeInsets.all(25),
            itemCount: 1 + (snapshot.data as List<Task>).length,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '',
                        style: TextStyle(
                            color: Config.appThemeColors,
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ),
                      Divider(),
                      SizedBox(height: 15),
                      Text(
                        'Completed $completedTaskCount of ${(snapshot.data as List<Task>).length}',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600),
                      ),
                      Divider()
                    ],
                  ),
                );
              }
              return _buildTask((snapshot.data as List<Task>)[index - 1]);
            },
          );
        },
      ),
    );
  }
}
