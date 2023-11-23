// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:bornesan/screens/home_admin.dart';
import 'package:bornesan/screens/home_superadmin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bornesan/reusable_widgets/reusable_widget.dart';
import 'package:bornesan/screens/reset_password.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  SignInScreenState createState() => SignInScreenState();
}

class SignInScreenState extends State<SignInScreen> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();

  Future<bool> isUserAdmin(String userId) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (doc.exists) {
        final Map<String, dynamic>? userData =
            doc.data() as Map<String, dynamic>?; // Cast to the expected type
        final String userRole = userData?['role'] ?? '';
        // ...
        // Assuming 'role' is the field name
        // Check if the user's role is 'admin'
        return userRole.toLowerCase() == 'admin';
      }
      return false; // User not found in Firestore, assume not an admin
    } catch (error) {
      print("Error fetching user data: $error");
      return false; // Handle the error appropriately
    }
  }

  void navigateToHomeScreen() async {
    try {
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailTextController.text,
        password: _passwordTextController.text,
      );

      final User? user = userCredential.user;

      if (user != null) {
        final bool isAdmin = await isUserAdmin(user.uid);
        print(isAdmin);
        final Widget targetScreen =
            isAdmin ? const HomeScreenuser() : const HomeScreen();

        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => targetScreen,
        ));
      } else {
        // Handle authentication failure
      }
    } catch (error) {
      print("Error: $error");
      // Handle authentication error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF49A078), Color(0xFF216869)], // Mix of colors
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.2, 20, 0),
            child: Column(children: <Widget>[
              logoWidget("assets/images/lock2.png"),
              const SizedBox(
                height: 30,
              ),
              reusableTextField(
                "Enter Your Email",
                Icons.person_outline,
                false, // White text on custom background
                _emailTextController,
              ),
              const SizedBox(
                height: 20,
              ),
              reusableTextField(
                "Enter Password",
                Icons.lock_outline,
                false, // White text on custom background
                _passwordTextController,
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 35,
                alignment: Alignment.bottomRight,
                child: TextButton(
                  child: const Text(
                    "Forgot Password?",
                    style: TextStyle(color: Colors.white70),
                    textAlign: TextAlign.right,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const ResetPassword()),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              firebaseUIButton(context, "Sign In", navigateToHomeScreen),
            ]),
          ),
        ),
      ),
    );
  }
}
