import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_list_vs/models/user.dart';
import 'package:shopping_list_vs/pages/auth/auth_select.dart';
import 'package:shopping_list_vs/pages/home_page.dart';

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    //return HomePage(); // Ammend to add auth switch

    final userStream = Provider.of<User>(context);

    if(userStream == null) {
      return AuthSelect();
    }else {
      return HomePage();
    }

    //return AuthSelect();
  }
}