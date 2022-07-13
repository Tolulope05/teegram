import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/post.dart';
import '../resources/storage_method.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // upload post
  Future<String> uploadPost(
    String description,
    String uid,
    String username,
    String profileImage,
    Uint8List file,
  ) async {
    String res = "Some error occured";
    String postId = const Uuid().v1();
    try {
      String photoUrl =
          await StorageMethods().uploadImagetoStorage('posts', file, true);
      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profileImage: profileImage,
        likes: [],
      );
      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = "Success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      // if likes contains uid ? dislike the post.
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          "likes": FieldValue.arrayRemove([uid])
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          "likes": FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> postComment(
    String postId,
    String text,
    String uid,
    String name,
    String profilePic,
  ) async {
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        _firestore
            .collection("posts")
            .doc(postId)
            .collection("comment")
            .doc(commentId)
            .set({
          "profilePic": profilePic,
          "name": name,
          "uid": uid,
          "text": text,
          "commentId": commentId,
          "datePublished": DateTime.now(),
        });
      } else {
        print("Text is empty");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  // deleting the post
  Future<void> deletePost(String postId, String postUrl) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
      QuerySnapshot document = await _firestore
          .collection('posts')
          .doc(postId)
          .collection('comment')
          .get();
      for (var doc in document.docs) {
        doc.reference.delete();
      }
      StorageMethods().deleteImage(postUrl);
    } catch (e) {
      print(e.toString());
    }
  }

  // followers functionality
  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];
      if (following.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({
          "followers": FieldValue.arrayRemove([uid])
        });
        await _firestore.collection('users').doc(uid).update({
          "following": FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection('users').doc(followId).update({
          "followers": FieldValue.arrayUnion([uid])
        });
        await _firestore.collection('users').doc(uid).update({
          "following": FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
