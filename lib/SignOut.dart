import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignOut extends StatefulWidget {
  SignOut();

  SignOutState createState() => SignOutState();
}

class SignOutState extends State<SignOut> {
  @override
  Widget build(BuildContext context) => Scaffold(
          body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ElevatedButton(
                  child: Text(
                    'Sign out',
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                  ),
                  onPressed: () async {
                    try {
                      FirebaseAuth _auth = FirebaseAuth.instance;
                      await _auth.signOut();
                      Navigator.of(context).pop();
                    } catch (e) {
                      print(e.toString());
                    }
                  }),
            ],
          ),
        ),
      ));
}
