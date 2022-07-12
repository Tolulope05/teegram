import 'package:flutter/material.dart';

import '../screens/profile_screen.dart';
import '../screens/search_screen.dart';
import '../screens/add_post_screen.dart';
import '../screens/feed_screen.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  const FeedScreen(),
  const SearchScreen(),
  const AddPostScreen(),
  const Text('notif'),
  const ProfileScreen(),
];
