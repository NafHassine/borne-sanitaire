import 'package:bornesan/screens/home_user.dart';
import 'package:bornesan/screens/home_dmin.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:bornesan/reusable_widgets/reusable_widget.dart';
import 'package:bornesan/screens/reset_password.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bornesan/reusable_widgets/waitingwidget.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  SignInScreenState createState() => SignInScreenState();
}

class SignInScreenState extends State<SignInScreen> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  bool _isloading = false;

  Future<bool> isUserAdmin(String userId) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (doc.exists) {
        final Map<String, dynamic>? userData =
            doc.data() as Map<String, dynamic>?;
        final String userRole = userData?['role'] ?? '';
        return userRole.toLowerCase() == 'admin';
      }
      return false;
    } catch (error) {
      print("Error fetching user data: $error");
      return false;
    }
  }

  void navigateToHomeScreen() async {
    try {
      setState(() {
        _isloading = true;
      });
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
      } else {}
    } catch (error) {
      print("Error: $error");
    } finally {
      setState(() {
        _isloading = false;
      });
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
            colors: [
              Color.fromRGBO(135, 196, 255, 1.0),
              Color.fromRGBO(31, 109, 255, 1),
            ],
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
                false,
                _emailTextController,
              ),
              const SizedBox(
                height: 20,
              ),
              reusableTextField(
                "Enter Password",
                Icons.lock_outline,
                true,
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
              _isloading
                  ? const WaitingWidget()
                  : firebaseUIButton(context, "Sign In", navigateToHomeScreen),
            ]),
          ),
        ),
      ),
    );
  }
}
