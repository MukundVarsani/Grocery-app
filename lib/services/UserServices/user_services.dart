import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myshop/Model/address.dart';
import 'package:myshop/Model/user_model.dart';
import 'package:velocity_x/velocity_x.dart';

class UserServices {
  UserModel? userModel;
  CollectionReference? _users;
  User? _currentUser;

  UserServices() {
    _users = FirebaseFirestore.instance.collection('Users');
    _currentUser = FirebaseAuth.instance.currentUser;
  }

  Future<void> addNewUserDetail() async {
    _currentUser = FirebaseAuth.instance.currentUser;

    if (_users != null && _currentUser != null) {
       _users
          ?.doc(_currentUser?.uid)
          .set(UserModel(
            id: _currentUser?.uid,
            name: _currentUser?.displayName,
            email: _currentUser?.email,
            profileImage: _currentUser?.photoURL,
            phNumber: _currentUser?.phoneNumber,
            address: Address(),
            role: "User",
            isActive: true,
            createdAt: DateTime.now().toString(),
            updatedAt: DateTime.now().toString(),
          ).toJson())
          .then((val) {
        Vx.log("New User created");
      }).onError((e, s) {
        Vx.log("Error on user Services ${e.hashCode}");
      });
    }
  }

  Future<UserModel> getCurrentUserDetail() async {
    _currentUser = FirebaseAuth.instance.currentUser;
    UserModel userModel = UserModel();
    try {
      DocumentReference userDocRef = _users!.doc(_currentUser?.uid);
      DocumentSnapshot docSnapshot = await userDocRef.get();

      if (docSnapshot.exists) {
        UserModel user =
            UserModel.fromJson(docSnapshot.data() as Map<String, dynamic>);
        return user;
      } else {
        Vx.log('User not found');
      }
    } catch (e) {
      Vx.log('Error fetching users: $e');
    }

    return userModel;
  }

  void updateAddress({
    required String city,
    required String country,
    required String postalcode,
    required String street,
  }) async {
    try {
      DocumentReference userDocRef = _users!.doc(_currentUser?.uid);

      Address address = Address(
        city: city,
        country: country,
        postalCode: postalcode,
        street: street,
      );
      await userDocRef.update({
        "address": address.toJson(),
      }).then((va) async {
        Vx.log("Updated Successfully");
      });
    } catch (e) {
      Vx.log('Error updating Address users: $e');
    }
  }

  void setUserProfilePic(String profileURL) {
    try {
      DocumentReference userDocRef = _users!.doc(_currentUser?.uid);
      userDocRef.update({
        'profileImage': profileURL,
      }).then((va) async {
        Vx.log("Profile Update successfully");
      });
    } catch (e) {
      Vx.log('Error Set User profile pic $e');
    }
  }


}
