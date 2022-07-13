import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:teegram/utils/global_variables.dart';
import '../screens/profile_screen.dart';
import '../utils/colors.dart';

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
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
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
                            (snapshot.data! as dynamic).docs[index]["photoUrl"],
                          ),
                        ),
                        title: Text(
                          (snapshot.data! as dynamic).docs[index]["username"],
                        ),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(
                              uid: (snapshot.data! as dynamic).docs[index]
                                  ["uid"],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                })
            : FutureBuilder(
                future: FirebaseFirestore.instance.collection("posts").get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return StaggeredGridView.countBuilder(
                    crossAxisCount: 3,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    itemCount: (snapshot.data! as dynamic).docs.length,
                    itemBuilder: (context, index) => Image.network(
                      (snapshot.data! as dynamic).docs[index]["postUrl"],
                      fit: BoxFit.cover,
                    ),
                    staggeredTileBuilder: (index) =>
                        MediaQuery.of(context).size.width > webScreenSize
                            ? StaggeredTile.count(
                                (index % 7 == 0) ? 1 : 1,
                                (index % 7 == 0) ? 1 : 1,
                              )
                            : StaggeredTile.count(
                                (index % 7 == 0) ? 2 : 1,
                                (index % 7 == 0) ? 2 : 1,
                              ),
                  );
                }),
      ),
    );
  }
}
