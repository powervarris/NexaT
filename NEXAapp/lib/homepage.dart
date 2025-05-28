import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'profile.dart';
import 'post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:nexaapp/settings.dart';
import 'package:nexaapp/messages.dart';
import 'package:nexaapp/story.dart';

class HomepageScreen extends StatelessWidget {
  const HomepageScreen({super.key});

  Widget build(BuildContext context) {
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

  void showComments(BuildContext context, String postId) {
    final user = FirebaseAuth.instance.currentUser;
    final photoUrl = user?.photoURL ?? 'images/nexa-logo-no-glow.png';
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
                    stream: FirebaseFirestore.instance
                        .collection("tbl_comments")
                        .where("post_id", isEqualTo: postId)
                        .snapshots(),
                    builder: (context, snapshot) {
                      var records = snapshot.data?.docs ?? [];
                      return ListView.builder(
                        controller: controller,
                        itemCount: records.length,
                        itemBuilder: (context, index) {
                          var rec = records[index];
                          Timestamp timestamp = rec["created_at"];
                          DateTime date = timestamp.toDate();
                          var formattedDate = DateFormat("dd/MM/yyyy hh:mm").format(date);

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(photoUrl),
                                  radius: 25,
                                ),
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
                    }),
              ),
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(photoUrl),
                    radius: 25,
                  ),
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
                          onPressed: () {
                            var comment = commentController.text;
                            if (comment.isNotEmpty) {
                              FirebaseFirestore.instance.collection("tbl_comments").add({
                                "content": comment,
                                "created_at": FieldValue.serverTimestamp(),
                                "user": FirebaseAuth.instance.currentUser?.email,
                                "post_id": postId,
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
    required String postId,
    required int noOfLikes,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(backgroundImage: NetworkImage(profileImg), radius: 23),
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
          if (postImg.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(postImg),
            ),
          if (postImg.isNotEmpty) const SizedBox(height: 10),
          Row(
            children: [
              _PostLikeButton(postId: postId, initialLikes: noOfLikes),
              const SizedBox(width: 10),
              IconButton(
                icon: const Icon(Icons.mode_comment_outlined, color: Color(0xFFEA33F7)),
                onPressed: () => showComments(context, postId),
              ),
              const SizedBox(width: 10),
              const Icon(Icons.send, color: Color(0xFFEA33F7)),
              const Spacer(),
              const Icon(Icons.bookmark_outline, color: Color(0xFFEA33F7)),
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
              Text(" and $noOfLikes others",
                  style: const TextStyle(color: Colors.white, fontSize: 13)),
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
    final user = FirebaseAuth.instance.currentUser;
    final photoUrl = user?.photoURL ?? 'images/nexa-logo-no-glow.png';
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          leadingWidth: 70,
          leading: Container(
            padding: const EdgeInsets.all(5),
            child: SizedBox(
              width: 60,
              height: 60,
              child: Center(
                child: Image.asset(
                  'images/nexa-logo-no-glow.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.message_outlined,
                color: Color(0xFFEA33F7),
                size: 30,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MessagesScreen()),
                );
              },
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
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const StoryScreen()),
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 65,
                          height: 65,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            border: Border.all(color: Colors.cyan, width: 2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Icon(Icons.add, color: Color(0xFFEA33F7), size: 35),
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          "Add Story",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
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
                    stream: FirebaseFirestore.instance
                        .collection("tbl_posts")
                        .orderBy("created_at", descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      var records = snapshot.data?.docs ?? [];
                      return ListView.builder(
                        itemCount: records.length,
                        itemBuilder: (context, index) {
                          var rec = records[index];
                          Timestamp timestamp = rec["created_at"];
                          DateTime date = timestamp.toDate();
                          var formattedDate = DateFormat("dd/MM/yyyy hh:mm").format(date);
                          String imageUrl = rec["image_url"] ?? "";
                          var postId = rec.id;
                          int noOfLikes = rec["no_of_likes"] ?? 0;

                          return Padding(
                            padding: const EdgeInsets.all(20),
                            child: buildPost(
                              context: context,
                              profileImg: photoUrl,
                              username: rec["user"],
                              time: formattedDate,
                              postImg: imageUrl,
                              likedBy: "Jae.ee",
                              commentUser: rec["user"],
                              commentText: rec["content"],
                              postId: postId,
                              noOfLikes: noOfLikes,
                            ),
                          );
                        },
                      );
                    })),
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
                child: CircleAvatar(
                  backgroundImage: NetworkImage(photoUrl),
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

class _PostLikeButton extends StatefulWidget {
  final String postId;
  final int initialLikes;

  const _PostLikeButton({super.key, required this.postId, required this.initialLikes});

  @override
  State<_PostLikeButton> createState() => _PostLikeButtonState();
}

class _PostLikeButtonState extends State<_PostLikeButton> {
  bool isLiked = false;
  int likeCount = 0;

  @override
  void initState() {
    super.initState();
    likeCount = widget.initialLikes;
  }

  Future<void> _handleLike() async {
    if (!isLiked) {
      setState(() {
        isLiked = true;
        likeCount += 1;
      });
      await FirebaseFirestore.instance
          .collection("tbl_posts")
          .doc(widget.postId)
          .update({"no_of_likes": FieldValue.increment(1)});
    } else {
      setState(() {
        isLiked = false;
        likeCount -= 1;
      });
      await FirebaseFirestore.instance
          .collection("tbl_posts")
          .doc(widget.postId)
          .update({"no_of_likes": FieldValue.increment(-1)});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(
            isLiked ? Icons.favorite : Icons.favorite_outline,
            color: const Color(0xFFEA33F7),
          ),
          onPressed: _handleLike,
        ),
        Text(
          '$likeCount',
          style: const TextStyle(color: Colors.white, fontSize: 13),
        ),
      ],
    );
  }
}