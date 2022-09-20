import 'package:firebase_database/ui/firebase_animated_list.dart';
//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:field_manager/srv_details.dart';
import 'package:firebase_database/firebase_database.dart';
//import 'package:flutter/rendering.dart';

//import 'package:intl/intl.dart';

final FirebaseDatabase database = FirebaseDatabase.instance;

class ShowForm extends StatefulWidget {
  @override
  _ShowFormState createState() => _ShowFormState();
}

class _ShowFormState extends State<ShowForm> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  // ignore: non_constant_identifier_names
  bool job_complete = false;

  late SrvDet srvDet;
  late DatabaseReference databaseReference;
  late List<SrvDet> srvDetList;
  late String passTime;
  DateTime currentDate = DateTime.now();

  @override
  void initState() {
    super.initState();

    srvDetList = [];
    srvDet = SrvDet('', '', '', '', '', '', '');

    final FirebaseDatabase database = FirebaseDatabase.instance;

    databaseReference = database.reference().child('job_info');
    databaseReference.onChildAdded.listen(_onEntryAdded);
    databaseReference.onChildChanged.listen(_onEntryChanged);
  }

  void _onEntryAdded(Event event) async {
    setState(() {
      srvDetList.add(SrvDet.fromSnapshot((event.snapshot)));
    });
  }

  void _onEntryChanged(Event event) async {
    var oldEntry = srvDetList.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });
    setState(() {
      srvDetList[srvDetList.indexOf(oldEntry)] =
          SrvDet.fromSnapshot((event.snapshot));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Flexible(
                child: FirebaseAnimatedList(
                    query: databaseReference,
                    itemBuilder: (BuildContext context, DataSnapshot snapshot,
                        Animation<double> animation, int index) {
                      return Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.teal)),
                        child: CheckboxListTile(
                          title: Text(
                            srvDetList[index].clientName,
                            style: TextStyle(fontSize: 20),
                          ),
                          subtitle: Text(
                            srvDetList[index].location,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          secondary: const Icon(Icons.web),
                          activeColor: Colors.red,
                          checkColor: Colors.yellow,
                          selected: job_complete,
                          value: job_complete,
                          onChanged: (bool? value) {
                            setState(() {
                              job_complete = value!;
                            });
                          },
                        ),
                      );
                    }))));
  }
}
