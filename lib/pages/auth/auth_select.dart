import 'package:flutter/material.dart';
import 'package:shopping_list_vs/pages/auth/sign_in.dart';

class AuthSelect extends StatefulWidget {
  @override
  _AuthSelectState createState() => _AuthSelectState();
}

class _AuthSelectState extends State<AuthSelect> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SignIn(),
    );
  }
}