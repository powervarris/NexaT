import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nexaapp/changepassword.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AccountCenterScreen extends StatefulWidget {
  const AccountCenterScreen({super.key});

  @override
  State<AccountCenterScreen> createState() => _AccountCenterScreenState();
}

class _AccountCenterScreenState extends State<AccountCenterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  late User _user;
  late TextEditingController _usernameController;
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  bool _loading = false;
  String? _error;
  File? _imageFile;
  String? _photoUrl;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser!;
    _usernameController = TextEditingController(text: _user.displayName ?? '');
    _emailController = TextEditingController(text: _user.email ?? '');
    _photoUrl = _user.photoURL;
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
      });
      await _uploadImage();
    }
  }

  Future<void> _uploadImage() async {
    if (_imageFile == null) return;
    final ref = FirebaseStorage.instance
        .ref()
        .child('user_photos')
        .child('${_user.uid}.jpg');
    await ref.putFile(_imageFile!);
    final url = await ref.getDownloadURL();
    await _user.updatePhotoURL(url);
    await _user.reload();
    setState(() {
      _photoUrl = url;
      _user = _auth.currentUser!;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile photo updated!')),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      if (_user.displayName != _usernameController.text) {
        await _user.updateDisplayName(_usernameController.text);
      }
      if (_user.email != _emailController.text) {
        await _user.updateEmail(_emailController.text);
      }
      await _user.reload();
      _user = _auth.currentUser!;
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated!')),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        _error = e.message;
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F1E1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F1E1E),
        iconTheme: const IconThemeData(color: Color(0xFFEA33F7)),
        centerTitle: true,
        title: const Text(
          'Account Center',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: _photoUrl != null
                        ? NetworkImage(_photoUrl!)
                        : const AssetImage('images/nexa-logo-no-glow.png') as ImageProvider,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: const CircleAvatar(
                        backgroundColor: Colors.purpleAccent,
                        radius: 20,
                        child: Icon(Icons.edit, color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Center(
              child: Icon(
                Icons.edit,
                color: Colors.purpleAccent,
                size: 20,
              ),
            ),
            const SizedBox(height: 30),
            const Text('Username',
                style: TextStyle(
                    color: Colors.white70, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            TextFormField(
              controller: _usernameController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0x80DED8DB),
                suffixIcon: const Icon(Icons.edit, color: Color(0xFFEA33F7)),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFEA33F7)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Email',
                style: TextStyle(
                    color: Colors.white70, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            TextFormField(
              controller: _emailController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0x80DED8DB),
                suffixIcon: const Icon(Icons.edit, color: Color(0xFFEA33F7)),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFEA33F7)),
                ),
              ),
            ),
            const SizedBox(height: 15),
            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChangePasswordScreen()),
                    );
                  },
                  child: const Text(
                    'Forget Password?',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.white,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple.shade800,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 10),
                  ),
                  onPressed: _saveChanges,
                  child: const Text('Save',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15)),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
            ),
            const ListTile(
              title: Text('Login',
                  style: TextStyle(
                    color: Color(0xFF8A8888),
                    fontWeight: FontWeight.bold,
                  )),
            ),
            const ListTile(
              title: Text('Add Account',
                  style: TextStyle(
                    color: Color(0xFF7806A4),
                    fontWeight: FontWeight.bold,
                  )),
            ),
            const ListTile(
              title: Text('Log out',
                  style: TextStyle(
                    color: Color(0xFF8D3C3C),
                    fontWeight: FontWeight.bold,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}