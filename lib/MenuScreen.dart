import 'package:field_manager/SignOut.dart';
import 'package:field_manager/form_page/SearchForm.dart';
import 'package:field_manager/form_page/refreshForm.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:field_manager/form_page/add_service.dart';

// import 'package:field_manager/form_page/show_service.dart';
//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'widgets/tabbar_widget.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MenuScreen(
    email: '',
  ));
}

class MenuScreen extends StatelessWidget {
  final String? email;
  static final String title = 'Cupertino Date Picker';
  MenuScreen({required this.email});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData(primarySwatch: Colors.indigo),
        home: MainPage(),
      );
}

final FirebaseDatabase database = FirebaseDatabase.instance;

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) => TabBarWidget(
        title: 'Service Tracker',
        tabs: [
          Tab(icon: Icon(Icons.search), text: 'Search'),
          Tab(icon: Icon(Icons.add_task_outlined), text: 'Add'),
          Tab(icon: Icon(Icons.refresh), text: 'Refresh'),
          // Tab(icon: Icon(Icons.analytics_outlined), text: 'Delete/Edit'),
          Tab(icon: Icon(Icons.exit_to_app), text: 'Sign Out'),

          // Tab(icon: Icon(Icons.more_horiz_outlined), text: 'Custom'),
        ],
        children: [
          SearchForm(),
          AddServicePage(),
          RefreshForm(),
          // ShowForm(),
          SignOut(),
        ],
      );
}
