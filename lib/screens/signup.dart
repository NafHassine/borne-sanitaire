// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:bornesan/reusable_widgets/reusable_widget.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'package:bornesan/screens/mail.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _userNameTextController = TextEditingController();
  String _selectedRole = 'User';
  final List<String> _roles = ['User', 'Admin'];
  Color semiTransparentGrey = Colors.grey.withOpacity(0.7);

  String generateRandomPassword(int length) {
    const charset =
        "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/*-_@=+&#";
    final random = Random.secure();

    return List.generate(
        length, (index) => charset[random.nextInt(charset.length)]).join();
  }

  void showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Success"),
          content: const Text("New Account Created successfully"),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
                _userNameTextController.clear();
                _emailTextController.clear();
                _passwordTextController.clear();
                setState(() {
                  _selectedRole = 'User';
                });
              },
            ),
          ],
        );
      },
    );
  }

  void saveUserDataToFirestore() {
    String temporaryPassword =
        _passwordTextController.text; // Use the provided password

    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: _emailTextController.text,
      password: temporaryPassword,
    )
        .then((authResult) {
      String userId = authResult.user?.uid ?? "";
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');

      users.doc(userId).set({
        'userName': _userNameTextController.text,
        'email': _emailTextController.text,
        'role': _selectedRole,
        'profilePhotoUrl':
            'assets/images/default_profile.jpg', // Set a default URL
      }).then((_) {
        print("User data added to Firestore");
        sendEmail(
          _userNameTextController.text,
          _emailTextController.text,
          _selectedRole,
          temporaryPassword,
          context,
        );

        showSuccessDialog(context);
      }).catchError((error) {
        print("Error adding user data to Firestore: $error");
      });
    }).catchError((error) {
      print("Error creating new account: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(0, 249, 249, 249),
        elevation: 0,
        title: const Text(
          "Add User",
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0xFF49A078), Color(0xFF216869)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 20),
                reusableTextField("Enter UserName", Icons.person_outline, false,
                    _userNameTextController),
                const SizedBox(height: 20),
                reusableTextField("Enter Email ", Icons.mail_outline, false,
                    _emailTextController),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: reusableTextField("Enter Password",
                          Icons.lock_outlined, false, _passwordTextController),
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: () {
                        setState(() {
                          _passwordTextController.text =
                              generateRandomPassword(6);
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: semiTransparentGrey, width: 2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: semiTransparentGrey, width: 2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    filled: true,
                    fillColor: semiTransparentGrey,
                  ),
                  dropdownColor: semiTransparentGrey,
                  value: _selectedRole,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedRole = newValue!;
                    });
                  },
                  items: _roles.map((String role) {
                    return DropdownMenuItem<String>(
                      value: role,
                      child: Text(
                        role,
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                firebaseUIButton(context, "Add User", saveUserDataToFirestore),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
