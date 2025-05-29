import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _retypeController = TextEditingController();
  bool _loading = false;
  String? _error;

  Future<void> _changePassword() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final user = FirebaseAuth.instance.currentUser;
    final currentPassword = _currentController.text.trim();
    final newPassword = _newController.text.trim();
    final retypePassword = _retypeController.text.trim();

    if (newPassword != retypePassword) {
      setState(() {
        _error = "New passwords do not match.";
        _loading = false;
      });
      return;
    }
    if (newPassword.length < 6) {
      setState(() {
        _error = "Password must be at least 6 characters.";
        _loading = false;
      });
      return;
    }

    try {
      final cred = EmailAuthProvider.credential(
        email: user!.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(cred);
      await user.updatePassword(newPassword);
      setState(() {
        _loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password changed successfully!')),
      );
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      setState(() {
        _error = e.message;
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _retypeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final user = FirebaseAuth.instance.currentUser?.displayName;

    return Scaffold(
      backgroundColor: const Color(0xFF1F1E1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F1E1E),
        iconTheme: const IconThemeData(color: Color(0xFFEA33F7)),
        title: Text(
          user!,
          style: TextStyle(color: Colors.white54, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            const SizedBox(height: 10),
            const Text(
              'Change Password',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Your password must be at least 6 characters and should include a combination of numbers, letters, and special characters (!@\$%).',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _currentController,
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Current password',
                hintStyle: const TextStyle(color: Colors.white54),
                filled: true,
                fillColor: const Color(0x80DED8DB),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _newController,
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'New password',
                hintStyle: const TextStyle(color: Colors.white54),
                filled: true,
                fillColor: const Color(0x80DED8DB),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _retypeController,
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Re-type new password',
                hintStyle: const TextStyle(color: Colors.white54),
                filled: true,
                fillColor: const Color(0x80DED8DB),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              ),
            ),
            const SizedBox(height: 12),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  _error!,
                  style: const TextStyle(color: Colors.redAccent),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          border: Border(
              top: BorderSide(
                  color: Colors.purpleAccent,
                  width: 1
              )
          ),
          color: Color(0xFF1F1E1E),
        ),
        child: SizedBox(
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple.shade800,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                disabledBackgroundColor: const Color(0xFF47135C)
            ),
            onPressed: _loading ? null : _changePassword,
            child: _loading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text('Change Password',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                )),
          ),
        ),
      ),
    );
  }
}