import 'package:field_manager/widgets/button_widget.dart';
import 'package:field_manager/MenuScreen.dart';
import 'package:field_manager/srv_details.dart';

import 'package:field_manager/widgets/utils.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GetServiceDetails extends StatefulWidget {
  @override
  GetServiceDetailsState createState() => GetServiceDetailsState();
}

class GetServiceDetailsState extends State<GetServiceDetails> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  late SrvDet srvDet;
  late DatabaseReference databaseReference;
  late List<SrvDet> srvDetList;

  DateTime dateTime = DateTime.now();
  late String passTime;
  late String stat;
  String dropdownValue = 'Commenced';

  @override
  void initState() {
    super.initState();

    srvDetList = [];
    srvDet = SrvDet('', '', '', '', '', '', '');
    // srvDet.servDate = DateTime.now().toString();
    srvDet.job_status = dropdownValue;
    srvDet.servDate = DateFormat('d/M/y').format(dateTime);

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

  Widget build(BuildContext context) {
    return Form(
      key: formkey,
      child: Column(children: [
        getDatePicker(),
        TextFormField(
          initialValue: '',
          validator: (value) =>
              value!.isEmpty ? 'This field can not be empty' : null,
          onSaved: (newValue) => srvDet.clientName = newValue!,
          style: TextStyle(color: Colors.black, fontSize: 20),
          decoration: const InputDecoration(
            icon: Icon(Icons.business),
            hintText: 'Insert name',
            labelText: 'Client *',
          ),
        ),
        TextFormField(
          initialValue: '',
          validator: (value) =>
              value!.isEmpty ? 'This field can not be empty' : null,
          onSaved: (newValue) => srvDet.location = newValue!,
          style: TextStyle(color: Colors.black, fontSize: 20),
          decoration: const InputDecoration(
            icon: Icon(Icons.add_location),
            hintText: 'Insert branch',
            labelText: 'Location *',
          ),
        ),
        TextFormField(
          initialValue: '',
          validator: (value) =>
              value!.isEmpty ? 'This field can not be empty' : null,
          onSaved: (newValue) => srvDet.fault = newValue!,
          style: TextStyle(color: Colors.black, fontSize: 20),
          decoration: const InputDecoration(
            icon: Icon(Icons.add_alert_outlined),
            hintText: 'Insert description',
            labelText: 'Fault *',
          ),
        ),
        TextFormField(
          initialValue: '',
          validator: (value) =>
              value!.isEmpty ? 'This field can not be empty' : null,
          onSaved: (newValue) => srvDet.fix = newValue!,
          style: TextStyle(color: Colors.black, fontSize: 20),
          decoration: const InputDecoration(
            icon: Icon(Icons.add_task_sharp),
            hintText: 'How did you fix the problem?',
            labelText: 'Fix *',
          ),
        ),
        DropdownButton<String>(
          value: dropdownValue,
          icon: const Icon(Icons.arrow_downward),
          iconSize: 24,
          elevation: 16,
          style: const TextStyle(color: Colors.black, fontSize: 20),
          underline: Container(
            height: 2,
            color: Colors.indigo,
          ),
          onChanged: (String? newValue) {
            setState(() {
              dropdownValue = newValue!;
              srvDet.job_status = newValue;
            });
          },
          items: <String>['Commenced', 'Completed', 'Partial', 'Awaiting parts']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        SizedBox(
          height: 15,
        ),
        Padding(
          padding: const EdgeInsets.all(40.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  formConfirmation();
                }, //add details to firebase
                label: Text('+'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0),
                  ),
                  textStyle: TextStyle(fontSize: 15),
                ),
                icon: Icon(
                  Icons.receipt_long,
                  size: 25,
                ),
              )
            ],
          ),
        ),
      ]),
    );
  }

  // ignore: non_constant_identifier_names
  Widget getDatePicker() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            DateFormat(' EEE - d MMM, ' 'yyyy').format(dateTime),
            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
          ),
          ButtonWidget(
            onClicked: () => Utils.showSheet(
              context,
              child: buildDatePicker(),
              onClicked: () {
                final value = DateFormat('dMy').format(dateTime);
                passTime = value.toString();
                // Utils.showSnackBar(context, 'Selected "$passTime"');
                srvDet.servDate = passTime;
              },
            ),
          ),
        ],
      );

  Widget buildDatePicker() => SizedBox(
        height: 100,
        child: CupertinoDatePicker(
          minimumYear: 2015,
          maximumYear: DateTime.now().year,
          initialDateTime: dateTime,
          mode: CupertinoDatePickerMode.date,
          onDateTimeChanged: (dateTime) =>
              setState(() => this.dateTime = dateTime),
        ),
      );

  // ignore: non_constant_identifier_names
  void submit_data() {
    final FormState? form = formkey.currentState;
    if (form!.validate()) {
      form.save();
      form.reset();
      databaseReference.push().set(srvDet.toJson());
      submitSuccessful();
    }
  }

  void submitSuccessful() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirmation'),
            content: Text('Successfully Submitted'),
            actions: [
              // ignore: deprecated_member_use
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Navigator.of(context)
                  },
                  child: Text('Return'))
            ],
          );
        });
  }

  // ignore: unused_element
  void formConfirmation() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirm Submission'),
            content: Text('Do you want to submit this form?'),
            actions: [
              // ignore: deprecated_member_use
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    submit_data();
                  },
                  child: Text('Yes')),
              Spacer(
                flex: 5,
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
}

// class DropDownMenu extends StatefulWidget {
//   @override
//   _DropDownMenuState createState() => _DropDownMenuState();
// }

// class _DropDownMenuState extends State<DropDownMenu> {
//   final GlobalKey<FormState> formkey = GlobalKey<FormState>();

//   String dropdownValue = 'Commenced';
//   @override
//   Widget build(BuildContext context) {
//     return DropdownButton<String>(
//       value: dropdownValue,
//       icon: const Icon(Icons.arrow_downward),
//       iconSize: 24,
//       elevation: 16,
//       style: const TextStyle(color: Colors.deepPurple),
//       underline: Container(
//         height: 2,
//         color: Colors.deepPurpleAccent,
//       ),
//       onChanged: (String? newValue) {
//         setState(() {
//           dropdownValue = newValue!;
//         });
//       },
//       items: <String>['Commenced', 'Completed', 'Partial', 'Awaiting parts']
//           .map<DropdownMenuItem<String>>((String value) {
//         return DropdownMenuItem<String>(
//           value: value,
//           child: Text(value),
//         );
//       }).toList(),
//     );
//   }
// }
