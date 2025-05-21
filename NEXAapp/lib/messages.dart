import 'package:flutter/material.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F1E1E),
      body: Stack(
        children: [
          // Background top wave
          Positioned(
            top: 130,
            left: 0,
            right: 0,
            child: Image.asset(
              'images/bgtop.png',
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),

          // Background bottom wave
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'images/nexabottom.png',
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),

          // Foreground content
          SafeArea(
            child: Column(
              children: [
                // Top bar with logo and edit icon
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        'images/nexaLogo.png',
                        height: 40,
                      ),
                      const Icon(Icons.edit, color: Colors.purpleAccent),
                    ],
                  ),
                ),

                // Search bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade800.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Search',
                        hintStyle: TextStyle(color: Colors.grey.shade400),
                        border: InputBorder.none,
                        prefixIcon: const Icon(Icons.search, color: Colors.purpleAccent),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Story bubbles
                SizedBox(
                  height: 60,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: 8,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.purpleAccent,
                        child: CircleAvatar(
                          radius: 23,
                          backgroundColor: Colors.grey[800],
                          backgroundImage: const AssetImage('images/avatar.png'),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Messages list
                Expanded(
                  child: ListView(
                    children: const [
                      MessageTile(
                        username: 'Gio',
                        message: 'Where are you?',
                        time: '3m ago',
                        avatar: 'images/avatar.png',
                      ),
                      MessageTile(
                        username: 'Jean',
                        message: 'did you hear about…',
                        time: '3m ago',
                        avatar: 'images/avatar.png',
                      ),
                      // Add more messages here if needed
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String username;
  final String message;
  final String time;
  final String avatar;

  const MessageTile({
    super.key,
    required this.username,
    required this.message,
    required this.time,
    required this.avatar,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 25,
        backgroundImage: AssetImage(avatar),
      ),
      title: Text(
        username,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        '$message • $time',
        style: TextStyle(color: Colors.grey.shade400),
      ),
      trailing: const Icon(Icons.camera_alt, color: Colors.purpleAccent),
    );
  }
}
