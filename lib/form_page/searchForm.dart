import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

import '../srv_details.dart';

class SearchForm extends StatefulWidget {
  @override
  SearchFormState createState() => SearchFormState();
}

class SearchFormState extends State<SearchForm> {
  late SrvDet srvDet;
  late DatabaseReference databaseReference;
  late List<SrvDet> srvDetList;
  TextEditingController controller = new TextEditingController();
  late String filter;
  late String passTime;
  late String dropdownValue = 'Commenced';

  DateTime currentDate = DateTime.now();
  static const statusTypes = [
    'Commenced',
    'Completed',
    'Partial',
    'Awaiting parts'
  ];
  late String newValue;

  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final FirebaseDatabase database = FirebaseDatabase
        .instance; //Rather then just writing FirebaseDatabase(), get the instance.

    srvDetList = [];
    filter = "";
    srvDet = SrvDet('', '', '', '', '', '', '');
    srvDet.job_status = dropdownValue;

    databaseReference = database.reference().child('job_info');
    databaseReference.onChildAdded.listen(_onEntryAdded);
    databaseReference.onChildChanged.listen(_onEntryChanged);
    controller.addListener(() {
      setState(() {
        filter = controller.text;
      });
    });
  }

  _onEntryAdded(Event event) {
    setState(() {
      srvDetList.add(SrvDet.fromSnapshot(event.snapshot));
    });
  }

  _onEntryChanged(Event event) {
    var oldEntry = srvDetList.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });
    setState(() {
      srvDetList[srvDetList.indexOf(oldEntry)] =
          SrvDet.fromSnapshot((event.snapshot));
    });
  }

  void handleSubmit() {
    var formKey;
    final FormState? form = formKey.currentState;

    if (form!.validate()) {
      form.save();
      form.reset();
      databaseReference.push().set(srvDet.toJson());
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            new TextField(
              decoration: new InputDecoration(labelText: "Find your job"),
              controller: controller,
            ),
            Flexible(
              child: FirebaseAnimatedList(
                query: databaseReference,
                itemBuilder: (BuildContext context, DataSnapshot snapshot,
                    Animation<double> animation, int index) {
                  return srvDetList[index].clientName.contains(filter) ||
                          srvDetList[index].location.contains(filter)
                      ? ListTile(
                          leading: Icon(
                            Icons.assignment_ind,
                            color: Colors.indigo,
                          ),
                          onLongPress: () {
                            delete_record(snapshot);
                          }, //delete method

                          title: Text(srvDetList[index].clientName,
                              style: TextStyle(
                                  color: Colors.indigo,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18)),
                          subtitle: Text(srvDetList[index].location,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15)),
                          trailing: IconButton(
                            iconSize: 20,
                            icon: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.indigo,
                            ),
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return new MaterialApp(
                                  debugShowCheckedModeBanner: false,
                                  home: Scaffold(
                                    appBar: AppBar(
                                        backgroundColor: Colors.indigo,
                                        leading: IconButton(
                                            icon: Icon((Icons.arrow_back_ios)),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            }),
                                        centerTitle: true,
                                        title: RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                  text: 'Edit ',
                                                  style:
                                                      TextStyle(fontSize: 20)),
                                              WidgetSpan(
                                                child: Icon(Icons.cloud_upload,
                                                    size: 20),
                                              ),
                                            ],
                                          ),
                                        )),
                                    body: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        child: SingleChildScrollView(
                                          child: Form(
                                              key: formkey,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    height: 15,
                                                  ),
                                                  Text(
                                                    'NEW: ' +
                                                        DateFormat('d/M/y')
                                                            .format(currentDate)
                                                            .toString() +
                                                        ' *click icon to change & save',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.red),
                                                  ),
                                                  TextFormField(
                                                    initialValue:
                                                        srvDetList[index]
                                                            .servDate,
                                                    onSaved: (value) => srvDet
                                                            .servDate =
                                                        DateFormat('d/M/y')
                                                            .format(currentDate)
                                                            .toString(),
                                                    validator: (value) => value!
                                                            .isEmpty
                                                        ? 'This field can not be empty!'
                                                        : null,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 20),
                                                    decoration:
                                                        const InputDecoration(
                                                      fillColor: Colors.red,
                                                      icon: Icon(Icons
                                                          .date_range_sharp),
                                                      hintText: 'Insert Date',
                                                      labelText: 'Date *',
                                                    ),
                                                    onTap: () {
                                                      // Below line stops keyboard from appearing
                                                      FocusScope.of(context)
                                                          .requestFocus(
                                                              new FocusNode());

                                                      _selectDate(context);
                                                      // Show Date Picker Here
                                                    },
                                                  ),
                                                  SizedBox(
                                                    height: 15,
                                                  ),
                                                  TextFormField(
                                                    initialValue:
                                                        srvDetList[index]
                                                            .clientName,
                                                    onSaved: (newValue) =>
                                                        srvDet.clientName =
                                                            newValue!,
                                                    validator: (value) => value!
                                                            .isEmpty
                                                        ? 'This field can not be empty!'
                                                        : null,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 20),
                                                    decoration:
                                                        const InputDecoration(
                                                      icon:
                                                          Icon(Icons.business),
                                                      hintText: 'Insert name',
                                                      labelText: 'Client *',
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 15,
                                                  ),
                                                  TextFormField(
                                                    initialValue:
                                                        srvDetList[index]
                                                            .location,
                                                    onSaved: (newValue) =>
                                                        srvDet.location =
                                                            newValue!,
                                                    validator: (value) => value!
                                                            .isEmpty
                                                        ? 'This field can not be empty!'
                                                        : null,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 20),
                                                    decoration:
                                                        const InputDecoration(
                                                      icon: Icon(
                                                          Icons.add_location),
                                                      hintText: 'Insert branch',
                                                      labelText: 'Location *',
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 15,
                                                  ),
                                                  TextFormField(
                                                    initialValue:
                                                        srvDetList[index].fault,
                                                    onSaved: (newValue) =>
                                                        srvDet.fault =
                                                            newValue!,
                                                    validator: (value) => value!
                                                            .isEmpty
                                                        ? 'This field can not be empty!'
                                                        : null,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 20),
                                                    decoration:
                                                        const InputDecoration(
                                                      icon: Icon(Icons
                                                          .add_alert_outlined),
                                                      hintText:
                                                          'Insert description',
                                                      labelText: 'Fault *',
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 15,
                                                  ),
                                                  TextFormField(
                                                    initialValue:
                                                        srvDetList[index].fix,
                                                    onSaved: (newValue) =>
                                                        srvDet.fix = newValue!,
                                                    validator: (value) => value!
                                                            .isEmpty
                                                        ? 'This field can not be empty!'
                                                        : null,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 20),
                                                    decoration:
                                                        const InputDecoration(
                                                      icon: Icon(
                                                          Icons.add_task_sharp),
                                                      hintText:
                                                          'How did you fix the problem?',
                                                      labelText: 'Fix *',
                                                    ),
                                                  ),
                                                  Container(
                                                    child: new DropdownButton<
                                                        String>(
                                                      hint:
                                                          Text("Select Status"),
                                                      value: srvDetList[index]
                                                          .job_status,
                                                      icon: const Icon(
                                                          Icons.arrow_downward),
                                                      iconSize: 24,
                                                      elevation: 16,
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 20),
                                                      underline: Container(
                                                        height: 2,
                                                        color: Colors.indigo,
                                                      ),
                                                      onChanged: (String?
                                                          changedValue) {
                                                        newValue =
                                                            changedValue!;

                                                        setState(() {
                                                          // dropdownValue =
                                                          //     newValue!;
                                                          // srvDet.job_status =
                                                          //     newValue;
                                                          _onDropDownChanged(
                                                              newValue);
                                                          show_status(newValue);
                                                        });
                                                      },
                                                      items: statusTypes.map<
                                                              DropdownMenuItem<
                                                                  String>>(
                                                          (String stat) {
                                                        return new DropdownMenuItem<
                                                            String>(
                                                          value: stat,
                                                          child: new Text(stat),
                                                        );
                                                      }).toList(),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  IconButton(
                                                    iconSize: 40,
                                                    color: Colors.indigo,
                                                    icon: Icon(
                                                        (Icons.copy_all_sharp)),
                                                    onPressed: () {
                                                      update_record(snapshot);
                                                    },
                                                  ),
                                                ],
                                              )),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }));
                            },
                          ))
                      : new Container();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ignore: unused_element
  void _onDropDownChanged(String val) {
    setState(() {
      this.srvDet.job_status = val;
    });
  }

  void _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: new DateTime(2015),
        lastDate: new DateTime(2030));
    if (pickedDate != null && pickedDate != currentDate)
      setState(() {
        currentDate = pickedDate;
        show_new_date(DateFormat('d/M/y').format(currentDate).toString());
      });
  }

  // ignore: non_constant_identifier_names
  void show_new_date(String newValue) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('The date of attendance is changed to  ' +
                '"' +
                newValue +
                '"'),
            // content: Text(newValue),
            actions: [
              // ignore: deprecated_member_use
              IconButton(
                icon: Icon(Icons.info),
                iconSize: 30,
                color: Colors.indigo,
                onPressed: () {
                  setState(() {});
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  // ignore: non_constant_identifier_names
  void show_status(String newValue) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title:
                Text('The job status is changed to  ' + '"' + newValue + '"'),
            // content: Text(newValue),
            actions: [
              // ignore: deprecated_member_use
              IconButton(
                icon: Icon(Icons.info),
                iconSize: 30,
                color: Colors.indigo,
                onPressed: () {
                  setState(() {});
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

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
                  // Navigator.of(context).pop();
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
