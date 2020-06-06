import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopping_list_vs/utils/auth.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthUtil _auth = AuthUtil();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text('Sign In Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            MaterialButton(
              child: Text('Sign-in Anon'),
              color: Colors.blue,
              onPressed: () async{
                dynamic result = await _auth.signInAnon();
                print('Sign in result: $result');

                // if(result != null) {
                //   String uid = result.uid;
                //   showDialog(
                //     context:context,
                //     builder: (context){
                //       return AlertDialog(
                //         title: Text('Successfully logged in as $uid!')
                //       );
                //     }
                //   );
                // }
              },
            )
          ],
        ),
      )
    );
  }
}