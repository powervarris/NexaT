import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nexaapp/homepage.dart';
import 'package:intl/intl.dart';

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
  String? name;
  @override

  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    email = user?.email;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Color(0xFFEA33F7)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () {
              var postText = postController.text;
              FirebaseFirestore.instance.collection("tbl_posts").add({
                "content" : postText,
                "user" : email,
                "no_of_likes" : 0,
                "no_of_comments" : 0,
                "created_at" : FieldValue.serverTimestamp()
              });

              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomepageScreen())
              );
            },
            child: const Text(
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
                const CircleAvatar(
                  backgroundImage: AssetImage("images/avatar.jpg"),
                  radius: 20,
                ),
                const SizedBox(width: 10),
                  Text(
                  email ?? "User",
                  style: TextStyle(
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
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(
                color: Colors.grey[850],
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: const [
                  Icon(Icons.image_outlined, color: Color(0xFFEA33F7)),
                  SizedBox(width: 10),
                  Text(
                    "Photo/Video",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
