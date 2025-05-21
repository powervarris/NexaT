import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'profile.dart';
import 'post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomepageScreen extends StatelessWidget {
  const HomepageScreen({super.key});

  Widget build(BuildContext context){
    return MaterialApp(
      home: homepageForm(),
    );
  }
}

class homepageForm extends StatefulWidget {
  const homepageForm({super.key});

  @override
  State<homepageForm> createState() => _homepageFormState();
}

class _homepageFormState extends State<homepageForm> {
  var commentController = TextEditingController();
  @override
  Widget highlightBox(String imagePath, String label, {bool showDot = false}) {
    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              Container(
                width: 65,
                height: 65,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  border: Border.all(color: Colors.cyan, width: 2),
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: AssetImage(imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              if (showDot)
                const Positioned(
                  bottom: 4,
                  left: 4,
                  child: CircleAvatar(
                    radius: 5,
                    backgroundColor: Colors.purple,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }

  void showComments(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.8,
        builder: (_, controller) => Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text("Comments", style: TextStyle(color: Colors.white, fontSize: 18)),
              const Divider(color: Color(0xFFEA33F7)),
              Expanded(
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance.collection("tbl_comments").orderBy("created_at", descending: true).snapshots(),
                    builder: (context, snapshot){
                      var records = snapshot.data?.docs ?? [];
                      return ListView.builder(
                        controller: controller,
                        itemCount: records.length,
                        itemBuilder: (context, index){
                          var rec = records[index];
                          Timestamp timestamp = rec["created_at"];
                          DateTime date = timestamp.toDate();
                          var formattedDate = DateFormat("dd/MM/yyyy hh:mm").format(date);

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              children: [
                                const CircleAvatar(backgroundImage: AssetImage("images/avatar.jpg"), radius: 20),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(rec["user"], style: const TextStyle(color: Colors.white, fontSize: 14)),
                                      Text(rec["content"], style: const TextStyle(color: Colors.white70, fontSize: 12)),
                                      Text(formattedDate, style: const TextStyle(color: Colors.grey, fontSize: 10)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }
                ),
              ),
              Row(
                children: [
                  const CircleAvatar(backgroundImage: AssetImage("images/avatar.jpg")),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: commentController,
                      decoration: InputDecoration(
                        hintText: "Add a comment...",
                        hintStyle: const TextStyle(color: Colors.white70),
                        filled: true,
                        fillColor: Colors.transparent,
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color(0xFFEA33F7)),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.gif, color: Color(0xFFEA33F7)),
                          onPressed: (){
                            var comment = commentController.text;
                            if (comment.isNotEmpty) {
                              FirebaseFirestore.instance.collection("tbl_comments").add({
                                "content": comment,
                                "created_at": FieldValue.serverTimestamp(),
                                "user": FirebaseAuth.instance.currentUser?.email,
                              });
                              commentController.clear();
                            }
                          },
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPost({
    required BuildContext context,
    required String profileImg,
    required String username,
    required String time,
    required String postImg,
    required String likedBy,
    required String commentUser,
    required String commentText,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(backgroundImage: AssetImage(profileImg), radius: 23),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(username,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.white)),
                  Text(time,
                      style: const TextStyle(fontSize: 11, color: Colors.grey)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(postImg),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.favorite, color: Color(0xFFEA33F7)),
              const SizedBox(width: 10),
              IconButton(
                icon: const Icon(Icons.mode_comment_outlined, color: Color(0xFFEA33F7)),
                onPressed: () => showComments(context),
              ),
              const SizedBox(width: 10),
              const Icon(Icons.send, color: Color(0xFFEA33F7)),
              const Spacer(),
              const Icon(Icons.bookmark, color: Color(0xFFEA33F7)),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              const Icon(Icons.account_circle, color: Colors.white, size: 16),
              const SizedBox(width: 5),
              Text("Liked by ",
                  style: const TextStyle(color: Colors.white, fontSize: 13)),
              Text(likedBy,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 13)),
              const Text(" and 100 others",
                  style: TextStyle(color: Colors.white, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Text(commentUser,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13)),
              const SizedBox(width: 5),
              Text(commentText,
                  style: const TextStyle(color: Colors.white, fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          leadingWidth: 100,
          leading: Container(
            padding: const EdgeInsets.all(10),
            child: Image.asset(
              'images/nexa-logo-no-glow.png',
              fit: BoxFit.contain,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.menu,
                color: Color(0xFFEA33F7),
                size: 50,
              ),
              onPressed: () {},
            ),
          ],
        ),
        body: Column(
          children: [
            Container(
              height: 120,
              width: double.infinity,
              color: Colors.black,
              padding: const EdgeInsets.all(10),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  highlightBox("images/hh1.jpg", "Han", showDot: true),
                  highlightBox("images/hh2.jpg", "So-Hee"),
                  highlightBox("images/hh3.jpg", "Xee"),
                  highlightBox("images/hh4.jpg", "So"),
                  highlightBox("images/hh5.jpg", "Xace"),
                  highlightBox("images/raj.jpg", "Xee"),
                  highlightBox("images/luffy.jpg", "Ceso"),
                ],
              ),
            ),
            Expanded(
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance.collection("tbl_posts").orderBy("created_at", descending: true).snapshots(),
                    builder: (context, snapshot){
                      var records = snapshot.data?.docs ?? [];
                      return ListView.builder(
                        itemCount: records.length,
                        itemBuilder: (context, index){
                          var rec = records[index];
                          Timestamp timestamp = rec["created_at"];
                          DateTime date = timestamp.toDate();
                          var formattedDate = DateFormat("dd/MM/yyyy hh:mm").format(date);

                          return Padding(
                            padding: const EdgeInsets.all(20),
                            child: buildPost(
                              context: context,
                              profileImg: "images/sohee.jpg",
                              username: rec["user"],
                              time: formattedDate,
                              postImg: "images/raj.jpg",
                              likedBy: "Jae.ee",
                              commentUser: "Name",
                              commentText: rec["content"],
                            ),
                          );
                        },
                      );
                    }
                )
            ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          padding: const EdgeInsets.all(10),
          color: Colors.black,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomepageScreen()),
                  );
                },
                child: const Icon(Icons.home, color: Color(0xFFEA33F7), size: 30),
              ),
              const Icon(Icons.search, color: Color(0xFFEA33F7), size: 30),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PostScreen()),
                  );
                },
                child: const Icon(Icons.add_circle_outline, color: Color(0xFFEA33F7), size: 30),
              ),
              const Icon(Icons.favorite_border, color: Color(0xFFEA33F7), size: 30),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProfileScreen()),
                  );
                },
                child: const CircleAvatar(
                  backgroundImage: AssetImage("images/avatar.jpg"),
                  radius: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
