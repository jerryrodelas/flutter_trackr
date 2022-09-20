import 'package:field_manager/get_service_det.dart';
//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddServicePage extends StatefulWidget {
  AddServicePage();

  AddServicePageState createState() => AddServicePageState();
}

class AddServicePageState extends State<AddServicePage> {
  @override
  Widget build(BuildContext context) => Scaffold(
          body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              GetServiceDetails(), //input details page - get_service_det.dart
            ],
          ),
        ),
      ));
}
