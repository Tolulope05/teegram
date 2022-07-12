import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:teegram/utils/colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool isShowUsers = false;
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          title: TextFormField(
            controller: _searchController,
            decoration: const InputDecoration(
              labelText: "Search for user...",
            ),
            onFieldSubmitted: (String _) {
              // print(_);
              // print(_searchController.text);
              if (_.trim().isEmpty) {
                setState(() {
                  isShowUsers = false;
                });
              } else {
                setState(() {
                  isShowUsers = true;
                });
              }
            },
            onChanged: (String _) {
              if (_.trim().isEmpty) {
                setState(() {
                  isShowUsers = false;
                });
              }
              if (_.trim().isNotEmpty) {
                setState(() {
                  isShowUsers = true;
                });
              }
            },
          ),
        ),
        body: isShowUsers
            ? FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection("users")
                    .where(
                      "username",
                      isGreaterThanOrEqualTo: _searchController.text,
                    )
                    .get(),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView.builder(
                    itemCount: (snapshot.data! as dynamic).docs.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                              (snapshot.data! as dynamic).docs[index]
                                  ["photoUrl"]),
                        ),
                        title: Text((snapshot.data! as dynamic).docs[index]
                            ["username"]),
                        onTap: () {},
                      );
                    },
                  );
                })
            : const Text("Posts"),
      ),
    );
  }
}
