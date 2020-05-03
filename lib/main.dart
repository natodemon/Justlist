import 'package:flutter/material.dart';
import './pages/home_page.dart';

void main() => runApp(ShoppingList());

class ShoppingList extends StatelessWidget {
  final appTitle = 'Justlist';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      color: Colors.blue,
      home: HomePage(),
    );
  }
}