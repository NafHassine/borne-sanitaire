// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth if not already imported
import 'package:bornesan/screens/signin.dart';
import 'package:bornesan/utils/color_utils.dart';
import 'package:bornesan/screens/user_list.dart';
/*import 'package:bornesan/screens/signup.dart';*/

class HomeScreenuser extends StatefulWidget {
  const HomeScreenuser({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreenuser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Screen"),
        backgroundColor: Colors.grey,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 202, 4, 146),
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              leading: const Icon(Icons.account_box_outlined),
              title: const Text('Users Interface '),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Userlist()));
              },
            ),
            const ListTile(
              leading: Icon(Icons.bar_chart_outlined),
              title: Text('Statistics'),
            ),
            ListTile(
              leading: const Icon(Icons.logout_outlined),
              title: const Text('Sign Out'),
              onTap: () {
                FirebaseAuth.instance.signOut().then((value) {
                  print("Signed Out");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignInScreen()));
                });
              },
            ),
          ],
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
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.2, 20, 0),
            child: const Column(
              children: <Widget>[
                // Your main content goes here
              ],
            ),
          ),
        ),
      ),
    );
  }
}
