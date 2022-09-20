import 'package:firebase_auth/firebase_auth.dart';
//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:field_manager/MenuScreen.dart';
import 'package:field_manager/validators.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MainScreen(),
  ));
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool _signedUp = true;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  GlobalKey<FormState> _key = GlobalKey<FormState>();

  void initialize() async {
    await Firebase.initializeApp();
  }

  @override
  void initState() {
    initialize();

    //  implement initState
    super.initState();
  }

  @override
  void dispose() {
    // implement dispose
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text((_signedUp) ? 'Service Tracker - sign in' : 'Sign up'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.07,
            ),
            Form(
              key: _key,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 20.0),
                    child: TextFormField(
                      controller: _emailController,
                      validator: Validator.emailValidator,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.email,
                            color: Colors.grey,
                          ),
                          labelText: 'E-mail',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              gapPadding: 12.0)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 8.0),
                    child: TextFormField(
                      controller: _passwordController,
                      validator: Validator.passwordValidator,
                      obscureText: true,
                      autofocus: false,
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.grey,
                          ),
                          labelText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          )),
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: _signedUp,
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, bottom: 20.0),
                child: TextButton(
                  onPressed: () async {
                    try {
                      if (_emailController.text.isNotEmpty) {
                        FirebaseAuth _auth = FirebaseAuth.instance;
                        await _auth.sendPasswordResetEmail(
                            email: _emailController.text);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                            'We have sent you an E-mail .. Check your inbox',
                            style:
                                TextStyle(color: Colors.white, fontSize: 20.0),
                          ),
                          backgroundColor: Colors.blue,
                          duration: Duration(seconds: 3),
                        ));
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          '${e.toString()}',
                          style: TextStyle(color: Colors.white, fontSize: 20.0),
                        ),
                        backgroundColor: Colors.indigo,
                        duration: Duration(seconds: 3),
                      ));
                    }
                    _emailController.clear();
                    _passwordController.clear();
                  },
                  child: Text(
                    'Reset Password ?',
                    style: TextStyle(color: Colors.indigo, fontSize: 14.0),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 2.0, horizontal: 5.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: Colors.indigo,
                ),
                child: (_signedUp)
                    // ? TextButton(
                    //     child: Text(
                    //       'Sign in',
                    //       style: TextStyle(color: Colors.white, fontSize: 18.0),
                    //     ),
                    ? IconButton(
                        icon: const Icon(Icons.login),
                        color: Colors.white,
                        onPressed: () async {
                          if (_key.currentState!.validate()) {
                            try {
                              FirebaseAuth _auth = FirebaseAuth.instance;
                              UserCredential result =
                                  await _auth.signInWithEmailAndPassword(
                                      email: _emailController.text,
                                      password: _passwordController.text);
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      MenuScreen(email: result.user!.email)));
                            } catch (e) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(
                                  '${e.toString()}',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20.0),
                                ),
                                backgroundColor: Colors.indigo,
                                duration: Duration(seconds: 3),
                              ));
                            }
                            _emailController.clear();
                            _passwordController.clear();
                          }
                        },
                      )
                    : TextButton(
                        child: Text(
                          'Sign up',
                          style: TextStyle(color: Colors.white, fontSize: 18.0),
                        ),
                        onPressed: () async {
                          if (_key.currentState!.validate()) {
                            try {
                              FirebaseAuth _auth = FirebaseAuth.instance;
                              UserCredential result =
                                  await _auth.createUserWithEmailAndPassword(
                                      email: _emailController.text,
                                      password: _passwordController.text);
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      MenuScreen(email: result.user!.email)));
                            } catch (e) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(
                                  '${e.toString()}',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20.0),
                                ),
                                backgroundColor: Colors.indigo,
                                duration: Duration(seconds: 3),
                              ));
                            }
                            _emailController.clear();
                            _passwordController.clear();
                          }
                        },
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: (_signedUp)
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Don’t have an account? ',
                          style: TextStyle(color: Colors.grey, fontSize: 16.0),
                        ),
                        TextButton(
                          child: Text(
                            'Sign up',
                            style:
                                TextStyle(color: Colors.blue, fontSize: 16.0),
                          ),
                          onPressed: () {
                            setState(() {
                              _signedUp = !_signedUp;
                            });
                          },
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? ',
                          style: TextStyle(color: Colors.grey, fontSize: 16.0),
                        ),
                        TextButton(
                          child: Text(
                            'Sign in',
                            style:
                                TextStyle(color: Colors.indigo, fontSize: 16.0),
                          ),
                          onPressed: () {
                            setState(() {
                              _signedUp = !_signedUp;
                            });
                          },
                        ),
                      ],
                    ),
            ),
            Visibility(
              child: Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2.0, horizontal: 5.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(width: 2.0, color: Colors.red)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.05,
                            width: 40.0,
                            child: Image.asset(
                              'images/google.png',
                              fit: BoxFit.fill,
                            ),
                          ),
                          TextButton(
                            child: Text(
                              'Sign in with Google',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                  color: Colors.red),
                            ),
                            onPressed: () async {
                              try {
                                var googleUser = await GoogleSignIn().signIn();
                                var googleAuth =
                                    await googleUser!.authentication;
                                FirebaseAuth _auth = FirebaseAuth.instance;
                                UserCredential userCred =
                                    await _auth.signInWithCredential(
                                        GoogleAuthProvider.credential(
                                  idToken: googleAuth.idToken,
                                  accessToken: googleAuth.accessToken,
                                ));
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => MenuScreen(
                                          email: userCred.user!.email,
                                        )));
                              } catch (e) {
                                print(e.toString());
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 20.0),
                      padding: const EdgeInsets.symmetric(
                          vertical: 2.0, horizontal: 5.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(width: 2.0, color: Colors.blue)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.05,
                            width: 40.0,
                            child: Image.asset(
                              'images/facebook.png',
                              fit: BoxFit.fill,
                            ),
                          ),
                          TextButton(
                            child: Text(
                              'Sign in with Facebook',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                  color: Colors.blue),
                            ),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              visible: _signedUp,
            ),
          ],
        ),
      ),
    );
  }
}
