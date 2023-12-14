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
      body: Container(
        color: Colors.white, // Set your desired background color here
        child: SingleChildScrollView(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  navigateToAnotherPage();
                },
                child: const Text('Add a User'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(10),
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: usersCollection.snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }
                  final users = snapshot.data?.docs;

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('email')),
                        DataColumn(label: Text('role')),
                        DataColumn(label: Text('userName')),
                        DataColumn(label: Text('Actions')),
                      ],
                      rows: users!.map((userDocument) {
                        final user =
                            userDocument.data() as Map<String, dynamic>;
                        final userId = userDocument.id;

                        return DataRow(
                          cells: [
                            DataCell(
                              Text(
                                user['email'],
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                            DataCell(
                              Text(
                                user['role'],
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                            DataCell(
                              Text(
                                user['userName'],
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                            DataCell(
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title:
                                            const Text('Delete this account?'),
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
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
