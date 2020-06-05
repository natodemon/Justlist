import 'package:flutter/material.dart';
import 'package:shopping_list_vs/pages/auth_wrapper.dart';

void main() => runApp(ShoppingList());

class ShoppingList extends StatelessWidget {
  final appTitle = 'Justlist';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      color: Colors.blue,
      home: AuthWrapper(),
    );
  }
}