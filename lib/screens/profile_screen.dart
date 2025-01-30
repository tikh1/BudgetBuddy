import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../widgets/bottom_menu.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: arkaplanRenkim,
      body: Center(
        child: Text("profile ekranim"),
      ),
      bottomNavigationBar: BottomMenu(),
    );
  }
}
