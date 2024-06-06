import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServices {
  final CollectionReference admins =
      FirebaseFirestore.instance.collection("admins");

  Stream<QuerySnapshot> getNotesStream() {
    final noteStream = admins.where('name', isEqualTo: 'Batman').snapshots();
    return noteStream;
  }
}

class Profile extends StatelessWidget {
  const Profile();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.white, Color(0xFFC5E7FF)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.6, 1.0])),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirestoreServices().getNotesStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            final data = snapshot.data?.docs; // Safely access the docs property
            if (data == null || data.isEmpty) {
              return Center(child: Text('No data available'));
            }
            // Use the data from Firestore here

            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final doc = data[index];
                final name1 = doc.get('name');
                return ListTile(
                  title: Text(name1), // Display the document data
                );
              },
            );
          },
        ),
      ),
    );
  }
}
