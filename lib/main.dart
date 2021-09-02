import "dart:io";
import 'package:flutter/material.dart';
import "package:path_provider/path_provider.dart";

import "utils.dart" as utils;

void main() {
  startMeUp() async {
    // Не знаю что он делает, но позволяет обратиться к PathProvider еще до запуска приложения
    WidgetsFlutterBinding.ensureInitialized();
    // Каталог документов приложения
    // Directory: '/data/user/0/com.example.flutterbook/app_flutter'
    var docsDir = await getApplicationDocumentsDirectory();
    utils.docsDir = docsDir;
    runApp(FlutterBook());
  }

  startMeUp();
}

class FlutterBook extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            title: Text("FlutterBook"),
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.date_range), text: "Appointments"),
                Tab(icon: Icon(Icons.contacts), text: "Contacts"),
                Tab(icon: Icon(Icons.note), text: "Notes"),
                Tab(icon: Icon(Icons.assignment_turned_in), text: "Tasks")
              ]
            )
          ),
          body: TabBarView(
            children: [
              Text("Tab1"),
              Text("Tab2"),
              Text("Tab3"),
              Text("Tab4")
            ],
          ),
        ),
      ),
    );
  }
}