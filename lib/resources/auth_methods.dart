import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user.dart' as model;
import '../resources/storage_method.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot<Map<String, dynamic>> snap =
        await _firestore.collection('users').doc(currentUser.uid).get();
    return model.User.fromSnap(snap);
  }

  //Sign Up the user
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = 'Some error occured.';
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty) {
        // Register user.
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        // print(cred.user!.uid);
        String photoUrl = await StorageMethods()
            .uploadImagetoStorage('profilePics', file, false);

        // Add user to our database.
        model.User user = model.User(
          username: username,
          uid: cred.user!.uid,
          email: email,
          bio: bio,
          followers: [],
          following: [],
          photoUrl: photoUrl,
        );
        await _firestore
            .collection('users')
            .doc(cred.user!.uid)
            .set(user.toJson());

        res = 'Success';
      }
    } on FirebaseException catch (err) {
      if (err.code == 'invalid-email') {
        res = 'The Email is badly formatted';
      } else if (err.code == 'weak-password') {
        res = 'The Password should be at least 6 characters.';
      } else {
        res = err.message.toString();
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  //Logging in Users.
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = 'Some error occured!';
    try {
      if (email.trim().isNotEmpty || password.trim().isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = 'Success';
      } else {
        res = 'Please enter all the fields.';
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'user-not-found') {
        res = 'There is no existing user matching this username.';
      } else if (err.code == 'wrong-password') {
        res = 'Please check your details for wrong or missing information.';
      } else {
        res = err.message.toString();
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
