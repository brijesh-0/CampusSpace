import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> clearNotifications() async {
    final user = _auth.currentUser;

    if (user != null) {
      final notificationsQuery = await _firestore
          .collection('notifications')
          .where('email', isEqualTo: user.email)
          .get();

      for (var doc in notificationsQuery.docs) {
        await doc.reference.delete();
      }

      setState(() {});
    }
  }

  Future<void> deleteNotification(String notificationId) async {
    try {
      await _firestore.collection('notifications').doc(notificationId).delete();
      setState(() {});
    } catch (e) {
      print('Failed to delete notification: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'My ',
                style: TextStyle(
                  fontSize: 26.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              TextSpan(
                text: 'Notifications',
                style: TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0066FF),
                ),
              ),
            ],
          ),
          textAlign: TextAlign.left,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              await clearNotifications();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 25.0),
        child: user != null
            ? StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('notifications')
                    .where('email', isEqualTo: user.email)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  final notifications = snapshot.data?.docs ?? [];
                  print(notifications);
                  if (notifications.isEmpty) {
                    return const Center(child: Text('No notifications'));
                  }

                  return ListView.builder(
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final notification = notifications[index];
                      final message = notification['message'];
                      final timestamp =
                          (notification['timestamp'] as Timestamp).toDate();
                      final formattedDate =
                          DateFormat.yMMMd().add_jm().format(timestamp);
                      return Dismissible(
                        key: Key(notification.id),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) async {
                          await deleteNotification(notification.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Notification dismissed')),
                          );
                        },
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        child: Container(
                          // Apply only a top border
                          decoration: const BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                  color: Color.fromARGB(255, 196, 196, 196),
                                  width: 1),
                              bottom: BorderSide(
                                  color: Color.fromARGB(255, 196, 196, 196),
                                  width: 1),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                          child: ListTile(
                            contentPadding:
                                EdgeInsets.zero, // Remove default padding
                            title: Text(
                              message,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Text(
                              formattedDate,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              )
            : const Center(child: Text('Please sign in to view notifications')),
      ),
    );
  }
}
