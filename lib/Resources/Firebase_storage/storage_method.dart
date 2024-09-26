import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:myshop/Model/user_model.dart';
import 'package:myshop/services/Provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class StorageMethod {
  late UserProvider _userProvider;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;


  Future<String> uploadUserProfileImageToCloud(
  
    {
    required String childName,
    required Uint8List file,
    required BuildContext context,
  }
  ) async {
    _userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      final UserModel? currentUser = _userProvider.getCurrentUser;

      if (currentUser == null || currentUser.id == null) {
        throw Exception('User is not authenticated.');
      }

      Reference ref =
          _firebaseStorage.ref().child(childName).child(currentUser.id!);

      final TaskSnapshot snapshot = await ref.putData(file);

      final String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      Vx.log('Error uploading file: $e');
      rethrow; // Optionally rethrow the error for further handling
    }
  }


Future<String> uploadItemImageToCloud(
  
    {
    required List<String> childNames,
    required Uint8List file,
    required BuildContext context,
  }
  ) async {
    _userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
   

    String storagePath = childNames.join('/');
    Reference ref = _firebaseStorage.ref().child(storagePath);

      final TaskSnapshot snapshot = await ref.putData(file);

      final String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      Vx.log('Error uploading file: $e');
      rethrow; // Optionally rethrow the error for further handling
    }
  }

          

}

