import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nexaapp/homepage.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;

class PostScreen extends StatelessWidget {
  const PostScreen({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: postForm(),
    );
  }
}

class postForm extends StatefulWidget {
  const postForm({super.key});

  @override
  State<postForm> createState() => _postFormState();
}

class _postFormState extends State<postForm> {
  var postController = TextEditingController();
  User? user;
  String? email;
  File? _imageFile;
  Uint8List? _webImageBytes;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    email = user?.email;
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _webImageBytes = bytes;
          _imageFile = null;
        });
      } else {
        setState(() {
          _imageFile = File(pickedFile.path);
          _webImageBytes = null;
        });
      }
    }
  }

  Future<String?> _uploadImage() async {
    try {
      String fileName = '${DateTime.now().millisecondsSinceEpoch}_${user?.uid}.jpg';
      final ref = FirebaseStorage.instance.ref().child(fileName);
      if (kIsWeb && _webImageBytes != null) {
        await ref.putData(_webImageBytes!);
      } else if (_imageFile != null) {
        await ref.putFile(_imageFile!);
      } else {
        return null;
      }
      return await ref.getDownloadURL();
    } catch (e) {
      return null;
    }
  }

  Future<void> _submitPost() async {
    setState(() {
      _isUploading = true;
    });
    String? imageUrl;
    if ((_imageFile != null) || (_webImageBytes != null)) {
      imageUrl = await _uploadImage();
    }
    await FirebaseFirestore.instance.collection("tbl_posts").add({
      "content": postController.text,
      "user": email,
      "no_of_likes": 0,
      "no_of_comments": 0,
      "created_at": FieldValue.serverTimestamp(),
      "image_url": imageUrl ?? "",
    });

    // Increment no_of_posts for the user
    if (user != null) {
      final userDoc = FirebaseFirestore.instance.collection("tbl_users").doc(user!.uid);
      await userDoc.update({
        "no_of_posts": FieldValue.increment(1),
      });
    }

    setState(() {
      _isUploading = false;
    });
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomepageScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final photoUrl = user?.photoURL;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Color(0xFFEA33F7)),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomepageScreen(),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: _isUploading ? null : _submitPost,
            child: _isUploading
                ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFEA33F7)),
            )
                : const Text(
              'Post',
              style: TextStyle(
                color: Color(0xFFEA33F7),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(photoUrl!),
                  radius: 20,
                ),
                const SizedBox(width: 10),
                Text(
                  email ?? "User",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(15),
              width: double.infinity,
              height: 160,
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: postController,
                style: const TextStyle(color: Colors.white),
                maxLines: null,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "What's on your mind?",
                  hintStyle: TextStyle(color: Colors.white38),
                ),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: BoxDecoration(
                  color: Colors.grey[850],
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.image_outlined, color: Color(0xFFEA33F7)),
                    const SizedBox(width: 10),
                    const Text(
                      "Photo/Video",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const Spacer(),
                    if (_imageFile != null)
                      SizedBox(
                        width: 40,
                        height: 40,
                        child: Image.file(_imageFile!, fit: BoxFit.cover),
                      )
                    else if (_webImageBytes != null)
                      SizedBox(
                        width: 40,
                        height: 40,
                        child: Image.memory(_webImageBytes!, fit: BoxFit.cover),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}