import 'package:flutter/material.dart';
import 'package:nexaapp/accountcenter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nexaapp/login.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1F1E1E),
      appBar: AppBar(
        title:  Text(
          "Settings and activity",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFF1F1E1E),
        centerTitle: true,
        iconTheme:  IconThemeData(
          color: Color(0xFFEA33F7),
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16, 20, 16, 6),
            child: Text(
              'Your Account',
              style: TextStyle(
                color: Color(0xFFDEDBDB),
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.account_circle_outlined,
              color: Color(0xFFC0B2C1),
              size: 40,
            ),
            title: Text('Account Center',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                )
            ),
            subtitle: Text(
              'Password, security, personal details...',
              style: TextStyle(
                color: Color(0x80DED8DB),
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.chevron_right,
                color: Color(0xFF8A8888),
                size: 30,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AccountCenterScreen()),
                );
              },
            ),
          ),
          Divider(color: Color(0xFFEA33F7), thickness: 0.5),

          ListTile(
            leading: Icon(
              Icons.bookmark_border,
              color: Color(0xFFC0B2C1),
              size: 40,
            ),
            title: Text('Saved',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                )
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.chevron_right,
                color: Color(0xFF8A8888),
                size: 30,
              ),
              onPressed: () {},
            ),
          ),

          ListTile(
            leading: Icon(
              Icons.history,
              color: Color(0xFFC0B2C1),
              size: 40,
            ),
            title: Text('Archive',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                )
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.chevron_right,
                color: Color(0xFF8A8888),
                size: 30,
              ),
              onPressed: () {},
            ),
          ),

          ListTile(
            leading: Icon(
              Icons.notifications_none,
              color: Color(0xFFC0B2C1),
              size: 40,
            ),
            title: Text('Notifications',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                )
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.chevron_right,
                color: Color(0xFF8A8888),
                size: 30,
              ),
              onPressed: () {},
            ),
          ),
          Divider(color: Color(0xFFEA33F7), thickness: 0.5),

          ListTile(
            leading: Icon(
              Icons.lock_outline,
              color: Color(0xFFC0B2C1),
              size: 40,
            ),
            title: Text('Account Privacy',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                )
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.chevron_right,
                color: Color(0xFF8A8888),
                size: 30,
              ),
              onPressed: () {},
            ),
          ),

          ListTile(
            leading: Icon(
              Icons.block,
              color: Color(0xFFC0B2C1),
              size: 40,
            ),
            title: Text('Blocked',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                )
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.chevron_right,
                color: Color(0xFF8A8888),
                size: 30,
              ),
              onPressed: () {},
            ),
          ),

          ListTile(
            leading: Icon(
              Icons.visibility_off_outlined,
              color: Color(0xFFC0B2C1),
              size: 40,
            ),
            title: Text('Hide Story',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                )
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.chevron_right,
                color: Color(0xFF8A8888),
                size: 30,
              ),
              onPressed: () {},
            ),
          ),
          Divider(color: Color(0xFFEA33F7), thickness: 0.5),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
          ),

          ListTile(
            title: Text('Login',
                style: TextStyle(
                  color: Color(0xFF8A8888),
                  fontWeight: FontWeight.bold,
                )
            ),
          ),

          ListTile(
            title: Text('Add Account',
                style: TextStyle(
                  color: Color(0xFF7806A4),
                  fontWeight: FontWeight.bold,
                )
            ),
          ),

          ListTile(
            title: Text('Log out',
                style: TextStyle(
                  color: Color(0xFF8D3C3C),
                  fontWeight: FontWeight.bold,
                )
            ),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => LoginScreen()),
                    (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}