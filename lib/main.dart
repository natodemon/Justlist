import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_list_vs/models/user.dart';
import 'package:shopping_list_vs/pages/auth_wrapper.dart';
import 'package:shopping_list_vs/utils/auth.dart';


void main() => runApp(ShoppingList());

class ShoppingList extends StatelessWidget {
  final appTitle = 'Justlist';

  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value:AuthUtil().userStream,
      child: MaterialApp(
        //title: appTitle,
        //color: Colors.blue,
        home: AuthWrapper(),
      ),
    );
  }
}