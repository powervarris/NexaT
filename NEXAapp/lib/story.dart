import 'package:flutter/material.dart';

class StoryScreen extends StatelessWidget {
  const StoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          SizedBox.expand(
            child: Image.asset(
              'images/storybg.png',
              fit: BoxFit.cover,
            ),
          ),

          // Top icons (close, flash, emoji)
          Positioned(
            top: 40,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Icon(Icons.close, color: Colors.pinkAccent),
                Icon(Icons.flash_on, color: Colors.pinkAccent),
                Icon(Icons.emoji_emotions, color: Colors.pinkAccent),
              ],
            ),
          ),

          // Right vertical buttons (text and layout)
          Positioned(
            top: 150,
            right: 12,
            child: Column(
              children: const [
                Icon(Icons.text_fields, color: Colors.pinkAccent, size: 28),
                SizedBox(height: 20),
                Icon(Icons.grid_view, color: Colors.pinkAccent, size: 28),
              ],
            ),
          ),

          // Capture button and Story label
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(color: Colors.black, width: 3),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Story",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),

          // Bottom left preview icon (just as a mock, static image)
          Positioned(
            bottom: 20,
            left: 20,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage('assets/story_bg.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
