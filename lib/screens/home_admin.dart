// ignore_for_file: avoid_print, sized_box_for_whitespace, avoid_function_literals_in_foreach_calls

/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> userDataList = [];

  TextEditingController maxAuthorizedController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Data'),
        actions: [
          IconButton(
            onPressed: _signOut,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Input form for adding data
            Card(
              elevation: 5,
              margin: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextField(
                      controller: maxAuthorizedController,
                      keyboardType: TextInputType.number,
                      decoration:
                          const InputDecoration(labelText: 'Max Authorized'),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        _addData();
                      },
                      child: const Text('Add Data'),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        _pickDate();
                      },
                      child: const Text('Pick Date'),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Selected Date: ${selectedDate.toLocal()}',
                    ),
                  ],
                ),
              ),
            ),
            // Display user data
            userDataList.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: userDataList.length,
                    itemBuilder: (context, index) {
                      Timestamp timestamp = userDataList[index]['date'];
                      DateTime dateTime = timestamp.toDate();
                      int realAuthorised =
                          userDataList[index]['realAuthorised'];
                      int maximumAuthorised =
                          userDataList[index]['maximumAuthorised'];
                      return Card(
                        child: ListTile(
                          title: Text(
                              'Data for user with ID ${FirebaseAuth.instance.currentUser?.uid}:'),
                          subtitle: Text(
                            ' Real Authorised : $realAuthorised \n Date: $dateTime\n MaximumAuthorised: $maximumAuthorised',
                          ),
                        ),
                      );
                    },
                  )
                : const Center(child: CircularProgressIndicator()),
            // Chart
            Container(
              height: 200,
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                legend: const Legend(
                    isVisible: true), // Add this line to enable the legend
                series: <ChartSeries>[
                  // Renders bar chart
                  BarSeries<Map<String, dynamic>, String>(
                    name: 'Maximum Authorised', // Add a name for the series
                    dataSource: userDataList,
                    xValueMapper: (data, _) =>
                        'Date: ${data['date'].toDate().day}/${data['date'].toDate().month}',
                    yValueMapper: (data, _) => data['maximumAuthorised'],
                    // Enable data label
                    dataLabelSettings: const DataLabelSettings(isVisible: true),
                  ),
                  BarSeries<Map<String, dynamic>, String>(
                    name: 'Real Authorised', // Add a name for the series
                    dataSource: userDataList,
                    xValueMapper: (data, _) =>
                        'Date: ${data['date'].toDate().day}/${data['date'].toDate().month}',
                    yValueMapper: (data, _) => data['realAuthorised'],
                    // Enable data label
                    dataLabelSettings: const DataLabelSettings(isVisible: true),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String uid = user.uid;

        int maxAuthorized = int.parse(maxAuthorizedController.text);

        CollectionReference usersCollection =
            FirebaseFirestore.instance.collection('users');
        DocumentSnapshot userDocument = await usersCollection.doc(uid).get();

        if (userDocument.exists) {
          CollectionReference userDataCollection =
              userDocument.reference.collection('userData');

          await userDataCollection.add({
            'date': Timestamp.fromDate(selectedDate),
            'realAuthorised': 0, // You can set this to the actual value
            'maximumAuthorised': maxAuthorized,
          });

          // Refresh the displayed user data
          _displayUserData();
        } else {
          print('User document not found for user with ID $uid.');
        }
      } else {
        print('No user is currently logged in.');
      }
    } catch (e) {
      print('Error adding user data: $e');
    }
  }

  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  void _displayUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String uid = user.uid;
        CollectionReference usersCollection =
            FirebaseFirestore.instance.collection('users');
        DocumentSnapshot userDocument = await usersCollection.doc(uid).get();

        if (userDocument.exists) {
          CollectionReference userDataCollection =
              userDocument.reference.collection('userData');
          QuerySnapshot userDataSnapshot = await userDataCollection.get();

          if (userDataSnapshot.size > 0) {
            List<Map<String, dynamic>> dataList = [];
            userDataSnapshot.docs.forEach((doc) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              dataList.add(data);
            });

            setState(() {
              userDataList = dataList;
            });
          } else {
            print(
                'No data found in the userData subcollection for user with ID $uid.');
          }
        } else {
          print('User document not found for user with ID $uid.');
        }
      } else {
        print('No user is currently logged in.');
      }
    } catch (e) {
      print('Error retrieving user data: $e');
    }
  }

  void _signOut() async {
    await FirebaseAuth.instance.signOut();
    print("Signed Out");
  }

  @override
  void initState() {
    super.initState();
    _displayUserData();
  }
}*/

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> userDataList = [];

  TextEditingController maxAuthorizedController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  late DocumentSnapshot _currentUserDocument;
  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _displayUserData();
  }

  void _initializeNotifications() {
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('app_icon'),
    );

    _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void _showNotification(String title, String content) async {
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      importance: Importance.max,
      priority: Priority.high,
    );

    const platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.show(
      0,
      title,
      content,
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> combinedDataList = [];

    userDataList.forEach((data) {
      combinedDataList.add({
        'type': 'Maximum Authorized',
        'value': data['maximumAuthorised'],
      });
      combinedDataList.add({
        'type': 'Real Authorized',
        'value': data['realAuthorised'],
      });
    });
    // Scaffold and AppBar
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Data'),
        actions: [
          IconButton(
            onPressed: _signOut,
            icon: const Icon(Icons.logout),
          ),
          IconButton(
            onPressed: () {
              // You can add logic here to navigate to a notification history screen
            },
            icon: const Icon(Icons.notifications),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Input form for adding data
            Card(
              elevation: 5,
              margin: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextField(
                      controller: maxAuthorizedController,
                      keyboardType: TextInputType.number,
                      decoration:
                          const InputDecoration(labelText: 'Max Authorized'),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        _addData();
                      },
                      child: const Text('Add Data'),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        _pickDate();
                      },
                      child: const Text('Pick Date'),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Selected Date: ${selectedDate.toLocal()}',
                    ),
                  ],
                ),
              ),
            ),
            // Display user data
            userDataList.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: userDataList.length,
                    itemBuilder: (context, index) {
                      Timestamp timestamp = userDataList[index]['date'];
                      DateTime dateTime = timestamp.toDate();
                      int realAuthorised =
                          userDataList[index]['realAuthorised'];
                      int maximumAuthorised =
                          userDataList[index]['maximumAuthorised'];
                      return Card(
                        child: ListTile(
                          title: Text(
                              'Data for user with ID ${FirebaseAuth.instance.currentUser?.uid}:'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ' Real Authorised : $realAuthorised \n Date: $dateTime\n MaximumAuthorised: $maximumAuthorised',
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  _incrementRealAuthorized(
                                      _currentUserDocument.reference,
                                      userDataList[index]['documentId']);
                                },
                                child: const Text('Increment Real Authorized'),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : const Center(child: CircularProgressIndicator()),
            // Chart
            Container(
              height: 200,
              child: SfCircularChart(
                legend: const Legend(isVisible: true),
                series: <CircularSeries>[
                  // Renders pie chart for combined data
                  PieSeries<Map<String, dynamic>, String>(
                    name: 'Authorization Data',
                    dataSource: combinedDataList,
                    xValueMapper: (data, _) => data['type'],
                    yValueMapper: (data, _) => data['value'],
                    dataLabelMapper: (data, _) => '${data['value']}',
                    dataLabelSettings: const DataLabelSettings(isVisible: true),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String uid = user.uid;

        int maxAuthorized = int.parse(maxAuthorizedController.text);

        CollectionReference usersCollection =
            FirebaseFirestore.instance.collection('users');
        _currentUserDocument = await usersCollection.doc(uid).get();

        if (_currentUserDocument.exists) {
          CollectionReference userDataCollection =
              _currentUserDocument.reference.collection('userData');

          // ignore: unused_local_variable
          DocumentReference addedDocRef = await userDataCollection.add({
            'date': Timestamp.fromDate(selectedDate),
            'realAuthorised': 0,
            'maximumAuthorised': maxAuthorized,
          });

          // Refresh the displayed user data
          _displayUserData();
        } else {
          print('User document not found for user with ID $uid.');
        }
      } else {
        print('No user is currently logged in.');
      }
    } catch (e) {
      print('Error adding user data: $e');
    }
  }

  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  void _displayUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String uid = user.uid;
        CollectionReference usersCollection =
            FirebaseFirestore.instance.collection('users');
        _currentUserDocument = await usersCollection.doc(uid).get();

        if (_currentUserDocument.exists) {
          CollectionReference userDataCollection =
              _currentUserDocument.reference.collection('userData');
          QuerySnapshot userDataSnapshot = await userDataCollection.get();

          if (userDataSnapshot.size > 0) {
            List<Map<String, dynamic>> dataList = [];
            userDataSnapshot.docs.forEach((doc) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              data['documentId'] = doc.id;
              dataList.add(data);
            });

            setState(() {
              userDataList = dataList;
            });
          } else {
            print(
                'No data found in the userData subcollection for user with ID $uid.');
          }
        } else {
          print('User document not found for user with ID $uid.');
        }
      } else {
        print('No user is currently logged in.');
      }
    } catch (e) {
      print('Error retrieving user data: $e');
    }
  }

  void _incrementRealAuthorized(
      DocumentReference userDataReference, String documentId) async {
    try {
      DocumentSnapshot userDataDocument =
          await userDataReference.collection('userData').doc(documentId).get();

      if (userDataDocument.exists) {
        int realAuthorized = userDataDocument['realAuthorised'];
        int maximumAuthorized = userDataDocument['maximumAuthorised'];

        if (realAuthorized < maximumAuthorized) {
          await userDataReference
              .collection('userData')
              .doc(documentId)
              .update({
            'realAuthorised': realAuthorized + 1,
          });

          // Check for notifications
          if (realAuthorized + 1 == maximumAuthorized - 1) {
            _showNotification(
              'Space Almost Full',
              'The space is almost full. Please consider upgrading.',
            );
          } else if (realAuthorized + 1 == maximumAuthorized) {
            _showNotification(
              'Space Full',
              'The space is full. Please upgrade immediately.',
            );
          }

          // Refresh the displayed user data
          _displayUserData();
        } else {
          print('Real Authorized has reached the Maximum Authorized value.');
        }
      } else {
        print('User data document not found.');
      }
    } catch (e) {
      print('Error incrementing real authorized: $e');
    }
  }

  void _signOut() async {
    await FirebaseAuth.instance.signOut();
    print("Signed Out");
  }
}
