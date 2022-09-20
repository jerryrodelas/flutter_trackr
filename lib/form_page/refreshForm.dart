import 'package:firebase_database/ui/firebase_animated_list.dart';
//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:field_manager/srv_details.dart';
import 'package:firebase_database/firebase_database.dart';

final FirebaseDatabase database = FirebaseDatabase.instance;

class RefreshForm extends StatefulWidget {
  @override
  _RefreshFormState createState() => _RefreshFormState();
}

class _RefreshFormState extends State<RefreshForm> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  String dropdownValue = 'Commenced';
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
                    return Card(
                      color: Colors.white70,
                      child: ListTile(
                        title: Text(
                          srvDetList[index].clientName +
                              ' - ' +
                              srvDetList[index].location,
                          style: TextStyle(fontSize: 20),
                        ),
                        subtitle: Text(
                          srvDetList[index].servDate +
                              '- ' +
                              srvDetList[index].job_status,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                    );
                  }))),
    );
  }

  // ignore: non_constant_identifier_names

  // ignore: non_constant_identifier_names
  void delete_record(DataSnapshot snapshot) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirm Delete'),
            content: Text('Do you want to delete this record?'),
            actions: [
              // ignore: deprecated_member_use
              IconButton(
                icon: Icon(Icons.delete_sweep),
                iconSize: 30,
                color: Colors.indigo,
                onPressed: () {
                  var key = snapshot.key!;
                  databaseReference.child(key).remove();
                  setState(() {});
                  Navigator.of(context).pop();
                },
              ),
              // ignore: deprecated_member_use
              IconButton(
                  icon: Icon(Icons.not_interested),
                  iconSize: 30,
                  color: Colors.indigo,
                  onPressed: () {
                    Navigator.of(context).pop();
                  })
            ],
          );
        });
  }

  // ignore: non_constant_identifier_names
  void update_record(DataSnapshot snapshot) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirm Update'),
            content: Text('Do you want to update this form?'),
            actions: [
              // ignore: deprecated_member_use
              TextButton(
                child: Text('Yes'),
                onPressed: () {
                  Navigator.of(context).pop();
                  save_the_updated_form(snapshot);
                  //save the updated form
                },
              ),
              // ignore: deprecated_member_use
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('No'))
            ],
          );
        });
  }

  // ignore: non_constant_identifier_names
  void save_the_updated_form(DataSnapshot snapshot) {
    final FormState? form = formkey.currentState;
    if (form!.validate()) {
      form.save();
      form.reset();
      databaseReference.push().set(srvDet.toJson());

      update_successful(snapshot);
    }
  }

  // ignore: non_constant_identifier_names
  void update_successful(DataSnapshot snapshot) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirmation'),
            content: Text('Successfully Updated'),
            actions: [
              // ignore: deprecated_member_use
              TextButton(
                  onPressed: () {
                    var key = snapshot.key!;
                    databaseReference.child(key).remove();

                    Navigator.of(context).pop();

                    Navigator.of(context).pop();
                  },
                  child: Text('Dismiss'))
            ],
          );
        });
  }
}
