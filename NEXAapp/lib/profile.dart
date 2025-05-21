import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1F1E1E),
      appBar: AppBar(title: const Text("Profile")),
      body: const Center(
        child: Text("This is the Profile Screen"),
      ),
    );
  }
}