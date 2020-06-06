import 'package:firebase_auth/firebase_auth.dart';
import 'package:shopping_list_vs/models/user.dart';

class AuthUtil {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  User _createInternalUser(FirebaseUser fUser) {
    return fUser != null ? User(fUser.uid,fUser.isAnonymous) : null;
  }

  Stream<User> get userStream {
    return _auth.onAuthStateChanged
      .map(_createInternalUser);
  }

  Future signInAnon() async{
    try {
      AuthResult signinRes = await _auth.signInAnonymously();
      FirebaseUser userObj = signinRes.user;
      return _createInternalUser(userObj);
    }catch (e){
      print(e.toString());
      return null;
    }
  }

  Future signOut() async{
    try{
      return await _auth.signOut();
    }catch (e){
      print(e.toString());
    }
  }

}