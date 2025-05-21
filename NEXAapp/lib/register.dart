import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nexaapp/login.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: registerForm(),
    );
  }
}

class registerForm extends StatefulWidget {
  const registerForm({super.key});

  @override
  State<registerForm> createState() => _registerFormState();
}

class _registerFormState extends State<registerForm> {
  @override

  var usernameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Register',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF3B3B3B),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      backgroundColor: Color(0xFF1F1E1E),
      body: Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'images/nexa-logo-no-glow.png',
              height: 150,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Username',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                ),
              ),
            ),
            SizedBox(height: 5),
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xFF7C7979),// Background color
                hintText: 'Enter your username',
                hintStyle: TextStyle(
                    color: Color(0xFF47135C)
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                      color: Color(0xFF7C7979),
                      width: 3
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                      color: Color(0xFF47135C),
                      width: 3
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Email',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                ),
              ),
            ),
            SizedBox(height: 5),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xFF7C7979),// Background color
                hintText: 'Enter your email',
                hintStyle: TextStyle(
                    color: Color(0xFF47135C)
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                      color: Color(0xFF7C7979),
                      width: 3
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                      color: Color(0xFF47135C),
                      width: 3
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Password',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                ),
              ),
            ),
            SizedBox(height: 5),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xFF7C7979),// Background color
                hintText: 'Enter your password',
                hintStyle: TextStyle(
                    color: Color(0xFF47135C)
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                      color: Color(0xFF7C7979),
                      width: 3
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                      color: Color(0xFF47135C),
                      width: 3
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Confirm Password',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                ),
              ),
            ),
            SizedBox(height: 5),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xFF7C7979),// Background color
                hintText: 'Enter your Password again',
                hintStyle: TextStyle(
                    color: Color(0xFF47135C)
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                      color: Color(0xFF7C7979),
                      width: 3
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                      color: Color(0xFF47135C),
                      width: 3
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            // Align (
            //   alignment: Alignment.center,
            //   child:
            //   TextButton (
            //     onPressed: () {
            //       // TODO: Handle forgot password
            //     },
            //     child:
            //     Text (
            //       'Forgot password?',
            //       style: TextStyle (
            //         decoration: TextDecoration.underline,
            //         color: Colors.blue,
            //       ),
            //     ),
            //   ),
            // ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 170,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFAC97FF),
                    ),
                    onPressed: () async {
                      var username = usernameController.text;
                      var emailAdd = emailController.text;
                      var password = passwordController.text;
                      var confirmPassword = confirmPasswordController.text;

                      if (username.isEmpty || emailAdd.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Enter all details!'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      if (password != confirmPassword) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Passwords do not match!'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      try{
                         UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                            email: emailAdd,
                            password: password
                        );

                        await FirebaseFirestore.instance.collection('tbl_users').doc(userCredential.user?.uid).set({
                          'userid' : userCredential.user?.uid,
                          'username': username,
                          'email': emailAdd,
                          'no_of_followers': 0,
                          'no_of_following': 0,
                          'bio': '',
                          'profile_pic': '',
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Registration successful!'),
                            backgroundColor: Colors.green,
                          ),
                        );

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      }catch(e){
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Registration failed: ${e.toString()}'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    child: Text(
                      'Register',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

