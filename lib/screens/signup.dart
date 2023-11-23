// ignore_for_file: avoid_print

/*import 'package:bornesan/screens/home_superadmin.dart';
/*import 'package:bornesan/screens/signin.dart';*/
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bornesan/reusable_widgets/reusable_widget.dart';
import 'package:bornesan/utils/color_utils.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _userNameTextController = TextEditingController();
  final TextEditingController _userRoleTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Add User",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            hexStringToColor("CB2B93"),
            hexStringToColor("9546C4"),
            hexStringToColor("5E61F4")
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter UserName", Icons.person_outline, false,
                    _userNameTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Email Id", Icons.mail_outline, false,
                    _emailTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Password", Icons.lock_outlined, true,
                    _passwordTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Role", Icons.assignment_ind, false,
                    _userRoleTextController),
                const SizedBox(
                  height: 20,
                ),
                firebaseUIButton(context, "Sign Up", () {
                  FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                          email: _emailTextController.text,
                          password: _passwordTextController.text)
                      .then((value) {
                    print("Created New Account");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreenuser()));
                  }).onError((error, stackTrace) {
                    print("Error ${error.toString()}");
                  });
                })
              ],
            ),
          ))),
    );
  }
}*/

/*import 'package:bornesan/screens/home_superadmin.dart';*/
/*import 'package:bornesan/screens/signin.dart';*/
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bornesan/reusable_widgets/reusable_widget.dart';
import 'package:bornesan/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _userNameTextController = TextEditingController();
  String _selectedRole = 'User'; // Initial role selection
  final List<String> _roles = ['User', 'Admin', 'Superadmin']; // List of roles

  Color semiTransparentGrey =
      Colors.grey.withOpacity(0.7); // Adjust the opacity (0.7) as needed

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
                Navigator.of(context).pop(); // Close the dialog
                _userNameTextController.clear(); // Clear the username field
                _emailTextController.clear(); // Clear the email field
                _passwordTextController.clear(); // Clear the password field
                setState(() {
                  _selectedRole = 'User'; // Reset the role selection to 'User'
                });
              },
            ),
          ],
        );
      },
    );
  }

  void saveUserDataToFirestore() {
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: _emailTextController.text,
      password: _passwordTextController.text,
    )
        .then((authResult) {
      // User registration successful
      print("Created New Account");

      // Get the current user's ID
      String userId = authResult.user?.uid ?? "";

      // Reference to your Firestore collection
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');

      // Add user data to Firestore
      users.doc(userId).set({
        'userName': _userNameTextController.text,
        'email': _emailTextController.text,
        'role': _selectedRole,
        // Add other user data as needed
      }).then((_) {
        print("User data added to Firestore");
      }).catchError((error) {
        print("Error adding user data to Firestore: $error");
      });

      // Show success dialog
      showSuccessDialog(context);
    }).catchError((error) {
      print("Error creating new account: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Add User",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            hexStringToColor("CB2B93"),
            hexStringToColor("9546C4"),
            hexStringToColor("5E61F4"),
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
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
                reusableTextField("Enter Email Id", Icons.mail_outline, false,
                    _emailTextController),
                const SizedBox(height: 20),
                reusableTextField("Enter Password", Icons.lock_outlined, true,
                    _passwordTextController),
                const SizedBox(height: 20),
                // DropdownButtonFormField for Role
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: semiTransparentGrey,
                          width: 2), // Change to semi-transparent grey
                      borderRadius: BorderRadius.circular(20),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: semiTransparentGrey,
                          width: 2), // Change to semi-transparent grey
                      borderRadius: BorderRadius.circular(20),
                    ),
                    filled: true,
                    fillColor:
                        semiTransparentGrey, // Change to semi-transparent grey
                  ),
                  dropdownColor:
                      semiTransparentGrey, // Change to semi-transparent grey
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
