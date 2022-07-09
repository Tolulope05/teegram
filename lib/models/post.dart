import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String description;
  final String uid;
  final String username;
  final String postId;
  final DateTime datePublished;
  final String postUrl;
  final String profileImage;
  final likes;

  const Post({
    required this.description,
    required this.uid,
    required this.username,
    required this.postId,
    required this.datePublished,
    required this.postUrl,
    required this.profileImage,
    required this.likes,
  });

  Map<String, dynamic> toJson() => {
        "description": description,
        "uid": uid,
        "username": username,
        "postId": postId,
        "datePublished": datePublished,
        "postUrl": postUrl,
        "profileImage": profileImage,
        "likes": likes,
      };

  //Function that accepts a document snapshot and returns a User model.
  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Post(
      username: snapshot["username"],
      uid: snapshot["uid"],
      description: snapshot["description"],
      postId: snapshot["postId"],
      datePublished: snapshot["datePublished"],
      profileImage: snapshot["profileImage"],
      likes: snapshot["likes"],
      postUrl: snapshot["postUrl"],
    );
  }
}
