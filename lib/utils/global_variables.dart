import 'package:flutter/material.dart';
import '../screens/add_post_screen.dart';
import '../screens/feed_screen.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  const FeedScreen(),
  const Text('search'),
  const AddPostScreen(),
  const Text('notif'),
  const Text('profile'),
];
