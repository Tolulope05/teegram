import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../resources/firestore_methods.dart';

import '../models/user.dart';
import '../providers/user_provider.dart';
import '../utils/colors.dart';
import '../widgets/comment_card.dart';

class CommentScreen extends StatefulWidget {
  final snap;
  const CommentScreen({Key? key, required this.snap}) : super(key: key);

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController _commentController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      body: Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          title: const Text('Comment'),
          centerTitle: false,
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("posts")
              .doc(widget.snap["postId"])
              .collection("comment")
              .snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshots) {
            if (snapshots.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
              itemCount: snapshots.data!.docs.length,
              // itemCount: (snapshots.data! as dynamic).docs.length,
              itemBuilder: (context, index) =>
                  CommentCard(snap: snapshots.data!.docs[index].data()),
            );
          },
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            height: kToolbarHeight,
            margin: const EdgeInsets.only(left: 15, right: 8),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                    user.photoUrl,
                  ),
                  radius: 15,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 8),
                    child: TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                          hintText: 'Comment as ${user.username}.',
                          border: InputBorder.none),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    FirestoreMethods().postComment(
                      widget.snap["postId"],
                      _commentController.text,
                      user.uid,
                      user.username,
                      user.photoUrl,
                    );
                    _commentController.clear();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 8,
                    ),
                    child: const Text(
                      "Post",
                      style: TextStyle(color: blueColor),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
