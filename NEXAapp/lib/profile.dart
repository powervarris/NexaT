import 'package:flutter/material.dart';
import 'homepage.dart';
import 'post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nexaapp/settings.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  Widget highlightBox(String imagePath, String label, {bool showDot = false}) {
    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.cyan, width: 2),
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
                    radius: 6,
                    backgroundColor: Colors.purple,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final photoUrl = user?.photoURL;
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          leadingWidth: 100,
          leading: Container(
            padding: const EdgeInsets.all(10),
            child: Image.asset(
              'images/nexaLogo.png',
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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsScreen()),
                );
              },
            ),
          ],
        ),
        body: Container(
          color: Colors.black,
          child: Column(
            children: [
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 16, right: 20),
                    child: CircleAvatar(
                      backgroundImage: photoUrl != null
                          ? NetworkImage(photoUrl)
                          : const AssetImage('images/nexa-logo-no-glow.png') as ImageProvider,
                      radius: 50,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                            Text(
                            FirebaseAuth.instance.currentUser?.displayName ?? "No Name",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  FutureBuilder<DocumentSnapshot>(
                                    future: FirebaseFirestore.instance.collection("tbl_users").doc(FirebaseAuth.instance.currentUser?.uid).get(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return Text("...", style: TextStyle(fontSize: 17, color: Colors.white));
                                      }
                                      if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
                                        return Text("0", style: TextStyle(fontSize: 17, color: Colors.white));
                                      }
                                      final data = snapshot.data!.data() as Map<String, dynamic>;
                                      final followers = data["no_of_posts"] ?? 0;
                                      return Text(
                                        followers.toString(),
                                        style: const TextStyle(fontSize: 17, color: Colors.white),
                                      );
                                    },
                                  ),
                                  Text("posts", style: TextStyle(fontSize: 17, color: Colors.white)),
                                ],
                              ),
                              Column(
                                children: [
                                  FutureBuilder<DocumentSnapshot>(
                                    future: FirebaseFirestore.instance.collection("tbl_users").doc(FirebaseAuth.instance.currentUser?.uid).get(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return Text("...", style: TextStyle(fontSize: 17, color: Colors.white));
                                      }
                                      if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
                                        return Text("0", style: TextStyle(fontSize: 17, color: Colors.white));
                                      }
                                      final data = snapshot.data!.data() as Map<String, dynamic>;
                                      final followers = data["no_of_followers"] ?? 0;
                                      return Text(
                                        followers.toString(),
                                        style: const TextStyle(fontSize: 17, color: Colors.white),
                                      );
                                    },
                                  ),
                                  Text("followers", style: TextStyle(fontSize: 17, color: Colors.white)),
                                ],
                              ),
                              Column(
                                children: [
                                  FutureBuilder<DocumentSnapshot>(
                                    future: FirebaseFirestore.instance.collection("tbl_users").doc(FirebaseAuth.instance.currentUser?.uid).get(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return Text("...", style: TextStyle(fontSize: 17, color: Colors.white));
                                      }
                                      if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
                                        return Text("0", style: TextStyle(fontSize: 17, color: Colors.white));
                                      }
                                      final data = snapshot.data!.data() as Map<String, dynamic>;
                                      final followers = data["no_of_following"] ?? 0;
                                      return Text(
                                        followers.toString(),
                                        style: const TextStyle(fontSize: 17, color: Colors.white),
                                      );
                                    },
                                  ),
                                  Text("following", style: TextStyle(fontSize: 17, color: Colors.white)),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Container(
                height: 130,
                width: 500,
                padding: const EdgeInsets.all(10),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    highlightBox("images/highlight1.jpg", "Me"),
                    highlightBox("images/highlight2.jpg", "Bae"),
                    highlightBox("images/highlight5.jpg", "Drawing"),
                    highlightBox("images/highlight4.jpg", "Luffy"),
                    highlightBox("images/highlight3.jpg", "Quotes"),
                  ],
                ),
              ),
              Column(
                children: [
                  Container(
                    height: 3,
                    width: double.infinity,
                    color: const Color(0xFFEA33F7),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Column(
                      children: [
                        const Icon(Icons.apps, color: Color(0xFFEA33F7), size: 40),
                        const SizedBox(height: 5),
                        Container(
                          height: 3,
                          width: 60,
                          color: const Color(0xFFEA33F7),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 1),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: GridView.count(
                    crossAxisCount: 3,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    children: [
                      Image.asset("images/sohee1.jpg", fit: BoxFit.cover),
                      Image.asset("images/sohee2.jpg", fit: BoxFit.cover),
                      Image.asset("images/sohee3.jpg", fit: BoxFit.cover),
                      Image.asset("images/sohee4.jpg", fit: BoxFit.cover),
                      Image.asset("images/sohee5.jpg", fit: BoxFit.cover),
                      Image.asset("images/sohee6.jpg", fit: BoxFit.cover),
                      Image.asset("images/sohee7.jpg", fit: BoxFit.cover),
                      Image.asset("images/sohee8.jpg", fit: BoxFit.cover),
                      Image.asset("images/sohee9.jpg", fit: BoxFit.cover),
                      Image.asset("images/sohee10.jpg", fit: BoxFit.cover),
                      Image.asset("images/sohee11.jpg", fit: BoxFit.cover),
                      Image.asset("images/sohee12.jpg", fit: BoxFit.cover),
                    ],
                  ),
                ),
              ),
              Container(
                color: Colors.black,
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const HomepageScreen()),
                            );
                          },
                          child: const Icon(Icons.home_filled, color: Color(0xFFEA33F7), size: 30),
                        ),
                        const Icon(Icons.search, color: Color(0xFFEA33F7), size: 30),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const PostScreen()),
                            );
                          },
                          child: const Icon(Icons.add_box_outlined, color: Color(0xFFEA33F7), size: 30),
                        ),
                        const Icon(Icons.movie_outlined, color: Color(0xFFEA33F7), size: 30),
                        const CircleAvatar(
                          backgroundImage: AssetImage("images/avatar.jpg"),
                          radius: 15,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}