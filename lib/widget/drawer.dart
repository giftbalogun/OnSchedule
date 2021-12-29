// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:todoapp/config/config.dart';
import 'package:todoapp/screens/about.dart';
import 'package:todoapp/screens/todo_list_screen.dart';
import 'package:todoapp/services/app_service.dart';
import 'package:todoapp/services/notification_service.dart';
import 'package:todoapp/utils/next_screen.dart';

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Config.appThemeColors,
        child: ListView(
          children: [
            Container(
              height: 250,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 3),
                    child: Image(
                        height: 240,
                        width: 380,
                        fit: BoxFit.contain,
                        image: AssetImage(Config.appIconp)),
                  ),
                ],
              ),
            ),
            ListTile(
              title: const Text(
                "OnSchedule",
                style: TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              leading: IconButton(
                icon: const Icon(Icons.home),
                onPressed: () {
                  nextScreenReplace(context, TodoListScreen());
                },
              ),
              onTap: () {
                nextScreenReplace(context, TodoListScreen());
              },
            ),
            const Divider(
              color: Colors.grey,
            ),
            ListTile(
              title: const Text(
                "Our Website",
                style: TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              leading: IconButton(
                icon: const Icon(Icons.link_outlined),
                onPressed: () {
                  Navigator.pop(context);
                  AppService()
                      .openLinkWithCustomTab(context, Config.websiteUrl);
                },
              ),
              onTap: () {
                Navigator.pop(context);
                AppService().openLinkWithCustomTab(context, Config.websiteUrl);
              },
            ),
            const Divider(
              color: Colors.grey,
            ),
            ListTile(
              title: Text(
                "Contact Us",
                style: TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              leading: IconButton(
                icon: Icon(Icons.account_circle),
                onPressed: () {},
              ),
              onTap: () => AppService().openEmailSupport(),
            ),
            const Divider(
              color: Colors.grey,
            ),
            ListTile(
              title: Text(
                "Developer",
                style: TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              leading: IconButton(
                icon: const Icon(Icons.contact_page),
                onPressed: () {},
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => Portfolio()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
