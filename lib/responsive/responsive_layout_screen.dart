import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

import '../utils/global_variables.dart';

class ResponsiveLayout extends StatefulWidget {
  final Widget webScreenLayout;
  final Widget mobileScreenLayout;
  const ResponsiveLayout({
    Key? key,
    required this.webScreenLayout,
    required this.mobileScreenLayout,
  }) : super(key: key);

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  @override
  void initState() {
    addData();
    super.initState();
  }

  Future<bool> addData() async {
    UserProvider userProvider = Provider.of(context, listen: false);
    await userProvider.refreshUser();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: addData(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
              child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.green),
          ));
        }
        return LayoutBuilder(builder: (context, constraints) {
          if (constraints.maxWidth > webScreenSize) {
            // Display Webscreen
            return widget.webScreenLayout;
          }
          // Mobile Screen
          return widget.mobileScreenLayout;
        });
      },
    );
  }
}
