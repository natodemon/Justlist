import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text('Sign In Page'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical:20, horizontal:50),
        child: RaisedButton(
          child: Text('Sign-in Anon'),
          onPressed: () async {

          },
        ),
      ),
    );
  }
}