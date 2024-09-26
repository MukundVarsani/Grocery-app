import 'package:firebase_auth/firebase_auth.dart';
import 'package:myshop/services/UserServices/user_services.dart';
import 'package:velocity_x/velocity_x.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserServices _userServices = UserServices();

  Future<String> signUp(
      {required String email,
      required String password,
      required String name}) async {
    String res = "Something went wrong";
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await user.updateDisplayName(name);
        await user.reload();
        await _userServices.addNewUserDetail();
      }

      if (user != null) {
        if (user.email!.validateEmail()) {
          return user.email!;
        }
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          res = 'The email is badly formted';
          break;
        case 'weak-password':
          res = 'password is weak';
          break;
        case 'email-already-in-use':
          res = "Email already exists";
          break;
        default:
          res = e.code;
      }

      Vx.log('Error in auth_method:- $res');
    }

    return res;
  }

  Future<String> signIn(
      {required String email, required String password}) async {
    String res = "Something went wrong";

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      if (userCredential.user != null) {
        return userCredential.user!.email!;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "invalid-credential") {
        res = "Login Fail\nInvalid Credential";
      } else if (e.code == 'user-not-found') {
        res = "User not Exists ";
      } else {
        res = e.code;
      }
    }

    return res;
  }

  Future<void> forgetPassword(String email) async {
    try {
      if (email.isNotEmptyAndNotNull) {
        final FirebaseAuth auth = FirebaseAuth.instance;
        await auth.sendPasswordResetEmail(email: email).then((val) {
          Vx.log("Reset link sent $email");
        });
      }
    } catch (e) {
      Vx.log("Error on sent password link $e");
    }
  }
  
}
