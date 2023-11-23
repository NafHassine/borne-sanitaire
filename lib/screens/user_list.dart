// ignore_for_file: avoid_print, use_build_context_synchronously, await_only_futures

/*import 'package:firebase_ui_auth/firebase_ui_auth.dart';*/
/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bornesan/screens/signup.dart';

class Userlist extends StatefulWidget {
  const Userlist({super.key});

  @override
  State<Userlist> createState() => UserlistState();
}

class UserlistState extends State<Userlist> {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //delete a user
  Future<void> deleteUser(String userId) async {
    // 1. Delete the user from Firebase Authentication
    try {
      final user = await _auth.currentUser;

      if (user != null) {
        // Check if the user to be deleted is the currently signed-in user
        if (user.uid == userId) {
          // Sign out the user if trying to delete the signed-in user
          await _auth.signOut();
          // Set user.uid to userId if they are not the same
          await user.delete();
        }
      }

      // 2. Delete the user's data from Firestore
      await usersCollection.doc(userId).delete();
    } catch (e) {
      print("Error deleting user: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users Interface'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: usersCollection.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }
          final users = snapshot.data?.docs;

          return DataTable(
            columns: const [
              DataColumn(label: Text('email')),
              DataColumn(label: Text('role')),
              DataColumn(label: Text('userName')),
              DataColumn(label: Text('Actions')),
            ],
            rows: users!.map((userDocument) {
              final user = userDocument.data() as Map<String, dynamic>;
              final userId = userDocument.id;

              return DataRow(
                cells: [
                  DataCell(Text(user['email'])),
                  DataCell(Text(user['role'])),
                  DataCell(Text(user['userName'])),
                  DataCell(
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Delete this account?'),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('Return'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: const Text('Delete'),
                                  onPressed: () async {
                                    await deleteUser(userId);
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            }).toList(),
          );
        },
      ),
    );
  }
}*/

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bornesan/screens/signup.dart';

class Userlist extends StatefulWidget {
  const Userlist({super.key});

  @override
  State<Userlist> createState() => UserlistState();
}

class UserlistState extends State<Userlist> {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<String> roleChoices = ['User', 'Admin'];
  String selectedRole = 'User';

  Future<void> deleteUser(String userId) async {
    try {
      final user = await _auth.currentUser;

      if (user != null) {
        if (user.uid == userId) {
          await _auth.signOut();
          await user.delete();
        }
      }

      await usersCollection.doc(userId).delete();
    } catch (e) {
      print("Error deleting user: $e");
    }
  }

  Future<void> updateUser(String userId, String newEmail, String newRole,
      String newUserName) async {
    try {
      await usersCollection.doc(userId).update({
        'email': newEmail,
        'role': newRole,
        'userName': newUserName,
      });
    } catch (e) {
      print("Error updating user: $e");
    }
  }

  // Function to navigate to another page
  void navigateToAnotherPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignUpScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users Interface'),
      ),
      body: Column(
        children: [
          // Button to navigate to another page
          ElevatedButton(
            onPressed: () {
              navigateToAnotherPage();
            },
            child: const Text('Add a User'),
          ),
          // StreamBuilder for user data
          StreamBuilder<QuerySnapshot>(
            stream: usersCollection.snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              }
              final users = snapshot.data?.docs;

              return DataTable(
                columns: const [
                  DataColumn(label: Text('email')),
                  DataColumn(label: Text('role')),
                  DataColumn(label: Text('userName')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: users!.map((userDocument) {
                  final user = userDocument.data() as Map<String, dynamic>;
                  final userId = userDocument.id;

                  return DataRow(
                    cells: [
                      DataCell(Text(user['email'])),
                      DataCell(Text(user['role'])),
                      DataCell(Text(user['userName'])),
                      DataCell(
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    TextEditingController emailController =
                                        TextEditingController(
                                            text: user['email']);
                                    TextEditingController userNameController =
                                        TextEditingController(
                                            text: user['userName']);

                                    return StatefulBuilder(
                                      builder: (context, setState) {
                                        return AlertDialog(
                                          title: const Text('Update user data'),
                                          content: Column(
                                            children: [
                                              TextField(
                                                controller: emailController,
                                                decoration: const InputDecoration(
                                                    labelText: 'New Email'),
                                              ),
                                              DropdownButton<String>(
                                                value: selectedRole,
                                                onChanged: (String? newValue) {
                                                  setState(() {
                                                    selectedRole = newValue!;
                                                  });
                                                },
                                                items: roleChoices.map<
                                                        DropdownMenuItem<
                                                            String>>(
                                                    (String value) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: value,
                                                    child: Text(value),
                                                  );
                                                }).toList(),
                                                hint: const Text('Select Role'),
                                              ),
                                              TextField(
                                                controller: userNameController,
                                                decoration: const InputDecoration(
                                                    labelText: 'New Username'),
                                              ),
                                            ],
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              child: const Text('Cancel'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            TextButton(
                                              child: const Text('Update'),
                                              onPressed: () async {
                                                await updateUser(
                                                    userId,
                                                    emailController.text,
                                                    selectedRole,
                                                    userNameController.text);
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Delete this account?'),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text('Return'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          child: const Text('Delete'),
                                          onPressed: () async {
                                            await deleteUser(userId);
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
