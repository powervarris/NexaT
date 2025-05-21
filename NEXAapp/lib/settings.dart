import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1F1E1E),
      appBar: AppBar(title: const Text("Settings")),
      body: const Center(
        child: Text("This is the Settings Screen"),
      ),
    );
  }
}