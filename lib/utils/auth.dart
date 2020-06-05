import 'package:firebase_auth/firebase_auth.dart';

class AuthUtil {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future signInAnon() async{
    try {
      AuthResult signinRes = await _auth.signInAnonymously();
      FirebaseUser userObj = signinRes.user;
      return userObj;
    }catch (e){
      print(e.toString());
      return null;
    }
  }

}